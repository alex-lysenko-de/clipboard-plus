#Requires AutoHotkey v2.0

;TraySetIcon "Shell32.dll", 150

screenshotPath := A_Temp . "\screenshot.png"
resultPath := A_Temp . "\tesseract_result"
logFilePath := A_Temp . "\tesseract_log.txt"

lang := "deu+eng"
psm := "3"
preserve := " "

; --- Informational window on first launch ---
helpStr := "This script is for Optical Character Recognition (OCR) from your screen.`n`n"
    . "How to use:`n"
    . "1. Press the key combination: **CapsLock + PrintScreen**`n"
    . "2. Select a rectangular area on your screen for text recognition.`n"
    . "3. Choose the recognition mode (PSM) in the menu that appears.`n"
    . "4. Select the recognition language in the next menu.`n`n"
    . "The recognized text will be copied to your clipboard and displayed to you."

MsgBox(helpStr,	"OCR Script Information", 64)


; Create the popup menu by adding some items to it.
LangMenu := Menu()
; Create another menu destined to become a submenu of the above menu.
BlockMenu := Menu()
BlockMenu.Add("Default", BlockMenuHandler)
BlockMenu.Add()
BlockMenu.Add("PSM-3 auto", BlockMenuHandler)
BlockMenu.Add("PSM-4 single column", BlockMenuHandler)
BlockMenu.Add("PSM-5 single vertical block", BlockMenuHandler)
BlockMenu.Add("PSM-6 single block", BlockMenuHandler)
BlockMenu.Add("PSM-6p preserve spaces", BlockMenuHandler)
LangMenu.Add("Default ", LangMenuHandler)
LangMenu.Add()
LangMenu.Add("LANG eng+deu", LangMenuHandler)
LangMenu.Add("LANG deu", LangMenuHandler)
LangMenu.Add("LANG osd", LangMenuHandler)
LangMenu.Add()
LangMenu.Add("LANG script\Cyrillic", LangMenuHandler)
LangMenu.Add("LANG rus+eng", LangMenuHandler)
LangMenu.Add("LANG ukr", LangMenuHandler)

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.


ReadText() {  
    ; Take a screenshot of the area
	; Compose command line
    command := Format('pythonw "screenshot.py" --screenshotPath "{}"', screenshotPath)

	; Run the Python script
	RunWait(command)

	BlockMenu.Show()
    	
}

BlockMenuHandler(Item, *){

	Menu_Cmd := SubStr(Item, 1, 3)
	; Set default settings
	global lang
	global psm
	global preserve := " "
	
	if "PSM" = Menu_Cmd
	{ 
		psm := SubStr(Item, 5, 1)
		if SubStr(Item, 6, 1) = "p"
		{
		  preserve := ' -c "preserve_interword_spaces=1" '
		}	
	}
	
	LangMenu.Show()
}

LangMenuHandler(Item, *) {

	global lang
	global psm
	Menu_Cmd := SubStr(Item, 1, 3)
	if "LAN" = Menu_Cmd 
	{
	  lang := SubStr(Item, 6)
	}
	;-------------------------------------- Remove Result file -----------------------------------------------
	ResultFileName := resultPath . '.txt'
	if (FileExist(ResultFileName)) {
		FileDelete(ResultFileName)
	}
	;------------------------------ Try to recognize text using Tesseract -----------------------------------
    Target := " /c tesseract " . screenshotPath . " " . resultPath . " -l " . lang . "  --psm " . psm . preserve .  " > " . logFilePath
	; Run tesseract
	RunWait A_ComSpec . Target ,  , "Hide" 
    Sleep 1000
	
    ;--------------------------------------- Check results --------------------------------------------------
	if FileExist(ResultFileName) {	
	    FileEncoding ("UTF-8")
        ResText := FileRead(ResultFileName)
        ; Save Text into Clipboard
		A_Clipboard := resText
	    MsgBox(ResText, "The text has been copied into Clipboard (Insert: CTRL+v)")
	} else if FileExist(logFilePath) {
	    FileEncoding ("UTF-8")
        ResText := FileRead(logFilePath)
	    MsgBox(ResText, "Fail")
	} else {
	    MsgBox("Something went really wrong...", "Fail:")
	}
}

;-------------------------------------- Hot key CapsLock + PrnScr --------------------------------------------
CapsLock & PrintScreen::
{
  ReadText()
}



Persistent