@echo off

rem Copyright 2008-2016 Volodymyr Frolov
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem http://www.apache.org/licenses/LICENSE-2.0
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

echo Clean Up ...
taskkill /IM clipboard_enhanced-v2.3-x32.exe > nul 2>&1
del clipboard_enhanced-v2.3-x32.exe > nul 2>&1
taskkill /IM clipboard_enhanced-v2.3-x64.exe > nul 2>&1
del clipboard_enhanced-v2.3-x64.exe > nul 2>&1

echo Merge Sources ...
type clen\clen_Initialize.ahk > clen-all.ahk
type clen\clen_Numpad.ahk >> clen-all.ahk
type clen\clen_CopyPaste.ahk >> clen-all.ahk
type clen\clen_DynamicClipboards.ahk >> clen-all.ahk
type clen\clen_StaticClipboards.ahk >> clen-all.ahk
type clen\clen_RegularClipboard.ahk >> clen-all.ahk
type clen\clen_PasswordClipboard.ahk >> clen-all.ahk
type clen\clen_SpecialPaste.ahk >> clen-all.ahk
type clen\clen_SaveLoad.ahk >> clen-all.ahk
type clen\clen_TrayMenu.ahk >> clen-all.ahk

echo Compile clen x32 ...
"%AHK_HOME%\Ahk2Exe.exe" /in clen-all.ahk /icon ../Resources/clen.ico /out clipboard_enhanced-v2.3-x32.exe /bin "%AHK_HOME%\Unicode 32-bit.bin"

echo Compile clen x64 ...
"%AHK_HOME%\Ahk2Exe.exe" /in clen-all.ahk /icon ../Resources/clen.ico /out clipboard_enhanced-v2.3-x64.exe /bin "%AHK_HOME%\Unicode 64-bit.bin"

echo Start clen x64 ...
start clipboard_enhanced-v2.3-x64.exe
