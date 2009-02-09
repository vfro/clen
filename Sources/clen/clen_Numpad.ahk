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


clen_private_RecognizeNumpadHotkey(NumpadHotkey)
{
  local Index
  Loop 10
  {
    Index := A_Index - 1
    IfInString, NumpadHotkey, Numpad%Index%
    {
       return Index
    }
  }
  IfInString, NumpadHotkey, NumpadEnd
  {
    return 1
  }
  IfInString, NumpadHotkey, NumpadDown
  {
    return 2
  }
  IfInString, NumpadHotkey, NumpadPgDn
  {
    return 3
  }
  IfInString, NumpadHotkey, NumpadLeft
  {
    return 4
  }
  IfInString, NumpadHotkey, NumpadClear
  {
    return 5
  }
  IfInString, NumpadHotkey, NumpadRight
  {
    return 6
  }
  IfInString, NumpadHotkey, NumpadHome
  {
    return 7
  }
  IfInString, NumpadHotkey, NumpadUp
  {
    return 8
  }
  IfInString, NumpadHotkey, NumpadPgUp
  {
    return 9
  }
  IfInString, NumpadHotkey, NumpadIns
  {
    return 10
  }
  IfInString, NumpadHotkey, NumpadDel
  {
    return 11
  }
  IfInString, NumpadHotkey, NumpadDot
  {
    return 11
  }
  return
}

clen_private_InstallPressed(Mode)
{
  Hotkey, SC04F, Pressed1, %Mode%
  Hotkey, SC050, Pressed2, %Mode%
  Hotkey, SC051, Pressed3, %Mode%
  Hotkey, SC04B, Pressed4, %Mode%
  Hotkey, SC04C, Pressed5, %Mode%
  Hotkey, SC04D, Pressed6, %Mode%
  Hotkey, SC047, Pressed7, %Mode%
  Hotkey, SC048, Pressed8, %Mode%
  Hotkey, SC049, Pressed9, %Mode%
  Hotkey, SC052, PressedIns, %Mode%
  Hotkey, SC053, PressedDel, %Mode%
}

Pressed1:
Pressed2:
Pressed3:
Pressed4:
Pressed5:
Pressed6:
Pressed7:
Pressed8:
Pressed9:
  clen_StaticPaste(SubStr(A_ThisLabel, 8, 1))
  clen_private_PrintStatic()
  return

PressedIns:
  clen_private_DynamicPaste(10)
  return

PressedDel:
  clen_private_DynamicPaste(11)
  return
