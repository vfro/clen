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

  clen_Copy()
  clen_ClipBoard%ClipboardNumber% := ClipboardAll
  if (clen_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }
  return
}

clen_StaticPaste(ClipboardNumber)
{
  local ClipboardOld := ClipboardAll

  Clipboard := clen_ClipBoard%ClipboardNumber%
  clen_Paste()
  Sleep, 100
  if (clen_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }
  return
}

clen_GetClipPrintableData(ClipIndex)
{
  local Result =
  local ClipData =
  local ClipboardOld := ClipboardAll

  Clipboard := clen_ClipBoard%ClipIndex%
  ClipData := Clipboard
  if ClipData is not space
  {
    Result = %ClipIndex% -> %ClipData%`n
  }

  Clipboard := ClipboardOld
  return %Result%
}

clen_PrintStaticContent()
{
  local clipAll =

  Loop 9
  {
     clipAll .= clen_GetClipPrintableData(A_Index)
  }
  clipAll .= clen_GetClipPrintableData(0)
  TrayTip, clen : Static, %clipAll%, 10, 1
  return
}

clen_PrintStatic()
{
  local Index
  if(clen_Print)
  {
     clen_PrintStaticContent()
  }
  return
}

!NumpadDiv::
  clen_PrintStaticContent()
  return

!NumpadPgDn::
  if (clen_ModeRestoreClipboard)
  {
     clen_ModeRestoreClipboard := 0
     TrayTip, clen : Static & Dynamic, Copy to regular clipboard is turned ON, 10, 1
  }
  else
  {
     clen_ModeRestoreClipboard := 1
     TrayTip, clen : Static & Dynamic, Copy to regular clipboard is turned OFF, 10, 1
  }
  return

!NumpadDown::
  if (clen_Print)
  {
     clen_Print = 0
     TrayTip, clen : Static & Dynamic, Show keyboard content is turned OFF, 10, 1
  }
  else
  {
     clen_Print = 1
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
  clen_StaticCopy(clen_RecognizeNumpadHotkey(A_ThisHotkey))
  clen_PrintStatic()
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
  clen_StaticPaste(clen_RecognizeNumpadHotkey(A_ThisHotkey))
  clen_PrintStatic()
  return
