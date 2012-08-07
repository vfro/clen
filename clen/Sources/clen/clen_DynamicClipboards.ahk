; Copyright 2008-2012 Volodymyr Frolov
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

  if(!clen_ModeDuplicateToRegular)
  {
     clen_ChangeClipboard(ClipboardOld)
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
     clen_ChangeClipboard(clen_DynamicClip%clen_DynamicIndexBegin%)

     clen_DynamicClip%clen_DynamicIndexBegin% := ""
     clen_DynamicIndexBegin++
  }
  else
  {
     if (clen_DynamicIndexBegin >= clen_DynamicIndexEnd)
     {
        return
     }

     clen_ChangeClipboard(clen_DynamicClip%StackIndex%)

     clen_DynamicClip%StackIndex% := ""
     clen_DynamicIndexEnd--
  }

  if (clen_SuppressFormating)
  {
    clen_ChangeClipboard(Clipboard)
  }

  clen_Paste()

  if(!clen_ModeDuplicateToRegular)
  {
     clen_ChangeClipboard(ClipboardOld)
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
  local PrintableValue

  Loop %Difference%
  {
     Index := clen_DynamicIndexBegin + A_Index - 1

     PrintableValue := clen_GetPrintableValue(clen_DynamicClip%Index%)

     Content .= "• "
     Content .= PrintableValue
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

  TrayTip, clen : Dynamic %Type%, %Content%, 10, 1, 16
  return
}

clen_PasteList(ReverseMode)
{
  local ClipboardOld := ClipboardAll
  local Separator := ClipboardAll

  while (clen_DynamicIndexBegin < clen_DynamicIndexEnd)
  {
    clen_DynamicPaste(ReverseMode)
    if (clen_DynamicIndexBegin < clen_DynamicIndexEnd)
    {
      clen_ChangeClipboard(Separator)
      clen_Paste()
    }
  }

  clen_ChangeClipboard(ClipboardOld)

  if(clen_Print)
  {
     TrayTip, , , 10, 1, 16
  }
  return
}

!NumpadMult::
  clen_DynamicPrintAll()
  return

^NumpadIns::
  clen_DynamicCopy()
  return

+NumpadIns::
+NumpadDel::
  clen_DynamicPaste(clen_RecognizeNumpadHotkey(A_ThisHotkey))
  return

^+NumpadIns::
^+NumpadDel::
  clen_PasteList(clen_RecognizeNumpadHotkey(A_ThisHotkey))
  return
