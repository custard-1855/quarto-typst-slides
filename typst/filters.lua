-- Quarto の Typst 出力が対応していない Markdown の書き方を Typst に変換する

-- "50%" → "50fr"。幅の指定がなければ均等割り
local function column_width(col)
  local w = col.attributes.width
  if w and w:match("^%d+%%$") then
    return w:sub(1, -2) .. "fr"
  end
  return "1fr"
end

function Div(el)
  if not FORMAT:match("typst") then
    return nil
  end

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
