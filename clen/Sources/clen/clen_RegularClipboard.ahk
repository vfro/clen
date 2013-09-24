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

clen_RegularClipboardChaged()
{
  local Index
  local PrevClipboardValue
  local PrintableClipboard

  if (clen_RegularIgnoreChange)
  {
    clen_RegularIgnoreChange := false
    return
  }

  if (clen_WaitForPassword)
  {
    clen_PasswordClipboardWaitedCopy()
    return
  }

  if (A_EventInfo == 1 and clen_SuppressFormating)
  {
    Clipboard := Clipboard
  }

  clen_RegularIndex := clen_RegularMaxRedo
  clen_RegularClip%clen_RegularIndex% := ClipboardAll
  clen_RegularClipInfo%clen_RegularIndex% := A_EventInfo

  Index := clen_RegularIndex - 1
  if (Index >= 0)
  {
    PrevClipboardValue := clen_RegularClip%Index%
  }

  if clen_RegularClip%clen_RegularIndex% <> %PrevClipboardValue%
  {
    clen_RegularIndex++
    clen_RegularMaxRedo := clen_RegularIndex
  }
  else
  {
    return
  }

  clen_ControlMenu()

  if (clen_RegularFirstCall)
  {
    clen_RegularFirstCall := false
    return
  }

  if (clen_Print)
  {
    if (A_EventInfo == 1)
    {
      PrintableClipboard := clen_GetPrintableClipboardValue()
      TrayTip, clen : Regular,%PrintableClipboard%, 10, 1, 16
    }
    else
    {
      TrayTip, clen : Regular,<binary data>, 10, 1, 16
    }
  }

  return
}

clen_ControlMenu()
{
  local Fake

  if (clen_RegularMaxRedo > clen_RegularIndex)
  {
    clen_MenuRegularRedoEnable(true)
  }
  else
  {
    clen_MenuRegularRedoEnable(false)
  }

  if (clen_RegularIndex >= 2)
  {
    clen_MenuRegularUndoEnable(true)
  }
  else
  {
    clen_MenuRegularUndoEnable(false)
  }
  return
}

clen_RegularUndo()
{
  local Index = clen_RegularIndex - 2
  local PrintableClipboard

  if (clen_RegularIndex > 0)
  {
    clen_RegularIndex--

    if (clen_RegularIndex > 0)
    {
      clen_ChangeClipboard(clen_RegularClip%Index%)

      if (clen_Print)
      {
        if (clen_RegularClipInfo%Index% == 1)
        {
          PrintableClipboard := clen_GetPrintableClipboardValue()
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,%PrintableClipboard%, 10, 1, 16
        }
        else
        {
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,<binary data>, 10, 1, 16
        }
      }
    }
    else
    {
      TrayTip,
    }
  }
  else
  {
    TrayTip,
  }

  clen_ControlMenu()
  return
}

clen_RegularRedo()
{
  local Index := clen_RegularIndex
  local PrintableClipboard

  if (clen_RegularIndex < clen_RegularMaxRedo)
  {
    clen_ChangeClipboard(clen_RegularClip%clen_RegularIndex%)
    clen_RegularIndex++

    if (clen_Print)
    {
        if (clen_RegularClipInfo%Index% == 1)
        {
          PrintableClipboard := clen_GetPrintableClipboardValue()
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,%PrintableClipboard%, 10, 1, 16
        }
        else
        {
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,<binary data>, 10, 1, 16
        }
    }

  }
  else
  {
    TrayTip,
  }

  clen_ControlMenu()
  return
}

OnClipboardChange:
  clen_RegularClipboardChaged()
  return

^NumpadSub::
  clen_RegularUndo()
  return

^NumpadAdd::
  clen_RegularRedo()
  return
