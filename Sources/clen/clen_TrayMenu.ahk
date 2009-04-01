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

  Menu, tray, add
  Menu, tray, add, Save options and clipboards`tAlt+NumpadEnter, SaveOptions
  Menu, tray, add, Load options and clipboards`tAlt+NumpadIns, LoadOptions
  Menu, tray, add, Restore default options and clear clipboards`tAlt+NumpadDel, RestoreOptions

  Menu, tray, add
  Menu, tray, add, Show static clipboards content`tAlt+NumpadDiv, StaticContent
  Menu, tray, add, Show dynamic clipboard content`tAlt+NumpadMult, DynamicContent

  Menu, tray, add
  Menu, tray, add, About, AboutMenuItem
  Menu, tray, add, Exit, ExitMenuItem
}

clen_MenuOption(Option, Menu, Submenu, Label, Change)
{
  local OptionValue := %Option%

  if (Change)
  {
    if (OptionValue)
    {
      %Option% := false
    }
    else
    {
      %Option% := true
    }
    OptionValue := %Option%
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

  clen_MenuOption("clen_DynamicIsStack", "Options", "Stack-based dynamic clipboard model`tAlt+NumpadEnd", "StackBased", Change)
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

  clen_MenuOption("clen_ModeDuplicateToRegular", "Options", "Duplicate values to regular clipboard`tAlt+NumpadPgDn", "DuplicateToRegular", Change)
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

  clen_MenuOption("clen_Print", "Options", "Automatically show content`tAlt+NumpadDown", "AutoShowContent", Change)
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

  clen_MenuOption("clen_CopyPasteInsert", "Options", "Copy\Paste via Ctrl+Insert\Shift+Insert`tAlt+NumpadLeft", "CopyPasteInsert", Change)
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

StackBased:
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
