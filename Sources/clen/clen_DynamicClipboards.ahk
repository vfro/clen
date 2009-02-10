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


clen_DynamicCopy()
{
  local ClipboardOld := ClipboardAll

  clen_Copy()

  clen_DynamicClip%clen_DynamicIndexEnd% := ClipboardAll
  if (StrLen(clen_DynamicClip%clen_DynamicIndexEnd%) == 0)
  {
    return
  }

  clen_DynamicIndexEnd++

  if(clen_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }

  if(clen_Print)
  {
     clen_DynamicPrintAll()
  }
  return
}

clen_DynamicPaste(ReverseMode)
{
  local ClipboardOld := ClipboardAll
  local StackIndex := clen_DynamicIndexEnd - 1
  local StackMode = clen_DynamicIsStack
  if (ReverseMode == 11)
  {
     StackMode := !StackMode
  }

  if (!StackMode)
  {
     if (clen_DynamicIndexBegin >= clen_DynamicIndexEnd)
     {
        return
     }
     Clipboard := clen_DynamicClip%clen_DynamicIndexBegin%
     clen_DynamicClip%clen_DynamicIndexBegin% := ""
     clen_DynamicIndexBegin++
  }
  else
  {
     if (clen_DynamicIndexBegin >= clen_DynamicIndexEnd)
     {
        return
     }
     
     Clipboard := clen_DynamicClip%StackIndex%
     clen_DynamicClip%StackIndex% := ""
     clen_DynamicIndexEnd--
  }

  clen_Paste()

  if(clen_ModeRestoreClipboard)
  {
     Clipboard := ClipboardOld
  }

  if(clen_Print)
  {
     clen_DynamicPrintAll()
  }
  return
}

clen_DynamicPrintAll()
{
  local Difference := clen_DynamicIndexEnd - clen_DynamicIndexBegin
  local Index = 0
  local Content := ""
  local Type := ""
  local ClipboardOld := ClipboardAll

  Loop %Difference%
  {
     Index := clen_DynamicIndexBegin + A_Index - 1
     Clipboard := clen_DynamicClip%Index%
     Content .= "-> "
     Content .= Clipboard
     Content .= "`n"
  }

  if (!clen_DynamicIsStack)
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

!NumpadMult::
  clen_DynamicPrintAll()
  return

!NumpadEnd::
  if (clen_DynamicIsStack)
  {
     clen_DynamicIsStack = 0
     TrayTip, clen : Dynamic, Clipboard Dynamic model is switched to QUEUE, 10, 1
  }
  else
  {
     clen_DynamicIsStack = 1
     TrayTip, clen : Dynamic, Clipboard Dynamic model is switched to STACK, 10, 1
  }
  return

^NumpadIns::
  clen_DynamicCopy()
  return

+NumpadIns::
+NumpadDel::
  clen_DynamicPaste(clen_RecognizeNumpadHotkey(A_ThisHotkey))
  return
