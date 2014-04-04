#NoEnv
#SingleInstance, Force
#NoTrayIcon
SetWorkingDir, %A_ScriptDir%
OnMessage(0x404, "AHK_NOTIFYICON")	;When you doubleclick on the systemtray icon, show the gui.
OnExit, GuiClose
Menu, Tray, Icon, icon.ico
Menu, Tray, Icon
GoSub, Settings_load	;Load from settings.ini
(StartUp_GUI=1)?AHK_NOTIFYICON(0,515)
;traytip,, % "Loaded successfully from file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
return

AHK_NOTIFYICON(wParam, lParam)
{ 	global
	if (lParam = 515)
	{ 	ToolTip
	    if not (WinExist("ahk_id " GuiID))	;Only create the gui one time, not each time you wanna see it
		{ 	Gui, +hwndGuiID
			Gui, Add, Text, x310 y395, Made by Patchie and r4nd0m1
		    Gui, Add, Tab, x-2 y0 w480 h390, Hotkeys|Config|Howto
			Gui, Tab, 1
				Gui, Font, bold
				Gui, Add, GroupBox, x5 y28 w450 h220, Select hotkey to edit
				Gui, Font, norm
				Gui, Add, ListView, xp+7 yp+18 wp-15 r10 Checked Grid AltSubmit -Multi -NoSortHdr vLV gHotkeyList, |Hotkey|Text
				Loop, 10
					LV_Add(Hotkey_enabled%A_Index%?"check":"", "", "ctrl+" A_Index, Hotkey%A_Index%)
				LV_Modify(1,"Select Focus")
				Gui, Font, bold
				Gui, Add, GroupBox, x5 yp+205 w450 h130, Insert text for the selected hotkey
				Gui, Font, norm
				Gui, Add, Edit, xp+7 yp+18 wp-15 r7 gGuiSubmit vEdit1, %Hotkey1%
			Gui, Tab, 2
				Gui, Font, bold
				Gui, Add, GroupBox, x5 y28 w75 h40, StartUp
				Gui, Font, norm
				Gui, Add, CheckBox, xp+5 yp+18 gGuiSubmit vStartUp_GUI checked%StartUp_GUI%, show GUI
			Gui, Tab, 3
				Gui, Add, Text, x5 y28, This application is made for printing text into emails, webpages or other applications,
				Gui, Add, Text, xp yp+15, where you type in the same text several times a day.
				Gui, Add, Text, xp yp+30, I hope you enjoy the application.
				Gui, Add, Text, xp yp+30, If you have any comments, suggestions or feedback, please
				Gui, Add, Text, xp yp+15, don't hesitate to contact me by email
				Gui, Add, Text, xp+175 yp cblue, Patchie@gmail.com
				Gui, Add, Text, xp+97 yp, or r4nd0m1 on #AHK@Freenode.
				Gui, Add, Text, x5 yp+30, Patchie
		}
		Gui, Show, x10 y10 w460 h410, SimplyHotkeys
		GuiControl, Focus, Edit1
		Send, {End}^a
		return false
	}
}

;What to do when the user clicks a ListView line.
HotkeyList:
	if (A_GuiEvent = "Normal")
	{	LV_GetText(RowText, A_EventInfo, 3)
		GuiControl,, Edit1, %RowText%
		GuiControl, Focus, Edit1
		Send, {End}^a
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
	Hotkey#:=Hotkey#=0?Hotkey#+10:Hotkey#
	if (Hotkey_enabled%Hotkey#%)
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
		if !(RowNumber) || (A_Index>10)
		  break
		Hotkey_enabled%RowNumber%=1
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
	IniWrite, % StartUp_GUI, c:\SimplyHotkeys.ini, MEM, StartUp_GUI
	
	return

;Loads data from c:\SimplyHotkeys.ini
Settings_load:
	if not (FileExist("c:\SimplyHotkeys.ini"))
		return
	Loop, 10
	{ 	IniRead, Hotkey_enabled%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey_enabled%A_Index%, 0
		IniRead, Hotkey%A_Index%, c:\SimplyHotkeys.ini, Hotkeys, Hotkey%A_Index%, %A_Space%
		StringReplace, Hotkey%A_Index%, Hotkey%A_Index%, |, `n, 1
	}
	IniRead, StartUp_GUI, c:\SimplyHotkeys.ini, MEM, StartUp_GUI
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
;msgbox,,, % "---" A_ExitReason "---", 1
	if not (A_ExitReason)
	{	GoSub, Settings_save
		;traytip,, % "Saved successfully to file`nCTRL + 1: " Hotkey1 "`nCTRL + 2: " Hotkey2 "`nCTRL + 3: " Hotkey3 "`nCTRL + 4: " Hotkey4 "`nCTRL + 5: " Hotkey5 "`nCTRL + 6: " Hotkey6 "`nCTRL + 7: " Hotkey7 "`nCTRL + 8: " Hotkey8 "`nCTRL + 9: " Hotkey9 "`nCTRL + 0: " Hotkey10
		Gui, destroy
	}	else ExitApp
	return
	
F12::ExitApp
