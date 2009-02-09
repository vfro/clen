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


clen_private_SaveClipData(ClipIndex)
{
  local Result =
  local ClipData =
  local ClipboardOld := ClipboardAll

  Clipboard := clen_private_ClipBoard%ClipIndex%
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
     RegRead, clen_private_ClipBoard%A_Index%, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, %A_Index%
  }
  RegRead, clen_private_ClipBoard0, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, 0

  RegRead, clen_private_DynamicIsStack, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsStack
  RegRead, clen_public_ModeRestoreClipboard, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsRestoreClipboard
  RegRead, clen_private_Print, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsShowContent

  clen_private_DynamicIndexBegin = 1
  RegRead, clen_private_DynamicIndexEnd, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count
  Loop %clen_private_DynamicIndexEnd%
  {
     RegRead, clen_private_DynamicClip%A_Index%, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%
  }
  clen_private_DynamicIndexEnd += 1

  TrayTip, clen : Static & Dynamic, All clipboards and options were restored, 10, 1
  return
}

clen_SaveSettings()
{
  local Value
  local Difference := clen_private_DynamicIndexEnd - clen_private_DynamicIndexBegin
  local Index = 0
  local ClipboardOld := ClipboardAll

  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  RegDelete, HKEY_CURRENT_USER, Software\clen

  Loop 9
  {
     Value := clen_private_SaveClipData(A_Index)
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, %A_Index%, %Value%
  }
  Value := clen_private_SaveClipData(0)
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, 0, %Value%

  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsStack, %clen_private_DynamicIsStack%
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsRestoreClipboard, %clen_public_ModeRestoreClipboard%
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\options, IsShowContent, %clen_private_Print%

  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count, %Difference%
  Loop %Difference%
  {
     Index := clen_private_DynamicIndexBegin + A_Index - 1
     Clipboard := clen_private_DynamicClip%Index%
     Value := Clipboard
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%, %Value%
  }

  Clipboard := ClipboardOld

  TrayTip, clen : Static & Dynamic, All clipboards and options were saved, 10, 1
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
