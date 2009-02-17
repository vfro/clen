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

  if (clen_RegularIgnoreChange)
  {
    clen_RegularIgnoreChange := fasle
    return
  }

  if (A_EventInfo == 1)
  {
    clen_RegularClip%clen_RegularIndex% := ClipboardAll

    clen_RegularIndex++
    clen_RegularMaxRedo := clen_RegularIndex
  }

  if (clen_RegularFirstCall)
  {
    clen_RegularFirstCall := false
    return
  }

  if (A_EventInfo == 1)
  {
    if (clen_RegularPrint)
    {
      TrayTip, clen : Regular, Insert -> %Clipboard%, 10, 1
    }
  }
  return
}

clen_RegularUndo()
{
  local Index = clen_RegularIndex - 2

  if (clen_RegularIndex > 0)
  {
    clen_RegularIndex--

    if (clen_RegularIndex > 0)
    {
      clen_RegularIgnoreChange := true
      Clipboard := clen_RegularClip%Index%

      if (clen_RegularPrint)
      {
        TrayTip, clen : Regular, Value(%clen_RegularIndex% from %clen_RegularMaxRedo%) -> %Clipboard%, 10, 1
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
  local Index

  if (clen_RegularIndex < clen_RegularMaxRedo)
  {
    clen_RegularIgnoreChange := true
    Clipboard := clen_RegularClip%clen_RegularIndex%
    clen_RegularIndex++

    if (clen_RegularPrint)
    {
      TrayTip, clen : Regular, Value(%clen_RegularIndex% from %clen_RegularMaxRedo%) -> %Clipboard%, 10, 1
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
