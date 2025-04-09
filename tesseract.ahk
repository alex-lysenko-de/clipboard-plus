#Requires AutoHotkey v2.0

screenshotPath := A_Temp . "\screenshot.png"
resultPath := A_Temp . "\result.txt"
    
; Create the popup menu by adding some items to it.
MyMenu := Menu()
; Create another menu destined to become a submenu of the above menu.
MyMenu.Add("deu", MenuHandler)
MyMenu.Add()
MyMenu.Add("eng+deu", MenuHandler)
MyMenu.Add("osd", MenuHandler)
MyMenu.Add("script\Cyrillic", MenuHandler)
MyMenu.Add()
MyMenu.Add("eng+rus", MenuHandler)
MyMenu.Add()
MyMenu.Add("ukr", MenuHandler)

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.


ReadText() {  
    ; Делаем скриншот области 
	RunWait A_ComSpec " /c snippingtool.exe /clip", , "Hide"
    Sleep 500
    RunWait A_ComSpec " /c magick clipboard: " . screenshotPath, , "Hide"
    ;Sleep 500
	; Select Language  or multiple Languages
    MyMenu.Show()	
}

MenuHandler(Item, *) {
	; Run tesseract

	if "Отмена" != Item 
	{
	  lang := Item
	  ; Распознаем текст с помощью Tesseract
	  params := " /c tesseract " . screenshotPath . " " . resultPath . " -l " . lang . "  "
	  MsgBox(params)
      ; RunWait A_ComSpec . params , , "Hide"
	  RunWait A_ComSpec . params 
      Sleep 1000
 
      ; Читаем результат
	  FileEncoding ("UTF-8")
      resText := FileRead(resultPath . '.txt')

      ; Выводим в консоль AHK
      A_Clipboard := resText
	
      MsgBox(resText, "Результат скопирован в буфер обмена")
	}
}

 ; Hot key CapsLock + PrnScr Ctrl+Alt+S
^!s:: 
{
  ReadText()
}

CapsLock & PrintScreen::
{
  ReadText()
}


Persistent



