$-- Quarto の biblio.typ を上書きする。
$-- 参考文献の一覧は ::: {#refs} の位置に typst/filters.lua が出すので、ここでは置かれなかったときだけ末尾に出す
$-- (文献スタイルの設定は typst/typst-show.typ)
$if(citations)$
$if(bibliography)$
$if(refs-placed)$
$else$

#bibliography(($for(bibliography)$"$bibliography$"$sep$,$endfor$))
$endif$
$endif$
$endif$
