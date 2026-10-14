-- Quarto の Typst 出力が対応していない Markdown の書き方を Typst に変換する

-- "50%" → "50fr"。幅の指定がなければ均等割り
local function column_width(col)
  local w = col.attributes.width
  if w and w:match("^%d+%%$") then
    return w:sub(1, -2) .. "fr"
  end
  return "1fr"
end

local function convert_div(el)

  -- `::: {.notes}` → Touying の #speaker-note[...] (pdfpc の発表者画面に表示される)
  if el.classes:includes("notes") then
    local blocks = pandoc.Blocks({ pandoc.RawBlock("typst", "#speaker-note[") })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock("typst", "]"))
    return blocks
  end

  -- `:::: {.columns}` + `::: {.column width="50%"}` → #grid(...)
  if el.classes:includes("columns") then
    local widths = {}
    local blocks = pandoc.Blocks({})
    for _, col in ipairs(el.content) do
      if col.t == "Div" and col.classes:includes("column") then
        table.insert(widths, column_width(col))
        blocks:insert(pandoc.RawBlock("typst", "["))
        blocks:extend(col.content)
        blocks:insert(pandoc.RawBlock("typst", "],"))
      end
    end
    blocks:insert(1, pandoc.RawBlock("typst",
      "#grid(columns: (" .. table.concat(widths, ", ") .. ",), gutter: 1em,"))
    blocks:insert(pandoc.RawBlock("typst", ")"))
    return blocks
  end
end

-- `::: {#refs}` を置いたスライドに参考文献の一覧を出す。
-- 置かなければ Quarto の標準どおり末尾に出す (typst/biblio.typ)
local function place_bibliography(doc)
  local bib = doc.meta.bibliography
  if not bib then
    return nil
  end
  local paths = {}
  for _, b in ipairs(bib.t == "MetaList" and bib or { bib }) do
    table.insert(paths, '"' .. pandoc.utils.stringify(b) .. '"')
  end
  local placed = false
  doc.blocks = doc.blocks:walk({
    Div = function(el)
      if el.identifier == "refs" then
        placed = true
        -- タイトルはスライドの見出しがあるので出さない
        return pandoc.RawBlock("typst",
          "#bibliography((" .. table.concat(paths, ", ") .. ",), title: none)")
      end
    end,
  })
  doc.meta["refs-placed"] = placed
  return doc
end

if not FORMAT:match("typst") then
  return {}
end

return {
  { Div = convert_div },
  { Pandoc = place_bibliography },
}
