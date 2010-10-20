@echo off

rem Copyright 2008-2010 Volodymyr Frolov
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem http://www.apache.org/licenses/LICENSE-2.0
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

taskkill /IM clipboard_enhanced-v2.0.exe > nul 2>&1

type clen\clen_Initialize.ahk > clen-all.ahk
type clen\clen_Numpad.ahk >> clen-all.ahk
type clen\clen_CopyPaste.ahk >> clen-all.ahk
type clen\clen_DynamicClipboards.ahk >> clen-all.ahk
type clen\clen_StaticClipboards.ahk >> clen-all.ahk
type clen\clen_RegularClipboard.ahk >> clen-all.ahk
type clen\clen_PasswordClipboard.ahk >> clen-all.ahk
type clen\clen_SaveLoad.ahk >> clen-all.ahk
type clen\clen_TrayMenu.ahk >> clen-all.ahk

Ahk2Exe.exe /in clen-all.ahk /icon ../Resources/clen.ico /out clipboard_enhanced-v2.0.exe /NoDecompile
start clipboard_enhanced-v2.0.exe
