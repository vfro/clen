; Copyright 2008-2012 Volodymyr Frolov
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; http://www.apache.org/licenses/LICENSE-2.0
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

clen_InitializeTrayMenu()
{
  Menu, Tray, Tip, Clipboard Enhanced v2.1`n© 2008-2012 Volodymyr Frolov

  Menu, tray, NoStandard

  clen_MenuOptionStack(false)
  clen_MenuOptionDuplicateToRegular(false)
  clen_MenuOptionShowContent(false)
  clen_MenuOptionCopyPaste(false)
  clen_MenuOptionSuppressFormating(false)

  Menu, tray, add, Options, :Options
  clen_AutorunMenuOption(false)

  Menu, tray, add
  Menu, tray, add, Save dynamic and static clipboards`tAlt+Numpad Enter, SaveOptions
  Menu, tray, add, Load dynamic and static clipboards`tAlt+Numpad Ins, LoadOptions
  Menu, tray, add, Clear all clipboards`tAlt+Numpad Del, RestoreOptions

  Menu, tray, add
  Menu, tray, add, Show static clipboards content`tAlt+Numpad Div, StaticContent
  Menu, tray, add, Show dynamic clipboard content`tAlt+Numpad Mult, DynamicContent

  Menu, RegularClipboard, add, Previous value`tCtrl+Numpad Sub, RegularClipboardUndo
  Menu, RegularClipboard, add, Next value`tCtrl+Numpad Add, RegularClipboardRedo
  Menu, tray, add, Regular Clipboard, :RegularClipboard

  Menu, tray, add
  Menu, tray, add, About, AboutMenuItem
  Menu, tray, add, Show hotkey tips, HelpOnHotkeys
  Menu, tray, add
  Menu, tray, add, Exit, ExitMenuItem

  clen_MenuRegularUndoEnable(false)
  clen_MenuRegularRedoEnable(false)
  return
}

clen_MenuRegularUndoEnable(Enabled)
{
  if (Enabled)
  {
    Menu, RegularClipboard, Enable, Previous value`tCtrl+Numpad Sub
  }
  else
  {
    Menu, RegularClipboard, Disable, Previous value`tCtrl+Numpad Sub
  }
  return
}

clen_MenuRegularRedoEnable(Enabled)
{
  if (Enabled)
  {
    Menu, RegularClipboard, Enable, Next value`tCtrl+Numpad Add
  }
  else
  {
    Menu, RegularClipboard, Disable, Next value`tCtrl+Numpad Add
  }
  return
}

clen_CheckForFirstRun()
{
  local RunStatus := false

  RegRead, RunStatus, REG_SZ, HKEY_CURRENT_USER, Software\clen

  if (ErrorLevel || !RunStatus)
  {
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen,,1

    ; Fill default values for all options

    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, DynamicIsStack, 0
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, DuplicateToRegular, 0
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, AutoShowContent, 1
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, CopyPasteInsert, 1
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, SuppressFormating, 0

    if (A_IsCompiled)
    {
      RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, clen, %A_ScriptFullPath%
    }
  }
  return
}

clen_AutorunMenuOption(Change)
{
  local OptionString := ""
  local OptionValue
  local Submenu := "Run when Windows starts"

  if (!A_IsCompiled)
  {
    return
  }

  RegRead, OptionString, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, clen

  if (ErrorLevel || StrLen(OptionString) == 0)
  {
    OptionValue := false
  }
  else
  {
    OptionValue := true
    if OptionString <> %A_ScriptFullPath%
    {
      RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, clen, %A_ScriptFullPath%
    }
  }

  if (Change)
  {
    if (OptionValue)
    {
      OptionValue := false
      RegDelete, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, clen
    }
    else
    {
      OptionValue := true
      RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, clen, %A_ScriptFullPath%
    }
  }
  else
  {
    Menu, tray, add, %Submenu%, ClenAutorun
  }

  if (OptionValue)
  {
    Menu, tray, Check, %Submenu%
  }
  else
  {
    Menu, tray, Uncheck, %Submenu%
  }

  return
}

clen_MenuOption(ByRef OptionId, Menu, Submenu, Label, Change)
{
  local OptionValue

  RegRead, OptionId, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, %Label%
  OptionValue := OptionId

  if (Change)
  {
    if (OptionValue)
    {
      OptionId := false
    }
    else
    {
      OptionId := true
    }
    OptionValue := OptionId

    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, %Label%, %OptionId%
  }
  else
  {
    Menu, %Menu%, add, %Submenu%, %Label%
  }

  if (OptionValue)
  {
    Menu, %Menu%, Check, %Submenu%
  }
  else
  {
    Menu, %Menu%, Uncheck, %Submenu%
  }
  return
}

clen_MenuOptionStack(Change)
{
  local Fake

  clen_MenuOption(clen_DynamicIsStack, "Options", "Stack-based dynamic clipboard model", "DynamicIsStack", Change)
  if (Change)
  {
     if (clen_DynamicIsStack)
     {
        TrayTip, clen : Dynamic, Dynamic clipboard model is switched to STACK, 10, 1, 16
     }
     else
     {
        TrayTip, clen : Dynamic, Dynamic clipboard model is switched to QUEUE, 10, 1, 16
     }
  }
  return
}

clen_MenuOptionDuplicateToRegular(Change)
{
  local Fake

  clen_MenuOption(clen_ModeDuplicateToRegular, "Options", "Duplicate values to regular clipboard", "DuplicateToRegular", Change)
  if (Change)
  {
     if (clen_ModeDuplicateToRegular)
     {
        TrayTip, clen : Static & Dynamic, Duplicate to regular clipboard is turned ON, 10, 1, 16
     }
     else
     {
        TrayTip, clen : Static & Dynamic, Duplicate to regular clipboard is turned OFF, 10, 1, 16
     }
  }
  return
}

clen_MenuOptionShowContent(Change)
{
  local Fake

  clen_MenuOption(clen_Print, "Options", "Automatically show content", "AutoShowContent", Change)
  if (Change)
  {
     if (clen_Print)
     {
        TrayTip, clen : Static & Dynamic, Show keyboard content is turned ON, 10, 1, 16
     }
     else
     {
        TrayTip, clen : Static & Dynamic, Show keyboard content is turned OFF, 10, 1, 16
     }
  }
  return
}

clen_MenuOptionCopyPaste(Change)
{
  local Fake

  clen_MenuOption(clen_CopyPasteInsert, "Options", "Copy\Paste via Ctrl+Insert\Shift+Insert", "CopyPasteInsert", Change)
  if (Change)
  {
     if (clen_CopyPasteInsert)
     {
       TrayTip, clen : Static & Dynamic, Copy\Paste mode is Ctrl+Insert\Shift+Insert, 10, 1, 16
     }
     else
     {
       TrayTip, clen : Static & Dynamic, Copy\Paste mode is Ctrl+C\Ctrl+V, 10, 1, 16
     }
  }
  return
}

clen_MenuOptionSuppressFormating(Change)
{
  local Fake

  clen_MenuOption(clen_SuppressFormating, "Options", "Suppress formating for regular clipboard", "SuppressFormating", Change)
  if (Change)
  {
     if (clen_SuppressFormating)
     {
       TrayTip, clen : Static & Dynamic, Suppress formating for regular clipboard is turned on, 10, 1, 16
     }
     else
     {
       TrayTip, clen : Static & Dynamic, Suppress formating for regular clipboard is turned off, 10, 1, 16
     }
  }
  return
}

clen_ShowHelpOnHotkeys()
{
  Gui, Destroy

  Gui, Add, Text, x10 y10, Dynamic clipboard hotkeys:
  Gui, Add, ListView, w500 r4 Grid ReadOnly -Hdr,Hotkey|Description

  LV_Add("", "Ctrl + Numpad Insert", "Insert new value into the top of the dynamic clipboard")
  LV_Add("", "Shift + Numpad Insert", "Paste a value from the bottom of the dynamic clipboard")
  LV_Add("", "Shift + Numpad Delete", "Paste a value from the top of the dynamic clipboard")
  LV_Add("", "Alt + Numpad Mult", "Display content of the dynamic clipboard")

  LV_ModifyCol(1, "200")
  LV_ModifyCol(2, "295")

  Gui, Add, Text,, Static clipboards hotkeys:
  Gui, Add, ListView, w500 r4 Grid ReadOnly -Hdr,Hotkey|Description

  LV_Add("", "Ctrl + Numpad Number (from 1 to 9)", "Insert new value into one of the static clipboard")
  LV_Add("", "Shift + Numpad Number (from 1 to 9)", "Paste value into one of the static clipboard")
  LV_Add("", "Ctrl + Shift + Numpad Number", "Can be used istead of Ctrl + Numpad Number")
  LV_Add("", "Alt + Numpad Div", "Display content of static clipboards")

  LV_ModifyCol(1, "200")
  LV_ModifyCol(2, "295")

  Gui, Add, Text,, Password clipboard hotkeys:
  Gui, Add, ListView, w500 r3 Grid ReadOnly -Hdr,Hotkey|Description

  LV_Add("", "Ctrl + Numpad Mult", "Copy value into password clipboard")
  LV_Add("", "Shift + Numpad Mult", "Paste value and clear password clipboard")
  LV_Add("", "Ctrl + Shift + Numpad Mult", "Wait for password. Intercept value from regular clipboard")

  LV_ModifyCol(1, "200")
  LV_ModifyCol(2, "295")

  Gui, Add, Text,, Regular clipboard hotkeys:
  Gui, Add, ListView, w500 r8 Grid ReadOnly -Hdr,Hotkey|Description

  LV_Add("", "Ctrl + Numpad Sub", "Previous value in a history")
  LV_Add("", "Ctrl + Numpad Add", "Next value in a history")
  LV_Add("", "Win Key + Insert", "Paste when Shift + Insert isn't working (in cmd.exe)")
  LV_Add("", "Win Key + Delete", "Paste without format")
  LV_Add("", "Win Key + Home", "Sort clipboard lines and paste")
  LV_Add("", "Win Key + End", "Sort descending and paste")
  LV_Add("", "Win Key + Page Up", "Paste in uppercase")
  LV_Add("", "Win Key + Page Down", "Paste in lowercase")

  LV_ModifyCol(1, "200")
  LV_ModifyCol(2, "295")

  Gui, Add, Text,, Additional tips:
  Gui, Add, ListView, w500 r3 Grid ReadOnly -Hdr,Hotkey|Description

  LV_Add("", "Copy separator into regular clipboard", "and press ...")
  LV_Add("", "Ctrl + Shift + Numpad Insert", "Paste list from dynamic clipboard")
  LV_Add("", "Ctrl + Shift + Numpad Delete", "Paste reversed list from dynamic clipboard")

  LV_ModifyCol(1, "200")
  LV_ModifyCol(2, "295")

  Gui, Add, Text, w500 Center, Please, note that those hotkeys works only with numlock turned off.
  Gui, Add, Button, x210 w80 Default gButtonOk, Ok

  Gui, Show, AutoSize Center, Clipborad Enhanced Hotkeys
  return
}

ClenAutorun:
  clen_AutorunMenuOption(true)
  return

DynamicIsStack:
  clen_MenuOptionStack(true)
  return

DuplicateToRegular:
  clen_MenuOptionDuplicateToRegular(true)
  return

AutoShowContent:
  clen_MenuOptionShowContent(true)
  return

CopyPasteInsert:
  clen_MenuOptionCopyPaste(true)
  return

SuppressFormating:
  clen_MenuOptionSuppressFormating(true)
  return

StaticContent:
  clen_PrintStaticContent()
  return

DynamicContent:
  clen_DynamicPrintAll()
  return

RegularClipboardUndo:
  clen_RegularUndo()
  return

RegularClipboardRedo:
  clen_RegularRedo()
  return

SaveOptions:
  clen_SaveSettings()
  return

LoadOptions:
  clen_LoadSettings()
  return

RestoreOptions:
  Reload
  return

AboutMenuItem:
  Run, http://code.google.com/p/clen/wiki/About
  return

HelpOnHotkeys:
  clen_ShowHelpOnHotkeys()
  return

ButtonOk:
  Gui, Destroy
  return

GuiClose:
  Gui, Destroy
  return

ExitMenuItem:
  ExitApp, 1
  return
