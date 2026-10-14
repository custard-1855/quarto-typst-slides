# make        : PDF と pdfpc 用ファイルを生成
# make present: pdfpc で発表 (発表者画面にノート・次スライド・タイマー)
# make watch  : 保存するたびに再生成してプレビュー
# make sample : docs/sample.pdf を更新

DECK ?= slides

all: $(DECK).pdfpc

$(DECK).pdf $(DECK).typ: $(DECK).qmd _quarto.yml $(wildcard typst/*) $(wildcard images/*) $(wildcard *.bib)
	quarto render $(DECK).qmd

# quarto typst は typst の出力を (警告と一緒に) stderr に流すので、JSON の行だけ取り出す
$(DECK).pdfpc: $(DECK).typ $(DECK).pdf
	quarto typst query $(DECK).typ --field value --one "<pdfpc-file>" 2>&1 >/dev/null \
		| grep '^{"pdfpcFormat"' > $@

present: $(DECK).pdfpc
	pdfpc $(DECK).pdf

# README から見られるサンプル PDF を更新する
sample: $(DECK).pdf
	cp $(DECK).pdf docs/sample.pdf

watch:
	quarto preview $(DECK).qmd

clean:
	rm -f $(DECK).pdf $(DECK).typ $(DECK).pdfpc

.PHONY: all present sample watch clean
