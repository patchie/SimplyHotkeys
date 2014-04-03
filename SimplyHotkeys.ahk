#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
OnMessage(0x404, "AHK_NOTIFYICON")	;When you doubleclick on the systemtray icon, show the gui.
OnExit, GuiClose
GoSub, Settings_load				;Load from settings.ini
Menu, Tray, Icon, icon.ico
traytip,, % "Loaded successfully from file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
return

AHK_NOTIFYICON(wParam, lParam) 
{	global
	ToolTip
    if (lParam = 515) 
	{   if not (WinExist("ahk_id " GuiID))	;Only create the gui one time, not each time you wanna see it
		{	Gui, Add, Text, x330 y445 w200 h20 , Made by Patchie and r4nd0m1
			Gui, Add, Tab, x0 y0 w480 h440 , Hotkeys|Howto
			Gui, Tab, 1
			Gui, Add, GroupBox, x6 y28 w460 h230 , Select hotkey to edit
			Gui, Add, ListView, xp+10 yp+20 wp-20 hp-30 Checked Grid AltSubmit -Multi -NoSortHdr vLV gHotkeyList, Enabled|Hotkey|Value
			LV_Add(Hotkey_enabled1, "", "ctrl+1", Hotkey1)
			LV_Add(Hotkey_enabled2, "", "ctrl+2", Hotkey2)
			LV_Add(Hotkey_enabled3, "", "ctrl+3", Hotkey3)
			LV_Add(Hotkey_enabled4, "", "ctrl+4", Hotkey4)
			LV_Add(Hotkey_enabled5, "", "ctrl+5", Hotkey5)
			LV_Add(Hotkey_enabled6, "", "ctrl+6", Hotkey6)
			LV_Add(Hotkey_enabled7, "", "ctrl+7", Hotkey7)
			LV_Add(Hotkey_enabled8, "", "ctrl+8", Hotkey8)
			LV_Add(Hotkey_enabled9, "", "ctrl+9", Hotkey9)
			LV_Add(Hotkey_enabled10, "", "ctrl+0", Hotkey10)
			LV_Modify(1,"Select Focus")
			Gui, Add, GroupBox, x6 y260 w460 h140 , Insert text for the selected hotkey
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
	{	
		LV_GetText(RowText, A_EventInfo, 3)
		GuiControl,, Edit1, %RowText%
		GuiControl, Focus, Edit1
		Send, {End}
		GoSub, Settings_save	;Save in case the user has checked/unchecked a checkbox
	}
	return	

; This is the code that actually sends keystrokes when you press ctrl + 1...etc
^1::
	if (Hotkey_enabled1 = "Check"){
		send %Hotkey1%
	}
	Return
	
^2::
	if (Hotkey_enabled2 = "Check"){
		send %Hotkey2%
	}
	Return
	
^3::
	if (Hotkey_enabled3 = "Check"){
		send %Hotkey3%
	}
	Return
	
^4::
	if (Hotkey_enabled4 = "Check"){
		send %Hotkey4%
	}
	Return
	
^5::
	if (Hotkey_enabled5 = "Check"){
		send %Hotkey5%
	}
	Return
	
^6::
	if (Hotkey_enabled6 = "Check"){
		send %Hotkey6%
	}
	Return
	
^7::
	if (Hotkey_enabled7 = "Check"){
		send %Hotkey7%
	}
	Return
	
^8::
	if (Hotkey_enabled8 = "Check"){
		send %Hotkey8%
	}
	Return
	
^9::
	if (Hotkey_enabled9 = "Check"){
		send %Hotkey9%
	}
	Return
	
^0::
	if (Hotkey_enabled10 = "Check"){
		send %Hotkey10%
	}
	Return


;Saves to c:\SimplyHotkeys.ini
Settings_save:
	if not (FileExist("c:\SimplyHotkeys.ini"))
		FileAppend,, c:\SimplyHotkeys.ini
	Gui, Submit, NoHide
	
	;Checking what hotkeys that is enabled/disabled, and store it into variables
	RowNumber = 0
		Hotkey_enabled1 = ""
		Hotkey_enabled2 = ""
		Hotkey_enabled3 = ""
		Hotkey_enabled4 = ""
		Hotkey_enabled5 = ""
		Hotkey_enabled6 = ""
		Hotkey_enabled7 = ""
		Hotkey_enabled8 = ""
		Hotkey_enabled9 = ""
		Hotkey_enabled10 = ""
		Loop {
			RowNumber := LV_GetNext(RowNumber, "Checked") 
			if not RowNumber
				   break
		   Hotkey_enabled%RowNumber% = Check
		}
	
	Loop, 10 {
		;Saving if the hotkey is enabled or disabled to file
		IniWrite, % Hotkey_enabled%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey_enabled%A_Index%
		
		;Saves the hotkey text to file
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
	{	
		IniRead, Hotkey_enabled%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey_enabled%A_Index%
		
		IniRead, Hotkey%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey%A_Index%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	}
	return

;Saves to file each time you edit a field
GuiSubmit:
	Gui, Submit, Nohide
	GoSub, Settings_save
	if (A_GuiControl="Edit1")
	{	
		GuiControlGet, newText,, Edit1
		LV_Modify(LV_GetNext(),,,,newText)
	}	
	return

;Saves and closes the application when you exit from the systemtray
GuiClose:
	if (A_ExitReason="")
	{
		GoSub, Settings_save
		traytip,, % "Saved successfully to file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
		Gui, destroy
	}
	else 
	{
		ExitApp
	}
	return
