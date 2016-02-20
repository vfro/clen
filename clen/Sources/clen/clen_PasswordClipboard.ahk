; Copyright 2008-2016 Volodymyr Frolov
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; http://www.apache.org/licenses/LICENSE-2.0
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

clen_PasswordClipboardShow(Size)
{
  local ClipboardShow := ""

  if (clen_Print)
  {
    Loop %Size%
    {
      ClipboardShow .= "*"
    }

    clen_TrayTip("Password", "Password: " . ClipboardShow)
  }
  return
}

clen_PasswordClipboardWaitedCopy()
{
  local Index := clen_RegularIndex - 1
  local ClipboardSize := StrLen(Clipboard)
  local OldClipboard := ""

  if (clen_SuppressFormating)
  {
    clen_ClipboardPassword := Clipboard
  }
  else
  {
    clen_ClipboardPassword := ClipboardAll
  }

  if (Index >= 0)
  {
    OldClipboard := clen_RegularClip%Index%
  }
  Clipboard := OldClipboard
  clen_WaitForPassword := false

  clen_PasswordClipboardShow(ClipboardSize)

  return
}

clen_PasswordClipboardCopy()
{
  local OldClipboard := ClipboardAll
  local ClipboardSize := 0

  clen_Copy()
  ClipboardSize := StrLen(Clipboard)

  if (clen_SuppressFormating)
  {
    clen_ClipboardPassword := Clipboard
  }
  else
  {
    clen_ClipboardPassword := ClipboardAll
  }

  clen_ChangeClipboard(OldClipboard)
  clen_WaitForPassword := false

  clen_PasswordClipboardShow(ClipboardSize)

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

      clen_HideTrayTip()
    }
  }

  if (clen_Print)
  {
    clen_TrayTip("Password", "Password Clipboard is empty")
  }
  return
}

clen_PasswordClipboardWaitForCopy()
{
  local Index

  clen_WaitForPassword := true
  clen_ClipboardPassword := ""

  if (clen_Print)
  {
    clen_TrayTip("Password", "Waiting for password")
  }
  return
}

+^NumpadMult::
  clen_PasswordClipboardWaitForCopy()
  return

^NumpadMult::
  clen_PasswordClipboardCopy()
  return

+NumpadMult::
  clen_PasswordClipboardPaste()
  return
