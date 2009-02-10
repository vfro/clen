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


clen_ToCase(toCase)
{
  local ClipboardOld := ClipboardAll
  local Value

  clen_Copy()

  Value := Clipboard
  if (toCase)
  {
     StringUpper, Value, Value
  }
  else
  {
     StringLower, Value, Value
  }
  Clipboard := Value

  clen_Paste()

  if (clen_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }
  return
}

^NumpadSub::
  clen_ToCase(false)
  return

^NumpadAdd::
  clen_ToCase(true)
  return
