; Copyright 2008-2010 Volodymyr Frolov
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

  clen_ChangeClipboard(clen_ClipBoard%ClipIndex%)
  ClipData := Clipboard
  if ClipData is not space
  {
    Result = %ClipData%
  }

  clen_ChangeClipboard(ClipboardOld)
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

  clen_DynamicIndexBegin = 1
  RegRead, clen_DynamicIndexEnd, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count
  Loop %clen_DynamicIndexEnd%
  {
     RegRead, clen_DynamicClip%A_Index%, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%
  }
  clen_DynamicIndexEnd += 1

  TrayTip, clen : Static & Dynamic, Dynamic and static clipboards were loaded, 10, 1, 16
  return
}

clen_SaveSettings()
{
  local Value
  local Difference := clen_DynamicIndexEnd - clen_DynamicIndexBegin
  local Index = 0
  local ClipboardOld := ClipboardAll

  RegDelete, HKEY_CURRENT_USER, Software\clen

  Loop 9
  {
     Value := clen_SaveClipData(A_Index)
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, %A_Index%, %Value%
  }
  Value := clen_SaveClipData(0)
  RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\static, 0, %Value%

  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\clen\dynamic, count, %Difference%
  Loop %Difference%
  {
     Index := clen_DynamicIndexBegin + A_Index - 1

     clen_ChangeClipboard(clen_DynamicClip%Index%)
     Value := Clipboard
     RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\clen\dynamic, %A_Index%, %Value%
  }

  clen_ChangeClipboard(ClipboardOld)

  TrayTip, clen : Static & Dynamic, Dynamic and static clipboards were saved, 10, 1, 16
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
