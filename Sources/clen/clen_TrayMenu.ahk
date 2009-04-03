; Copyright 2008-2009 Volodymyr Frolov
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
  Menu, Tray, Tip, Clipboard Enhanced v0.7.1 © 2008-2009 Volodymyr Frolov

  Menu, tray, NoStandard

  clen_MenuOptionStack(false)
  clen_MenuOptionDuplicateToRegular(false)
  clen_MenuOptionShowContent(false)
  clen_MenuOptionCopyPaste(false)

  Menu, tray, add, Options, :Options
  clen_AutorunMenuOption(false)

  Menu, tray, add
  Menu, tray, add, Save dynamic and static clipboards`tAlt+NumpadEnter, SaveOptions
  Menu, tray, add, Load dynamic and static clipboards`tAlt+NumpadIns, LoadOptions
  Menu, tray, add, Clear all clipboards`tAlt+NumpadDel, RestoreOptions

  Menu, tray, add
  Menu, tray, add, Show static clipboards content`tAlt+NumpadDiv, StaticContent
  Menu, tray, add, Show dynamic clipboard content`tAlt+NumpadMult, DynamicContent

  Menu, tray, add
  Menu, tray, add, About, AboutMenuItem
  Menu, tray, add, Exit, ExitMenuItem
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
        TrayTip, clen : Dynamic, Dynamic clipboard model is switched to STACK, 10, 1
     }
     else
     {
        TrayTip, clen : Dynamic, Dynamic clipboard model is switched to QUEUE, 10, 1
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
        TrayTip, clen : Static & Dynamic, Duplicate to regular clipboard is turned ON, 10, 1
     }
     else
     {
        TrayTip, clen : Static & Dynamic, Duplicate to regular clipboard is turned OFF, 10, 1
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
        TrayTip, clen : Static & Dynamic, Show keyboard content is turned ON, 10, 1
     }
     else
     {
        TrayTip, clen : Static & Dynamic, Show keyboard content is turned OFF, 10, 1
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
       TrayTip, clen : Static & Dynamic, Copy\Paste mode is Ctrl+Insert\Shift+Insert, 10, 1
     }
     else
     {
       TrayTip, clen : Static & Dynamic, Copy\Paste mode is Ctrl+C\Ctrl+V, 10, 1
     }
  }
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

StaticContent:
  clen_PrintStaticContent()
  return

DynamicContent:
  clen_DynamicPrintAll()
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
  Run, http://code.google.com/p/clen/
  return

ExitMenuItem:
  ExitApp, 1
  return
