; Alt + Cで選択文字とコメントをCSVに保存
!c::

    ; 選択文字をクリップボードにコピー
    ; 元のクリップボードを保存しておく
    ClipSaved := ClipboardAll  ; 元のクリップボードを保存
    Clipboard := ""
    Send, ^c
    ClipWait, 2
    if (ErrorLevel) {
        Clipboard := ClipSaved  ; 元に戻す
        TrayTip, エラー,  コピー失敗, 16
        return
    }
    SelectedText := Clipboard
    Clipboard := ClipSaved  ; 元に戻す

    ; 選択文字が空なら何もしない
    if (SelectedText = "")
    {
        TrayTip, エラー,  文字が選択されていません, 16
        return
    }

    ; ユーザにコメント入力を求める
    InputBox, UserComment, コメント入力, 以下を保存します：`n%SelectedText%`n`n一緒に保存するコメントを入力してください：

    ; キャンセルされた場合は終了
    if (ErrorLevel)
    {
        TrayTip, キャンセル,  キャンセルされました, 16
        return
    }

    ; フォルダのパスを変数に代入
    targetDir := A_MyDocuments "\AutoHotkey"
    CSVFile := A_MyDocuments "\AutoHotkey\AutoHotkey_memo.csv"

    ; フォルダが存在しないか確認
    IfNotExist, %targetDir%
    {
        ; 存在しなければ作成
        FileCreateDir, %targetDir%
    }

    IfNotExist, %CSVFile%
    {
        ; CSVファイルを追加
        line:= "timestamp,text,comment`n"
    }

    ; 取得した選択文字を成形
    ; " をエスケープ
    StringReplace, selectedTextFormatted, SelectedText, ", "", All
    ; " で囲う
    selectedTextFormatted = "%selectedTextFormatted%"

    ; 取得した入力文字を成形
    ; " をエスケープ
    StringReplace, userCommentFormatted, UserComment, ", "", All
    ; "" で囲う
    userCommentFormatted = "%UserComment%"

    ; 現在時刻を取得してフォーマット
    timestamp := A_Now
    FormatTime, timestamp, %timestamp%, yyyy-MM-dd HH:mm:ss

    ; タイムスタンプ・選択文字・入力文字をカンマ区切り
    line := line """" timestamp """," selectedTextFormatted "," userCommentFormatted "`n"

    ; CSVファイルに追加
    FileAppend, %line%, %CSVFile%

    ; 完了メッセージ
    TrayTip, 保存完了,  メモを保存しました。`n%SelectedText%`n%UserComment%, 16

    ; メモリ開放
    ClipSaved := ""
return