@echo off

rem Copyright 2008-2009 Volodymyr Frolov
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem http://www.apache.org/licenses/LICENSE-2.0
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

cat clen\clen_Initialize.ahk > clen.ahk
cat clen\clen_Numpad.ahk >> clen.ahk
cat clen\clen_Representation.ahk >> clen.ahk
cat clen\clen_CopyPaste.ahk >> clen.ahk
cat clen\clen_DynamicClipboards.ahk >> clen.ahk
cat clen\clen_StaticClipboards.ahk >> clen.ahk
cat clen\clen_SaveLoad.ahk >> clen.ahk
cat clen\clen_Case.ahk >> clen.ahk

Ahk2Exe.exe /in clen.ahk /icon clen.ico /out clipboard_enhanced.exe /NoDecompile
