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

clen_PasswordClipboardCopy()
{
  local Index := clen_RegularIndex - 1
  local ClipboardSize := StrLen(Clipboard)
  local ClipboardShow := ""
  local OldClipboard := ""

  clen_ClipboardPassword := ClipboardAll

  if (Index >= 0)
  {
    OldClipboard := clen_RegularClip%Index%
  }
  Clipboard := OldClipboard
  clen_WaitForPassword := false

  Loop %ClipboardSize%
  {
    ClipboardShow .= "*"
  }

  TrayTip, clen : Password,Password: %ClipboardShow%, 30, 1

  return
}

clen_PasswordClipboardPaste()
{
  local ClipboardOld := ClipboardAll

  if (!clen_WaitForPassword)
  {
    if (clen_ClipboardPassword <> "")
    {
      clen_ChangeClipboard(clen_ClipboardPassword)
      clen_Paste()

      clen_WaitForPassword := false
      clen_ClipboardPassword := ""

      clen_ChangeClipboard(ClipboardOld)

      TrayTip,
      return
    }
  }

  TrayTip, clen : Password,Password Clipboard is empty, 10, 1
  return
}

clen_PasswordClipboardWaitForCopy()
{
  local Index

  clen_WaitForPassword := true
  clen_ClipboardPassword := ""

  TrayTip, clen : Password,Waiting for password, 10, 1
  return
}

^NumpadMult::
  clen_PasswordClipboardWaitForCopy()
  return

+NumpadMult::
  clen_PasswordClipboardPaste()
  return
