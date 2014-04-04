#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
OnMessage(0x404, "AHK_NOTIFYICON")	;When you doubleclick on the systemtray icon, show the gui.
OnExit, GuiClose
GoSub, Settings_load	;Load from settings.ini
Menu, Tray, Icon, icon.ico
;traytip,, % "Loaded successfully from file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
return

AHK_NOTIFYICON(wParam, lParam)
{ 	global
	ToolTip
	if (lParam = 515)
	{ 	if not (WinExist("ahk_id " GuiID))	;Only create the gui one time, not each time you wanna see it
		{ 	Gui, Add, Text, x330 y445 w200 h20 , Made by Patchie and r4nd0m1
			Gui, Add, Tab, x0 y0 w480 h440 , Hotkeys|Howto
			Gui, Tab, 1
			Gui, Add, GroupBox, x6 y28 w460 h230 , Select hotkey to edit
			Gui, Add, ListView, xp+10 yp+20 wp-20 hp-30 Checked Grid AltSubmit -Multi -NoSortHdr vLV gHotkeyList, Enabled|Hotkey|Value
			Loop, 10
				LV_Add(Hotkey_enabled%A_Index%, "", "ctrl+" A_Index, Hotkey%A_Index%)
			LV_Modify(1,"Select Focus")
			Gui, Add, GroupBox, x6 y260 w460 h140, Insert text for the selected hotkey
			Gui, Add, Edit, xp+10 yp+20 wp-20 hp-30 gGuiSubmit vEdit1, %Hotkey1%
			Gui, Tab, 2
			Gui, Add, Text, x20 y30 w450 h400 , % "This application is made for printing text into emails, "
			. "webpages or other applications you type in the same text several times a day.`n`n"
			. "I hope you enjoy the application.`n`n"
			. "If you have any comments, suggestions or feedback, don't hesitate to contact me by email: Patchie@gmail.com.`n`n"
			. "Patchie"
		}
		Gui, Show, x10 y10 w479 h460, SimplyHotkeys
		GuiControl, Focus, Edit1
		Send, {End}
		return false
	}
}

;What to do when the user clicks a ListView line.
HotkeyList:
	if (A_GuiEvent = "Normal")
	{	LV_GetText(RowText, A_EventInfo, 3)
		GuiControl,, Edit1, %RowText%
		GuiControl, Focus, Edit1
		Send, {End}
		GoSub, Settings_save	;Save in case the user has checked/unchecked a checkbox
	}
	return	

; This is the code that actually sends keystrokes when you press ctrl + 1...etc
^1::
^2::
^3::
^4::
^5::
^6::
^7::
^8::
^9::
^0::
	StringTrimLeft, Hotkey#, A_ThisHotkey, 1
	if (Hotkey_enabled%Hotkey#%="check")
		send % Hotkey%Hotkey#%
	return

;Saves to c:\SimplyHotkeys.ini
Settings_save:
	if not (FileExist("c:\SimplyHotkeys.ini"))
		FileAppend,, c:\SimplyHotkeys.ini
	Gui, Submit, NoHide
	;Checking what hotkeys that is enabled/disabled, and store it into variables
	RowNumber = 0
	Loop, 10
		Hotkey_enabled%A_Index%:=""

	Loop 
	{	RowNumber := LV_GetNext(RowNumber, "Checked")
		ifEqual, RowNumber,, break
		Hotkey_enabled%RowNumber% = Check
	}
	
	Loop, 10 ;Saving if the hotkey is enabled or disabled to file
		IniWrite, % Hotkey_enabled%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey_enabled%A_Index%

	Loop, 10 
	{ 	;Saves the hotkey text to file
		LV_GetText(Hotkey_temp2,A_Index,3)
		Hotkey%A_Index%:=Hotkey_temp2
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, `n, |, 1
		IniWrite, % Hotkey%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey%A_Index%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	}
	return

;Loads data from c:\SimplyHotkeys.ini
Settings_load:
	if not (FileExist("c:\SimplyHotkeys.ini"))
		return
	Loop, 10
	{ 	IniRead, Hotkey_enabled%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey_enabled%A_Index%
		IniRead, Hotkey%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey%A_Index%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	}
	return

;Saves to file each time you edit a field
GuiSubmit:
	Gui, Submit, Nohide
	GoSub, Settings_save
	if (A_GuiControl="Edit1")
	{ 	GuiControlGet, newText,, Edit1
		LV_Modify(LV_GetNext(),,,,newText)
	}	
	return

;Saves and closes the application when you exit from the systemtray
GuiClose:
	;traytip,, % "Saved successfully to file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " 
	;. Hotkey5 "`n	CTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
	GoSub, Settings_save
	if (A_ExitReason="")
		Gui, destroy
	else ExitApp
	return
