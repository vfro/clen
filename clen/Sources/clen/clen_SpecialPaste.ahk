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

clen_InsertWithoutFormat()
{
  local ClipboardOld := ClipboardAll

  clen_ChangeClipboard(Clipboard)
  clen_Paste()
  clen_ChangeClipboard(ClipboardOld)

  return
}

clen_DirectInsert()
{
  local ClipboardOld := ClipboardAll

  clen_ChangeClipboard(Clipboard)
  SendInput {Raw}%Clipboard%
  clen_ChangeClipboard(ClipboardOld)

  return
}

clen_InsertUpper()
{
  local ClipboardOld := ClipboardAll
  local UpperClipboard := Clipboard
  StringUpper, UpperClipboard, UpperClipboard

  clen_ChangeClipboard(UpperClipboard)
  clen_Paste()
  clen_ChangeClipboard(ClipboardOld)

  return
}

clen_InsertLower()
{
  local ClipboardOld := ClipboardAll
  local LowerClipboard := Clipboard
  StringLower, LowerClipboard, LowerClipboard

  clen_ChangeClipboard(LowerClipboard)
  clen_Paste()
  clen_ChangeClipboard(ClipboardOld)

  return
}

clen_InsertSortedAsc()
{
  local ClipboardOld := ClipboardAll
  local SortedClipboard := Clipboard
  Sort, SortedClipboard

  clen_ChangeClipboard(SortedClipboard)
  clen_Paste()
  clen_ChangeClipboard(ClipboardOld)

  return
}

clen_InsertSortedDesc()
{
  local ClipboardOld := ClipboardAll
  local SortedClipboard := Clipboard
  Sort, SortedClipboard, R

  clen_ChangeClipboard(SortedClipboard)
  clen_Paste()
  clen_ChangeClipboard(ClipboardOld)

  return
}

#Delete::
  clen_InsertWithoutFormat()
  return

#Insert::
  clen_DirectInsert()
  return

#Home::
  clen_InsertSortedAsc()
  return

#End::
  clen_InsertSortedDesc()
  return

#PgUp::
  clen_InsertUpper()
  return

#PgDn::
  clen_InsertLower()
  return
