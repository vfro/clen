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


clen_private_DynamicInitialize()
{
  local Index

  if (!clen_private_IsDynamicInitialized)
  {
     clen_private_IsDynamicInitialized = 1

     clen_private_DynamicIsStack = 0

     clen_private_DynamicIndexBegin = 1
     clen_private_DynamicIndexEnd = 1
  }
  return
}

clen_private_DynamicCopy()
{
  local ClipboardOld := ClipboardAll

  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  clen_private_Copy()

  clen_private_DynamicClip%clen_private_DynamicIndexEnd% := ClipboardAll
  clen_private_DynamicIndexEnd++

  if(clen_public_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }

  if(clen_private_Print)
  {
     clen_private_DynamicPrintAll()
  }
  return
}

clen_private_DynamicPaste(ReverseMode)
{
  local ClipboardOld := ClipboardAll
  local StackIndex := clen_private_DynamicIndexEnd - 1
  local StackMode = clen_private_DynamicIsStack
  if (ReverseMode)
  {
     StackMode := !StackMode
  }

  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  if (!StackMode)
  {
     if (clen_private_DynamicIndexBegin >= clen_private_DynamicIndexEnd)
     {
        clen_private_Paste()
        return
     }
     Clipboard := clen_private_DynamicClip%clen_private_DynamicIndexBegin%
     clen_private_DynamicClip%clen_private_DynamicIndexBegin% := ""
     clen_private_DynamicIndexBegin++
  }
  else
  {
     if (clen_private_DynamicIndexBegin >= clen_private_DynamicIndexEnd)
     {
        clen_private_Paste()
        return
     }
     
     Clipboard := clen_private_DynamicClip%StackIndex%
     clen_private_DynamicClip%StackIndex% := ""
     clen_private_DynamicIndexEnd--
  }

  clen_private_Paste()

  Sleep, 100
  if(clen_public_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }

  if(clen_private_Print)
  {
     clen_private_DynamicPrintAll()
  }
  return
}

clen_private_DynamicPrintAll()
{
  local Difference := clen_private_DynamicIndexEnd - clen_private_DynamicIndexBegin
  local Index = 0
  local Content := ""
  local Type := ""
  local ClipboardOld := ClipboardAll

  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  Loop %Difference%
  {
     Index := clen_private_DynamicIndexBegin + A_Index - 1
     Clipboard := clen_private_DynamicClip%Index%
     Content .= "-> "
     Content .= Clipboard
     Content .= "`n"
  }

  if (!clen_private_DynamicIsStack)
  {
     Type := "QUEUE"
  }
  else
  {
     Type := "STACK"
  }

  Clipboard := ClipboardOld
  TrayTip, clen : Dynamic %Type%, %Content%, 10, 1
}

>+F12::
  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()

  if (clen_private_DynamicIsStack)
  {
     clen_private_DynamicIsStack = 0
     TrayTip, clen : Dynamic, Clipboard Dynamic model is switched to QUEUE, 10, 1
  }
  else
  {
     clen_private_DynamicIsStack = 1
     TrayTip, clen : Dynamic, Clipboard Dynamic model is switched to STACK, 10, 1
  }
  return

>^Insert::
  clen_private_DynamicCopy()
  return

>+Insert::
  clen_private_DynamicPaste(false)
  return

>+Delete::
  clen_private_DynamicPaste(true)
  return

>+PrintScreen::
  clen_private_DynamicPrintAll()
  return
