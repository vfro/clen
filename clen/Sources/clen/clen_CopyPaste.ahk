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


clen_Copy()
{
  local EmptyValue := ""

  clen_ChangeClipboard(EmptyValue)

  if (clen_CopyPasteInsert)
  {
    clen_RegularIgnoreChange := true
    SendInput {Ctrl Down}{Insert Down}{Insert Up}{Ctrl Up}
  }
  else
  {
    clen_RegularIgnoreChange := true
    SendInput {Ctrl Down}{c Down}{c Up}{Ctrl Up}
  }

  ClipWait, 0.5, 1
  clen_WaitForIngoreClipboardChange()
  return
}

clen_Paste()
{
  local Index

  if (clen_CopyPasteInsert)
  {
    SendInput {Shift Down}{Insert Down}{Insert Up}{Shift Up}
  }
  else
  {
    SendInput {Ctrl Down}{v Down}{v Up}{Ctrl Up}
  }

  Sleep, 100
  return
}

clen_WaitForIngoreClipboardChange()
{
  local Index
  ; Allow OnClipboardChange to be invoked and ignore clipboard change.
  ; This is necessary to prevent race conditions with OnClipboardChange event.
  Loop
  {
    Sleep, 5
    if (!clen_RegularIgnoreChange)
    {
      break
    }
  }

  return
}

clen_ChangeClipboard(ByRef NewValue)
{
  local Index

  clen_RegularIgnoreChange := true
  Clipboard := NewValue

  clen_WaitForIngoreClipboardChange()
  return
}

clen_GetPrintableValue(ByRef ClipboardValue)
{
  local PrintableValue
  local ClipboardOld := ClipboardAll

  clen_ChangeClipboard(ClipboardValue)
  PrintableValue := Clipboard
  clen_ChangeClipboard(ClipboardOld)

  return PrintableValue
}

clen_GetPrintableClipboardValue()
{
  return Clipboard
}
