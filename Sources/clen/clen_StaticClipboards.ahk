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


clen_StaticCopy(ClipboardNumber)
{
  local ClipboardOld := ClipboardAll

  clen_private_Copy()
  clen_private_ClipBoard%ClipboardNumber% := ClipboardAll
  if (clen_public_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }
  return
}

clen_StaticPaste(ClipboardNumber)
{
  local ClipboardOld := ClipboardAll

  Clipboard := clen_private_ClipBoard%ClipboardNumber%
  clen_private_Paste()
  Sleep, 100
  if (clen_public_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }
  return
}

clen_private_GetClipPrintableData(ClipIndex)
{
  local Result =
  local ClipData =
  local ClipboardOld := ClipboardAll

  Clipboard := clen_private_ClipBoard%ClipIndex%
  ClipData := Clipboard
  if ClipData is not space
  {
    Result = %ClipIndex% -> %ClipData%`n
  }

  Clipboard := ClipboardOld
  return %Result%
}

clen_private_PrintStaticContent()
{
  local clipAll =

  Loop 9
  {
     clipAll .= clen_private_GetClipPrintableData(A_Index)
  }
  clipAll .= clen_private_GetClipPrintableData(0)
  TrayTip, clen : Static, %clipAll%, 10, 1
  return
}

clen_private_PrintStatic()
{
  local Index
  if(clen_private_Print)
  {
     clen_private_PrintStaticContent()
  }
  return
}

!NumpadDiv::
  clen_private_PrintStaticContent()
  return

!NumpadPgDn::
  if (clen_public_ModeRestoreClipboard)
  {
     clen_public_ModeRestoreClipboard := 0
     TrayTip, clen : Static & Dynamic, Copy to regular clipboard is turned ON, 10, 1
  }
  else
  {
     clen_public_ModeRestoreClipboard := 1
     TrayTip, clen : Static & Dynamic, Copy to regular clipboard is turned OFF, 10, 1
  }
  return

!NumpadDown::
  if (clen_private_Print)
  {
     clen_private_Print = 0
     TrayTip, clen : Static & Dynamic, Show keyboard content is turned OFF, 10, 1
  }
  else
  {
     clen_private_Print = 1
     TrayTip, clen : Static & Dynamic, Show keyboard content is turned ON, 10, 1
  }
  return

;
; Copy
;

^NumpadEnd::
^NumpadDown::
^NumpadPgDn::
^NumpadLeft::
^NumpadClear::
^NumpadRight::
^NumpadHome::
^NumpadUp::
^NumpadPgUp::
  clen_StaticCopy(clen_private_RecognizeNumpadHotkey(A_ThisHotkey))
  clen_private_PrintStatic()
  return

;
; Paste
;

+NumpadEnd::
+NumpadDown::
+NumpadPgDn::
+NumpadLeft::
+NumpadClear::
+NumpadRight::
+NumpadHome::
+NumpadUp::
+NumpadPgUp::
  clen_StaticPaste(clen_private_RecognizeNumpadHotkey(A_ThisHotkey))
  clen_private_PrintStatic()
  return
