# Clipboard Enhanced

Clipboard Enhanced (clen) is a clipboard manager for programmers. It provides tracking history of the regular Windows clipboard as well as several additional clipboard types for exchanging values in different ways.

## Introduction

Clipboard Enhanced (clen) is a free clipboard manager which is designed for programmers. In addition to tracking history of a regular Windows clipboard it provides several additional clipboard types for exchanging values in different ways.

### Regular Clipboard

Clen tracks history for a regular Windows clipboard. You may browse it by pressing *Ctrl+Numpad Sub* / *Ctrl+ Numpad Add* hotkeys or selecting "Regular Clipboard\Previous Value" or "Regular Clipboard\Next Value" from tray menu.

### Static Clipboards

Clen provides nine static clipboards. You may copy some value to any of it and then paste it back at any time. The hotkeys for Static Clipboards are the following:
* Press *Ctrl + Numpad Number (form 1 to 9)* to copy a value into one of the static clipboard.
* Press *Shift + Numpad Number (form 1 to 9)* to paste a value from one of the static clipboard.

Please note that all *Numpad Number* hotkeys work only with Num Lock turned off.

### Dynamic Clipboards

In addition to static clipboards clen provides dynamic clipboard which can contain multiple values. You can paste them as a queue or a stack. The hotkeys for Static Clipboards are the following:

* Press *Ctrl + Numpad Insert* to copy and push new value into top of the queue.
* Press *Shift + Numpad Insert* to paste and remove a value from bottom of the queue.
* Press *Shift + Numpad Delete* to paste and remove a value from top of the queue.

### Password Clipboard

Password clipboard shows asterisks instead of real value in notification balloon, don't track any history, and clears automatically right after pasting.

Some password managers insert password values into a Windows clipboard. Password clipboard has an option to wait for a password and intercept it. Value is copied into password clipboard instead of a Windows one.

* Press *Ctrl + Numpad Mult* to copy a value into the password clipboard.
* Press *Shift + Numpad Mult* to paste a value and clear the password clipboard.
* Press *Ctrl + Shift + Numpad Mult* to wait for a password.

### Options

#### Stack-based dynamic clipboard model
By default dynamic clipboard works as FIFO (first in first out). Turn on this option and dynamic clipboard will work as FILO (first in last out).

#### Duplicate values to regular clipboard
When this option is turned on regular clipboard contains the same value as copied or pasted into static or dynamic clipboard. By default this option is turned off.

#### Automatically show content
Show notifications in a tray balloon each time when one of clipboards is changed.

#### Copy\Paste via Ctrl+Insert\Shift+Insert
Some programs don't work with Ctrl+Insert\Shift+Insert hotkeys as Copy\Paste commands, but some of them don't work with Ctrl+C\Ctrl+V. This option allow you to customize hotkey which is used by clen for coping to and pasting from all clipboard types. By default clen will use Ctrl+Insert\Shift+Insert.

#### Run when Windows starts
Clen will run at Windows startup.

#### Your feedback is very welcome
Clen is a subject of change. Fill free to create new issues for your proposals.

Powered with [AutoHotkey_L utility](http://l.autohotkey.net/)
