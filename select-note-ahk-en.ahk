; Alt + C: save selected text and comment to CSV
!c::

    ; Copy selected text to clipboard
    ; Save original clipboard
    ClipSaved := ClipboardAll
    Clipboard := ""
    Send, ^c
    ClipWait, 2

    if (ErrorLevel) {
        Clipboard := ClipSaved
        TrayTip, Error, Copy failed, 16
        return
    }

    SelectedText := Clipboard
    Clipboard := ClipSaved

    ; Do nothing if selection is empty
    if (SelectedText = "")
    {
        TrayTip, Error, No selection, 16
        return
    }

    ; Ask user for comment
    InputBox, UserComment, Add Comment,
(
Selected text:
%SelectedText%

Add a comment to save with it:
)

    ; Cancel check
    if (ErrorLevel)
    {
        TrayTip, Cancelled, Cancelled, 16
        return
    }

    ; Paths
    targetDir := A_MyDocuments "\AutoHotkey"
    CSVFile := targetDir "\AutoHotkey_memo.csv"

    ; Create folder if missing
    IfNotExist, %targetDir%
        FileCreateDir, %targetDir%

    ; CSV header (only when file doesn't exist)
    IfNotExist, %CSVFile%
        line := "timestamp,text,comment`n"

    ; Escape double quotations in selected text
    StringReplace, selectedTextFormatted, SelectedText, ", "", All
    selectedTextFormatted = "%selectedTextFormatted%"

    ; Escape double quotations in comment
    StringReplace, userCommentFormatted, UserComment, ", "", All
    userCommentFormatted = "%UserComment%"

    ; Timestamp
    timestamp := A_Now
    FormatTime, timestamp, %timestamp%, yyyy-MM-dd HH:mm:ss

    ; Build CSV line
    line := line """" timestamp """," selectedTextFormatted "," userCommentFormatted "`n"

    ; Append to file
    FileAppend, %line%, %CSVFile%

    ; Clear variable
    ClipSaved := ""

    ; Completion message
    ShowToast("Saved", "Click to open folder", targetDir)
return

; ===== Right-bottom Toast =====
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

    ; Add text / clickable area
    Gui, Toast:Add, Text, gOpenFolder Center w280 h60, %title%`n%message%

    ; Get screen work area (excluding taskbar)
    SysGet, WorkArea, MonitorWorkArea
    x := WorkAreaRight - 400
    y := WorkAreaBottom - 120

    Gui, Toast:Show, x%x% y%y% NoActivate

    ; Prepare fade-in
    WinGet, hwnd, ID, A
    WinSet, Transparent, 0, ahk_id %hwnd%

    ; Fade-in animation
    Loop 20 {
        WinSet, Transparent, % A_Index * 17, ahk_id %hwnd%
        Sleep 10
    }

    ; Auto close after delay
    SetTimer, CloseToast, -5000
}

OpenFolder:
    global lastSavedPath
    if (lastSavedPath != "")
        Run, % lastSavedPath
    Gosub, CloseToast
return

CloseToast:
    Gui, Toast:Destroy
return