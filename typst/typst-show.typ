#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title,
  config-info(
    title: [$title$],
$if(subtitle)$
    subtitle: [$subtitle$],
$endif$
$if(by-author)$
    author: [$for(by-author)$$it.name.literal$$sep$, $endfor$],
$endif$
$if(date)$
    date: [$date$],
$endif$
$if(institution)$
    institution: [$institution$],
$endif$
  ),
)

// macOS ではヒラギノ、無い環境 (CI の Ubuntu など) では Noto Sans CJK JP を使う
#set text(
  font: ("Hiragino Kaku Gothic ProN", "Noto Sans CJK JP"),
  lang: "ja",
  size: 20pt,
)
// コード用フォントには和文が無いので、和文フォントにフォールバックさせる
#show raw: set text(font: ("DejaVu Sans Mono", "Hiragino Kaku Gothic ProN", "Noto Sans CJK JP"))
#set par(justify: true, leading: 0.8em)
#set table(inset: 10pt, stroke: 0.5pt + gray)

// 出典表記。slides.qmd では `#src[〇〇より]`{=typst} のように書く
#let src(body) = text(size: 12pt, fill: gray)[出典: #body]

$if(csl)$
#set bibliography(style: "$csl$")
$elseif(bibliographystyle)$
#set bibliography(style: "$bibliographystyle$")
$endif$

$if(pdfpc-duration)$
// pdfpc のタイマー (分)
#pdfpc.config(duration-minutes: $pdfpc-duration$)
$endif$

#title-slide()
