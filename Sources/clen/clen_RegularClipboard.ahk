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
    clen_PasswordClipboardCopy()
    return
  }

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

  if (clen_RegularFirstCall)
  {
    clen_RegularFirstCall := false
    return
  }

  if (clen_RegularPrint)
  {
    if (A_EventInfo == 1)
    {
      PrintableClipboard := clen_GetPrintableClipboardValue()
      TrayTip, clen : Regular,%PrintableClipboard%, 10, 1
    }
    else
    {
      TrayTip, clen : Regular,<binary data>, 10, 1
    }
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

      if (clen_RegularPrint)
      {
        if (clen_RegularClipInfo%Index% == 1)
        {
          PrintableClipboard := clen_GetPrintableClipboardValue()
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,%PrintableClipboard%, 10, 1
        }
        else
        {
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,<binary data>, 10, 1
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

    if (clen_RegularPrint)
    {
        if (clen_RegularClipInfo%Index% == 1)
        {
          PrintableClipboard := clen_GetPrintableClipboardValue()
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,%PrintableClipboard%, 10, 1
        }
        else
        {
          TrayTip, clen : Regular Value %clen_RegularIndex% from %clen_RegularMaxRedo%,<binary data>, 10, 1
        }
    }

  }
  else
  {
    TrayTip,
  }
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

!NumpadClear::
  clen_MenuOptionShowRegular(true)
  return
