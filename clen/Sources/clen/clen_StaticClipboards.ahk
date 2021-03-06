; Copyright 2008-2020 Volodymyr Frolov
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
  if (!clen_ModeDuplicateToRegular)
  {
     clen_ChangeClipboard(ClipboardOld)
  }
  return
}

clen_StaticPaste(ClipboardNumber)
{
  local ClipboardOld := ClipboardAll

  clen_ChangeClipboard(clen_ClipBoard%ClipboardNumber%)

  if (clen_SuppressFormating)
  {
    clen_ChangeClipboard(Clipboard)
  }

  clen_Paste()

  if (!clen_ModeDuplicateToRegular)
  {
    clen_ChangeClipboard(ClipboardOld)
  }
  return
}

clen_GetClipPrintableData(ClipIndex)
{
  local Result =
  local ClipData

  ClipData := clen_GetPrintableValue(clen_ClipBoard%ClipIndex%)
  if ClipData is not space
  {
    Result = %ClipIndex%: %ClipData%`n
  }

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

  clen_TrayTip("Static", clipAll)
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

clen_CtrlNumpad(NumpadHotkey)
{
  local RemappedNumpadKey = SubStr(NumpadHotkey, 3)

  Hotkey, ^NumpadEnd, Off
  Hotkey, ^NumpadDown, Off
  Hotkey, ^NumpadPgDn, Off
  Hotkey, ^NumpadLeft, Off
  Hotkey, ^NumpadClear, Off
  Hotkey, ^NumpadRight, Off
  Hotkey, ^NumpadHome, Off
  Hotkey, ^NumpadUp, Off
  Hotkey, ^NumpadPgUp, Off
  Hotkey, ^NumpadIns, Off
  Hotkey, ^NumpadAdd, Off
  Hotkey, ^NumpadSub, Off
  Hotkey, ^NumpadMult, Off
  ; Uncomment when one of those hotkeys will be available
  ; Hotkey, ^NumpadDel, Off
  ; Hotkey, ^NumpadEnter, Off
  ; Hotkey, ^NumpadDiv, Off

  SendInput {Ctrl Down}{%RemappedNumpadKey% Down}{%RemappedNumpadKey% Up}{Ctrl Up}

  Hotkey, ^NumpadEnd, On
  Hotkey, ^NumpadDown, On
  Hotkey, ^NumpadPgDn, On
  Hotkey, ^NumpadLeft, On
  Hotkey, ^NumpadClear, On
  Hotkey, ^NumpadRight, On
  Hotkey, ^NumpadHome, On
  Hotkey, ^NumpadUp, On
  Hotkey, ^NumpadPgUp, On
  Hotkey, ^NumpadIns, On
  Hotkey, ^NumpadAdd, On
  Hotkey, ^NumpadSub, On
  Hotkey, ^NumpadMult, On
  ; Uncomment when one of those hotkeys will be available
  ; Hotkey, ^NumpadDel, On
  ; Hotkey, ^NumpadEnter, On
  ; Hotkey, ^NumpadDiv, On

  return
}

;
; Copy
;


!^NumpadEnd::
!^NumpadDown::
!^NumpadPgDn::
!^NumpadLeft::
!^NumpadClear::
!^NumpadRight::
!^NumpadHome::
!^NumpadUp::
!^NumpadPgUp::
!^NumpadIns::
!^NumpadDel::
!^NumpadEnter::
!^NumpadAdd::
!^NumpadSub::
!^NumpadMult::
!^NumpadDiv::
  clen_CtrlNumpad(A_ThisHotkey)
  return

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
