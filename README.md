# Quarto + Typst スライドテンプレート

Markdown (Quarto) で書いて、Typst + [Touying](https://touying-typ.github.io/) で PDF のスライドを作るテンプレートです。発表には [pdfpc](https://pdfpc.github.io/) を使い、発表者画面にスピーカーノート・次のスライド・タイマーを表示します。

このテンプレートのサンプルスライドをビルドした PDF: [docs/sample.pdf](docs/sample.pdf)

## 必要なもの

- [Quarto](https://quarto.org/) 1.9 以降 (Typst は Quarto に同梱されている)
- pdfpc (発表するときだけ): `brew install pdfpc`
- make

## セットアップ

Mac で、何も入っていない状態からコマンドで始める手順です。`my-talk` は好きなリポジトリ名に変えてください。

```sh
# 1. Homebrew を入れる (git と make もこのとき一緒に入る)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Quarto・pdfpc・GitHub CLI を入れる
brew install --cask quarto
brew install pdfpc gh

# 3. GitHub にログインし、このテンプレートから発表用のリポジトリを作る
gh auth login
gh repo create my-talk --template custard-1855/quarto-typst-slides --private --clone
cd my-talk

# 4. ビルドして PDF を開く
make
open slides.pdf
```

- Homebrew がすでにあるなら 1 は飛ばします。1 の `eval` の行は、インストーラが最後に表示する「Next steps」の指示と同じものです。新しいターミナルでも `brew` を使えるようにするには、その指示どおり `~/.zprofile` にも書き足します
- 最初の `make` で Touying が自動でダウンロードされるので、ネットにつながった状態で実行します

## 使い方

1. GitHub で「Use this template」から新しいリポジトリを作る (コマンドで作るなら「セットアップ」の 3)
2. `slides.qmd` の先頭 (タイトル・発表者名・日付・発表時間) を書き換え、本文を書く
3. ビルドして発表する

```sh
make          # slides.pdf と slides.pdfpc を生成
make present  # pdfpc で発表
make watch    # 保存するたびに再生成してプレビュー
make clean    # 生成物を削除
```

`slides.qmd` 以外の名前にしたいときは `make DECK=talk` のように指定します (`_quarto.yml` の `render:` も合わせて変更)。

## 書き方

`slides.qmd` に、以下の書き方の例を一通り入れてあります。

| やりたいこと | 書き方 |
|---|---|
| セクション区切り | `# 見出し` |
| スライド 1 枚 | `## 見出し` |
| 2段組 | `:::: {.columns}` の中に `::: {.column width="50%"}` を並べる |
| 段階表示 | `` `#pause`{=typst} `` |
| 文献の引用 | `[@knuth1984]` (文献は `references.bib` に書く) |
| 参考文献の一覧 | `::: {#refs}` と `:::` を置いたスライドに出る |
| 出典表記 | `` `#src[〇〇より]`{=typst} `` |
| スピーカーノート | `::: {.notes}` |
| Typst を直接書く | ` ```{=typst} ` のコードブロック |

スピーカーノートはスライドには表示されず、pdfpc の発表者画面にだけ出ます。

### 文献の引用

BibTeX の文献を `references.bib` に書き、`slides.qmd` で `[@キー]` のように引用します。組版は Typst が行います (Pandoc の citeproc は使わない)。

- 文献スタイルは `slides.qmd` の先頭で `bibliographystyle: apa` のように指定します。省略すると番号式の `ieee` です。指定できる名前は [Typst のドキュメント](https://typst.app/docs/reference/model/bibliography/) にあります。`csl: 〇〇.csl` で CSL ファイルも使えます
- 一覧は `::: {#refs}` を置いたスライドに出ます。置かなければ最後のスライドの末尾に出ます
- 日本語の著者名は `author = {{山田 太郎}}` のように二重の括弧で囲みます。囲まないと「名 姓」の順と解釈され、「太郎」のように表示されます
- 文献をスライドの下に出典として添えるなら `` `#src[#cite(<キー>, form: "full")]`{=typst} `` と書きます

## pdfpc の操作

| 操作 | キー |
|---|---|
| 次へ / 前へ | `→` / `←` (スペース、クリックでも進む) |
| タイマー開始 / 一時停止・再開 | `s` / `p` |
| スクリーンを暗くする | `b` (`Esc` で戻る) |
| PDF を再読み込み | `Ctrl+r` |
| キー操作の一覧 | `?` |
| 終了 | `Ctrl+q` |

- 発表者画面とスクリーン側が逆になったら `pdfpc -s slides.pdf` で入れ替える
- リハーサルには `pdfpc -w both slides.pdf` (両方ウィンドウ表示) が便利

## ファイル構成

```
slides.qmd               スライド本体
_quarto.yml              出力形式の設定
typst/typst-show.typ     テーマ・フォント・出典表記などの設定
typst/typst-template.typ Touying の読み込み
typst/page.typ           (空: ページ設定は Touying が行う)
typst/biblio.typ         参考文献の一覧の出し方 (Quarto の標準を上書き)
typst/filters.lua        .notes・.columns・#refs を Typst に変換する
references.bib           参考文献
images/                  画像置き場
Makefile                 ビルドと発表のコマンド
.github/workflows/       GitHub Actions で PDF をビルド
CLAUDE.md                Claude Code 向けの指示
docs/sample.pdf          サンプルスライドの PDF (make sample で更新)
docs/kickoff.md          メモから初稿を作るときの手順 (Claude Code が質問しながら進める)
```

Claude Code でメモから初稿を作るときは、メモを渡して「スライドの叩き台を作って」と頼むと、`docs/kickoff.md` の手順で発表時間・聞き手・構成などを質問してから書き始めます。

テーマ (色・フォントサイズなど) を変えるときは `typst/typst-show.typ` を編集します。Touying の metropolis テーマを使っているので、別のテーマにするなら `typst/typst-template.typ` の `themes.metropolis` と `typst/typst-show.typ` の `metropolis-theme` を書き換えてください。

## GitHub Actions

push するたびに PDF と pdfpc 用ファイルをビルドし、Actions の実行結果の Artifacts (`slides`) に保存します。Ubuntu にはヒラギノが無いので、CI では Noto Sans CJK JP で組版されます。

## 注意

- Mac でビルドすると `unknown font family: noto sans cjk jp` という警告が出ます。CI 用の代替フォントが Mac に無いだけなので無視してかまいません。
- `quarto typst query` は結果を stderr に出すため、Makefile では stderr から JSON の行だけを取り出して `slides.pdfpc` にしています。
