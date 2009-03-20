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


clen_Initialize()

clen_InitializeCopyPasteMode()
{
  local Index

  clen_IsCopyPasteModeInitialized = 1

  clen_CopyPasteInsert := true

  return
}

clen_DynamicInitialize()
{
  local Index

  clen_DynamicIsStack = 0

  clen_DynamicIndexBegin = 1
  clen_DynamicIndexEnd = 1

  return
}

clen_StaticInitialize()
{
  local Index

  clen_Print = 1
  clen_ModeDuplicateToRegular = 0

  clen_ClipBoard0 := ""
  clen_ClipBoard1 := ""
  clen_ClipBoard2 := ""
  clen_ClipBoard3 := ""
  clen_ClipBoard4 := ""
  clen_ClipBoard5 := ""
  clen_ClipBoard6 := ""
  clen_ClipBoard7 := ""
  clen_ClipBoard8 := ""
  clen_ClipBoard9 := ""

  return
}

clen_RegularInitialize()
{
  local Index

  clen_RegularPrint := true
  clen_RegularIgnoreChange := false

  clen_RegularIndex = 0
  clen_RegularMaxRedo = 0

  clen_RegularFirstCall := true

  return
}

clen_PasswordInitialize()
{
  local Index
  clen_WaitForPassword := false
  clen_ClipboardPassword := ""
  return
}

clen_Initialize()
{
  clen_DynamicInitialize()
  clen_StaticInitialize()
  clen_RegularInitialize()
  clen_PasswordInitialize()
  clen_InitializeCopyPasteMode()
  clen_InitializeTrayMenu()
  return
}
