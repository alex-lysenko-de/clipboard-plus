#Requires AutoHotkey v2.0
Persistent

historyFile := A_ScriptDir "\clipboard_history.txt"
stop_event_handler := 0

OnClipboardChange ClipChanged, 1

ClipChanged(DataType) {
    global historyFile
	global stop_event_handler
	if stop_event_handler = 1 {
		stop_event_handler := 0
	} else if DataType = 1 {
		clipboardContent := A_Clipboard
		if (clipboardContent != "") {
            FileAppend clipboardContent . "`r`n", historyFile, "`n UTF-8"
	    }
	}
}




restoreClipboard() {
    global historyFile
	global stop_event_handler
    if FileExist(historyFile) {
        clipboardData := FileRead(historyFile)
		stop_event_handler := 1
        A_Clipboard := clipboardData  ; Записываем текст в буфер	
        FileDelete (historyFile)  ; Очищаем файл
    } 
}


^!s::  ; Ctrl + Alt + S
{
    restoreClipboard()
}
