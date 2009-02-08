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


clen_private_Initialize()

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

clen_private_Initialize()
{
  clen_private_DynamicInitialize()
  clen_private_StaticInitialize()
  return
}
