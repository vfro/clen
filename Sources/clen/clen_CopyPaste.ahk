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


clen_Copy()
{
  local Index

  Clipboard =
  if (clen_CopyPasteInsert)
  {
    SendInput {Ctrl Down}{Insert Down}{Insert Up}{Ctrl Up}
  }
  else
  {
    SendInput {Ctrl Down}{c Down}{c Up}{Ctrl Up}
  }

  ClipWait, 0.5, 1
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

clen_ChangeCopyPasteMode()
{
  local Index

  clen_MenuOptionCopyPaste(true)
  return
}

!NumpadLeft::
  clen_ChangeCopyPasteMode()
  return
