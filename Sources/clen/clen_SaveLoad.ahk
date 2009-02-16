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


clen_SaveClipData(ClipIndex)
{
  local Result =
  local ClipData =
  local ClipboardOld := ClipboardAll

  Clipboard := clen_ClipBoard%ClipIndex%
  ClipData := Clipboard
  if ClipData is not space
  {
    Result = %ClipData%
  }

  Clipboard := ClipboardOld
  return %Result%
}

clen_LoadSettings()
{
  local Index

  Loop 9
  {
     RegRead, clen_ClipBoard%A_Index%, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, %A_Index%
  }
  RegRead, clen_ClipBoard0, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, 0

  RegRead, clen_DynamicIsStack, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsStack
  RegRead, clen_ModeDuplicateToRegular, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, DuplicateToRegular
  RegRead, clen_Print, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsShowContent
  RegRead, clen_CopyPasteInsert, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsCtrlInsert

  clen_DynamicIndexBegin = 1
  RegRead, clen_DynamicIndexEnd, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count
  Loop %clen_DynamicIndexEnd%
  {
     RegRead, clen_DynamicClip%A_Index%, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%
  }
  clen_DynamicIndexEnd += 1

  TrayTip, clen : Static & Dynamic, All clipboards and options were restored, 10, 1

  clen_MenuOptionStack(false)
  clen_MenuOptionDuplicateToRegular(false)
  clen_MenuOptionShowContent(false)
  clen_MenuOptionCopyPaste(false)
  return
}

clen_SaveSettings()
{
  local Value
  local Difference := clen_DynamicIndexEnd - clen_DynamicIndexBegin
  local Index = 0
  local ClipboardOld := ClipboardAll

  clen_DynamicInitialize()
  clen_StaticInitialize()

  RegDelete, HKEY_CURRENT_USER, Software\clen

  Loop 9
  {
     Value := clen_SaveClipData(A_Index)
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, %A_Index%, %Value%
  }
  Value := clen_SaveClipData(0)
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, 0, %Value%

  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsStack, %clen_DynamicIsStack%
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, DuplicateToRegular, %clen_ModeDuplicateToRegular%
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsShowContent, %clen_Print%
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsCtrlInsert, %clen_CopyPasteInsert%

  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count, %Difference%
  Loop %Difference%
  {
     Index := clen_DynamicIndexBegin + A_Index - 1
     Clipboard := clen_DynamicClip%Index%
     Value := Clipboard
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%, %Value%
  }

  Clipboard := ClipboardOld

  TrayTip, clen : Static & Dynamic, All clipboards and options were loaded, 10, 1
  return
}

!NumpadDel::
  Reload
  return

!NumpadIns::
  clen_LoadSettings()
  return

!NumpadEnter::
  clen_SaveSettings()
  return
