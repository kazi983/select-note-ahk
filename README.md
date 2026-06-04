# select-note-ahk

Select text, press Alt+C, and take notes.

A simple AutoHotkey utility that lets you save selected text together with your own comments.

The tool automatically stores:

* Timestamp
* Selected text
* Your note

All data is saved to a CSV file, making it easy to review, search, or import into other tools later.

## Usage

1. Select any text.

2. Press `Alt + C`.

3. Enter your note.

4. The text and note will be saved automatically.

5. Click the toast notification to open where the file is saved.
<img width="1632" height="1014" alt="select-note-ahk" src="https://github.com/user-attachments/assets/dedbc757-e27f-4ad3-bcc8-afb317dff514" />

## Example

Selected text:

> Premature optimization is the root of all evil.

Your note:

> Important concept for software design.

Saved record:

```csv
timestamp,text,comment
2026-06-03 10:00:00,"Premature optimization is the root of all evil.","Important concept for software design."
```

## Why?

When reading articles in other languages, I often come across unfamiliar words and expressions.

My usual workflow was:

1. Copy the text
2. Paste it into Excel
3. Write down the meaning, usage, or my notes

While this worked, the constant switching between reading and note-taking interrupted my train of thought.

I created this tool to reduce that friction and make the process as simple as:

**Select → Alt+C → Note**

so I can stay focused on reading while still capturing useful information.

---

# 日本語

選択したテキストにコメントを付けて保存できる AutoHotkey ユーティリティです。

テキストを選択して `Alt + C` を押すだけで、

* 保存日時
* 選択したテキスト
* 自分のメモ

を CSV ファイルへ記録できます。

後から Excel やスプレッドシートで見返したり、学習メモとして活用したりできます。

## 使い方

1. テキストを選択
2. `Alt + C` を押す
3. コメントを入力
4. 自動で保存される
5. トースト通知をクリックすると保存場所が開く
<img width="1632" height="1014" alt="select-note-ahk" src="https://github.com/user-attachments/assets/dedbc757-e27f-4ad3-bcc8-afb317dff514" />

## 使用例

選択したテキスト:

> take notes

メモ:

> take a noteだとさっと書き留める感じ。take notesはしっかり記録する感じ。講義のノート、会議のメモとか。

保存される情報:

```csv
timestamp,text,comment
2026-06-03 10:00:00,"take notes","take a noteだとさっと書き留める感じ。take notesはしっかり記録する感じ。講義のノート、会議のメモとか。"
```

## こんな用途に

* 技術記事のメモ
* 読書メモ
* 英語学習
* 気になった文章の収集
* 後で調べたい内容の記録

## 開発背景

他言語の記事を読んでいるとき、新しい単語や表現に出会ったら、Excel にコピーして意味や使い方を書き残すようにしていました。

しかし、

1. コピーする
2. Excel を開く
3. 貼り付ける
4. メモを書く

という作業を繰り返していると、読書や学習の流れが途切れてしまいます。

そこで、

**選択 → Alt+C → メモ**

だけで記録できるようにするため、このツールを作成しました。

学習中の思考を止めずに、気になった表現や文章を素早く残せることを目指しています。
