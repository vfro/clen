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

>^PrintScreen::
  clen_private_PrintStaticContent()
  return

>+F10::
  clen_private_StaticInitialize()

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

>+F11::
  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

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

>^1::
>^2::
>^3::
>^4::
>^5::
>^6::
>^7::
>^8::
>^9::
>^0::
  clen_StaticCopy(SubStr(A_ThisHotKey, 3, 1))
  clen_private_PrintStatic()
  return

>^>+1::
>^>+2::
>^>+3::
>^>+4::
>^>+5::
>^>+6::
>^>+7::
>^>+8::
>^>+9::
>^>+0::
  clen_StaticPaste(SubStr(A_ThisHotKey, 5, 1))
  clen_private_PrintStatic()
  return
