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

clen_private_toogleNumLock()
{
  local Index

  if (clen_private_NumLockState == "D")
  {
     SetNumLockState, AlwaysOff
     clen_private_NumLockState := "U"
  }
  else
  {
     SetNumLockState, AlwaysOn
     clen_private_NumLockState := "D"
  }
  clen_private_NumLockHotkeysKeys()
}

clen_private_NumLockHotkeysKeys()
{
  local Index

  if (clen_private_NumLockState == "D")
  {
    Hotkey, NumpadEnd, On
    Hotkey, NumpadDown, On
    Hotkey, NumpadPgDn, On
    Hotkey, NumpadLeft, On
    Hotkey, NumpadClear, On
    Hotkey, NumpadRight, On
    Hotkey, NumpadHome, On
    Hotkey, NumpadUp, On
    Hotkey, NumpadPgUp, On
    Hotkey, NumpadIns, On
    Hotkey, NumpadDel, On
  }
  else
  {
    Hotkey, NumpadEnd, Off
    Hotkey, NumpadDown, Off
    Hotkey, NumpadPgDn, Off
    Hotkey, NumpadLeft, Off
    Hotkey, NumpadClear, Off
    Hotkey, NumpadRight, Off
    Hotkey, NumpadHome, Off
    Hotkey, NumpadUp, Off
    Hotkey, NumpadPgUp, Off
    Hotkey, NumpadIns, Off
    Hotkey, NumpadDel, Off
  }
}

NumLock::
  clen_private_toogleNumLock()
  clen_private_NumLockHotkeysKeys()
  return
