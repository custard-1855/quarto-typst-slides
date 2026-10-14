# CLAUDE.md

Quarto + Typst (Touying) のスライドテンプレート。使い方と書き方は README.md にある。

## キックオフ

メモや資料から新しい発表の初稿を作るときは、着手する前に [docs/kickoff.md](docs/kickoff.md) を読み、その手順で進める。

## 編集

- 本文は `slides.qmd`、見た目は `typst/` を編集する。`slides.typ` は `make` のたびに作り直される生成物なので、直接編集しても上書きされる
- 変更したら `make` でビルドし、docs/kickoff.md のステップ 4 の方法で全ページを目で確かめる
- Mac で出る `unknown font family: noto sans cjk jp` の警告は、CI 用の代替フォントが無いだけなので、フォント指定はそのままにする
