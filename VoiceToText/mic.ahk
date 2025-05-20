; Путь к интерпретатору Python
pythonPath := "python"  ; если Python в PATH, иначе укажи полный путь к python.exe
scriptPath := A_ScriptDir . "\mic_recorder.py"
recordingPID := 0

ScrollLock::
    if (recordingPID = 0) {
        ; Запуск Python-скрипта
        Run, %pythonPath% "%scriptPath%", , , recordingPID
        ToolTip, 🎙️ Python-скрипт запущен...
    }
return

ScrollLock up::
    if (recordingPID != 0) {
        ; Останавливаем Python-скрипт
        ; Process, Close, %recordingPID%
        recordingPID := 0
        ToolTip, 🛑 Python-скрипт остановлен.
        SetTimer, RemoveToolTip, -2000
    }
return

RemoveToolTip:
    ToolTip
return
