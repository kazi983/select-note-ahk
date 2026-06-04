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
        TrayTip, エラー,  コピーに失敗しました, 16
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
    InputBox, UserComment, コメント入力,
    (
以下の内容を保存します：
%SelectedText%

コメントを入力してください：
    )

    ; キャンセルされた場合は終了
    if (ErrorLevel)
    {
        TrayTip, キャンセル,  キャンセルされました, 16
        return
    }

    ; 保存先
    targetDir := A_MyDocuments "\AutoHotkey"
    CSVFile := targetDir "\AutoHotkey_memo.csv"

    ; 保存先作成 存在しない場合のみ
    IfNotExist, %targetDir%
        FileCreateDir, %targetDir%

    ; CSVヘッダ ファイル新規作成時のみ
    IfNotExist, %CSVFile%
        line:= "timestamp,text,comment`n"

    ; 取得した選択文字を成形
    ; ダブルクォーテーションをエスケープ
    StringReplace, selectedTextFormatted, SelectedText, ", "", All
    ; ダブルクォーテーションで囲う
    selectedTextFormatted = "%selectedTextFormatted%"

    ; 取得した入力文字を成形
    ; ダブルクォーテーションをエスケープ
    StringReplace, userCommentFormatted, UserComment, ", "", All
    ; ダブルクォーテーションで囲う
    userCommentFormatted = "%UserComment%"

    ; 現在時刻を取得してフォーマット
    timestamp := A_Now
    FormatTime, timestamp, %timestamp%, yyyy-MM-dd HH:mm:ss

    ; タイムスタンプ・選択文字・入力文字をカンマ区切り
    line := line """" timestamp """," selectedTextFormatted "," userCommentFormatted "`n"

    ; CSVファイルに追加
    FileAppend, %line%, %CSVFile%

    ; メモリ開放
    ClipSaved := ""

    ; 完了メッセージ
    ShowToast("保存完了", "クリックでフォルダを開く", targetDir)

return

; ===== 右下Toast =====
global lastSavedPath := ""

ShowToast(title, message, path)
{
    global lastSavedPath
    lastSavedPath := path

    Gui, Toast:Destroy

    Gui, Toast:New
    Gui, Toast:+AlwaysOnTop -Caption +ToolWindow +Border
    Gui, Toast:Color, 1E1E1E
    Gui, Toast:Font, s10 cFFFFFF, Segoe UI

    ; テキスト追加・クリック可能に設定
    Gui, Toast:Add, Text, gOpenFolder Center w280 h60, %title%`n%message%

    ; 位置の取得
    SysGet, WorkArea, MonitorWorkArea
    x := WorkAreaRight - 400
    y := WorkAreaBottom - 120

    Gui, Toast:Show, x%x% y%y% NoActivate

    ; フェードイン準備
    WinGet, hwnd, ID, A
    WinSet, Transparent, 0, ahk_id %hwnd%

    ; フェードイン処理
    Loop 20 {
        WinSet, Transparent, % A_Index * 17, ahk_id %hwnd%
        Sleep 10
    }

    ; 指定秒後に閉じる
    SetTimer, CloseToast, -5000
}

OpenFolder:
    global lastSavedPath
    if(lastSavedPath!="")
        Run, % lastSavedPath
    Gosub, CloseToast
return

CloseToast:
    Gui, Toast:Destroy
return