#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
OnMessage(0x404, "AHK_NOTIFYICON")	;When you doubleclick on the systemtray icon, show the gui.
OnExit, GuiClose
GoSub, Settings_load				;Load from settings.ini
Menu, Tray, Icon, icon.ico
return

AHK_NOTIFYICON(wParam, lParam) 
{	global
	ToolTip
    if (lParam = 515) 
	{   if not (WinExist("ahk_id " GuiID))	;Only create the gui one time, not each time you wanna see it
		{	Gui, Add, Text, x300 y445 w200 h20 , Made by Patchie and r4nd0m1 :D
			Gui, Add, Tab, x0 y0 w480 h440 , Hotkeys|Howto
			Gui, Tab, 1
			Gui, Add, GroupBox, x6 y28 w460 h230 , Select hotkey to edit
			Gui, Add, ListView, xp+10 yp+20 wp-20 hp-30 Checked Grid AltSubmit -Multi -NoSortHdr vLV gHotkeyList, Enabled|Hotkey|Value
			LV_Add("check", "", "ctrl+1", Hotkey1) ;We will only show the first row of the script, and maximum 10 characters? so that it wont be ugly in the gui, just to get a pointer for the user.
			LV_Add("", "", "ctrl+2", Hotkey2)
			LV_Add("", "", "ctrl+3", Hotkey3)
			LV_Add("", "", "ctrl+4", Hotkey4)
			LV_Add("", "", "ctrl+5", Hotkey5)
			LV_Add("", "", "ctrl+6", Hotkey6)
			LV_Add("", "", "ctrl+7", Hotkey7)
			LV_Add("", "", "ctrl+8", Hotkey8)
			LV_Add("", "", "ctrl+9", Hotkey9)
			LV_Add("", "", "ctrl+0", Hotkey10)
			LV_Modify(1,"Select Focus")
			
			Gui, Add, GroupBox, x6 y260 w460 h140 , Insert text for the selected hotkey
			Gui, Add, Edit, xp+10 yp+20 wp-20 hp-30 gGuiSubmit vEdit1, %Hotkey1%
			Gui, Tab, 2
			Gui, Add, Text, x20 y30 w450 h400 , % "This application is made for printing text into emails,"
			. "webpages or other applications you type in the same text several times a day.`n`n"
			. "I hope you enjoy the application.`n`nIf you have any comments, suggestions or feedback, "
			. "don't hesitate to contact me on the forums.`n`nPatchie"
		}   
		Gui, Show, x10 y10 w479 h460, Hotkeys
		GuiControl, Focus, Edit1
		Send, {End}
		return false
    }
}

HotkeyList:
	;What to do when the user clicks a ListView line.
	if (A_GuiEvent = "Normal")
	{	LV_GetText(RowText, A_EventInfo, 3)
		GuiControl,, Edit1, %RowText%
		GuiControl, Focus, Edit1
		Send, {End}
	} 	return	

; This is the code that actually sends keystrokes when you press ctrl + 1...etc
^1::send %Edit1%
^2::send %Edit2%
^3::send %Edit3%
^4::send %Edit4%
^5::send %Edit5%
^6::send %Edit6%
^7::send %Edit7%
^8::send %Edit8%
^9::send %Edit9%
^0::send %Edit10%

;Saves to c:\hotkey.ini
Settings_save:
	if not (FileExist("c:\hotkey.ini"))
		FileAppend,, c:\hotkey.ini
	Gui, Submit, NoHide
	Loop, 10
	{	LV_GetText(Hotkey_temp,A_Index,3)
		Hotkey%A_Index%:=Hotkey_temp
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, `n, |, 1
		IniWrite, % Hotkey%A_Index%, c:\hotkey.ini, Hotkeys, Hotkey%A_Index%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	} 	
	traytip,, % "Just saved to file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey0
	return

;Loads data from c:\hotkey.ini
Settings_load:
	if not (FileExist("c:\hotkey.ini"))
		return
	Loop, 10
	{	IniRead, Hotkey%A_Index%, c:\hotkey.ini, Hotkeys, Hotkey%A_Index%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	}	
	traytip,, % "Just loaded from file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey0
	return

;Saves to file each time you edit a field
GuiSubmit:
	Gui, Submit, Nohide
	GoSub, Settings_save
	if (A_GuiControl="Edit1")
	{	GuiControlGet, newText,, Edit1
		LV_Modify(LV_GetNext(),,,,newText)
	}	return

;Saves and closes the application when you exit from the systemtray
GuiClose:
	GoSub, Settings_save
	if (A_ExitReason="")
		Gui, destroy
	else ExitApp
	return