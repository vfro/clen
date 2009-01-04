; Copyright 2008-2009 Vladimir Frolov
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; http://www.apache.org/licenses/LICENSE-2.0
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.


clen_private_StaticInitialize()
{
   local Index

   if (!clen_private_IsStaticInitialized)
   {
      clen_private_Print = 1

      clen_private_IsStaticInitialized = 1
      clen_public_ModeRestoreClipboard = 1

      clen_private_ClipBoard0 := ""
      clen_private_ClipBoard1 := ""
      clen_private_ClipBoard2 := ""
      clen_private_ClipBoard3 := ""
      clen_private_ClipBoard4 := ""
      clen_private_ClipBoard5 := ""
      clen_private_ClipBoard6 := ""
      clen_private_ClipBoard7 := ""
      clen_private_ClipBoard8 := ""
      clen_private_ClipBoard9 := ""
   }
   return
}

clen_StaticCopy(ClipboardNumber)
{
  local ClipboardOld := ClipboardAll
  clen_private_StaticInitialize()

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
  clen_private_StaticInitialize()

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
  clen_private_StaticInitialize()

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
  clen_private_StaticInitialize()
  if(clen_private_Print)
  {
     clen_private_PrintStaticContent()
  }
  return
}

RWin::
  clen_private_PrintStaticContent()
  return

RShift & F10::
  clen_private_StaticInitialize()

  if (clen_public_ModeRestoreClipboard)
  {
     clen_public_ModeRestoreClipboard := 0
     TrayTip, clen :, Copy to regular clipboard is turned ON, 10, 1
  }
  else
  {
     clen_public_ModeRestoreClipboard := 1
     TrayTip, clen :, Copy to regular clipboard is turned OFF, 10, 1
  }
  return


RShift & F11::
  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  if (clen_private_Print)
  {
     clen_private_Print = 0
     TrayTip, clen :, Show keyboard content is turned OFF, 10, 1
  }
  else
  {
     clen_private_Print = 1
     TrayTip, clen :, Show keyboard content is turned ON, 10, 1
  }
  return

RCtrl & 1::
  clen_StaticCopy(1)
  clen_private_PrintStatic()
  return

RShift & 1::
  clen_StaticPaste(1)
  clen_private_PrintStatic()
  return

RCtrl & 2::
  clen_StaticCopy(2)
  clen_private_PrintStatic()
  return

RShift & 2::
  clen_StaticPaste(2)
  clen_private_PrintStatic()
  return

RCtrl & 3::
  clen_StaticCopy(3)
  clen_private_PrintStatic()
  return

RShift & 3::
  clen_StaticPaste(3)
  clen_private_PrintStatic()
  return

RCtrl & 4::
  clen_StaticCopy(4)
  clen_private_PrintStatic()
  return

RShift & 4::
  clen_StaticPaste(4)
  clen_private_PrintStatic()
  return

RCtrl & 5::
  clen_StaticCopy(5)
  clen_private_PrintStatic()
  return

RShift & 5::
  clen_StaticPaste(5)
  clen_private_PrintStatic()
  return

RCtrl & 6::
  clen_StaticCopy(6)
  clen_private_PrintStatic()
  return

RShift & 6::
  clen_StaticPaste(6)
  clen_private_PrintStatic()
  return

RCtrl & 7::
  clen_StaticCopy(7)
  clen_private_PrintStatic()
  return

RShift & 7::
  clen_StaticPaste(7)
  clen_private_PrintStatic()
  return

RCtrl & 8::
  clen_StaticCopy(8)
  clen_private_PrintStatic()
  return

RShift & 8::
  clen_StaticPaste(8)
  clen_private_PrintStatic()
  return

RCtrl & 9::
  clen_StaticCopy(9)
  clen_private_PrintStatic()
  return

RShift & 9::
  clen_StaticPaste(9)
  clen_private_PrintStatic()
  return

RCtrl & 0::
  clen_StaticCopy(0)
  clen_private_PrintStatic()
  return

RShift & 0::
  clen_StaticPaste(0)
  clen_private_PrintStatic()
  return
