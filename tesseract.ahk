#Requires AutoHotkey v2.0

TraySetIcon "Shell32.dll", 150

screenshotPath := A_Temp . "\screenshot.png"
resultPath := A_Temp . "\tesseract_result"
logFilePath := A_Temp . "\tesseract_log.txt"
    
; Create the popup menu by adding some items to it.
MyMenu := Menu()
; Create another menu destined to become a submenu of the above menu.
SubMenu := Menu()
SubMenu.Add("PSM-5 single vertical block", MenuHandler)
SubMenu.Add("PSM-6 preserve spaces", MenuHandler)
MyMenu.Add("Default ", MenuHandler)
MyMenu.Add()
MyMenu.Add("LANG eng+deu", MenuHandler)
MyMenu.Add("LANG deu", MenuHandler)
MyMenu.Add("LANG osd", MenuHandler)

MyMenu.Add()
MyMenu.Add("Text alignment", SubMenu)
MyMenu.Add()
MyMenu.Add("LANG script\Cyrillic", MenuHandler)
MyMenu.Add("LANG eng+rus", MenuHandler)
MyMenu.Add("LANG ukr", MenuHandler)

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.


ReadText() {  
    ; Take a screenshot of the area
	RunWait A_ComSpec " /c snippingtool.exe /clip", , "Hide"
    Sleep 500
    RunWait A_ComSpec " /c magick clipboard: " . screenshotPath, , "Hide"
	; Select Language  or multiple Languages
    MyMenu.Show()	
}

MenuHandler(Item, *) {
	; Run tesseract
	Menu_Cmd := SubStr(Item, 1, 3)
	; Set default settings
	lang := "eng+deu+rus"
	psm := "3"
	preserve := " "
	
	if "PSM" = Menu_Cmd
	{ 
		psm := SubStr(Item, 5, 1)
		if psm = "6" 
		{
		  preserve := ' -c "preserve_interword_spaces=1" '
		}	
	}

	else if "LAN" = Menu_Cmd 
	{
	  lang := SubStr(Item, 6)
	}
	; Remove Result file ---------------------------------------------------------------------------------------
	ResultFileName := resultPath . '.txt'
	if (FileExist(ResultFileName)) {
		FileDelete(ResultFileName)
	}
	; Try to recognize text using Tesseract ---------------------------------------------------------------------
    Target := " /c tesseract " . screenshotPath . " " . resultPath . " -l " . lang . "  --psm " . psm . preserve .  " > " . logFilePath
	
	RunWait A_ComSpec . Target ,  , "Hide" 
    Sleep 1000
	
    ; Check results -------------------------------------------------------------------------------------------
	if FileExist(ResultFileName) {	
	    FileEncoding ("UTF-8")
        ResText := FileRead(ResultFileName)
        ; Save Text into Clipboard
		A_Clipboard := resText
	    MsgBox(ResText, "The text has been copied into Clipboard (Insert: CapsLock+V)")
	} else if FileExist(logFilePath) {
	    FileEncoding ("UTF-8")
        ResText := FileRead(logFilePath)
	    MsgBox(ResText, "Fail")
	} else {
	    MsgBox("Something went really wrong...", "Fail:")
	}
}

; Hot key CapsLock + PrnScr --------------------------------------------
CapsLock & PrintScreen::
{
  ReadText()
}

; Hide program in System Tray ------------------------------------------
Persistent



