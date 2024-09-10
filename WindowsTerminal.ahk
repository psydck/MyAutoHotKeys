<<<<<<< HEAD
; ----------------------------------------------------------------------------------------------
; Windows Terminal Powershell Automation Script [AHK]
; created 08/08/2024 (version 2024.08.10)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

#IfWinActive ahk_exe WindowsTerminal.exe

#space:: 
send, ls {Enter}
=======
; -------------------------------------------
; Windows Terminal
; version 1.0
; created 30/07/2024
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; AHK Version 1.1.37.02
; -------------------------------------------

#SingleInstance Force
SendMode Input

#IfWinActive, ahk_exe WindowsTerminal.exe

#space::
send, ls {enter}
Sleep, 30
>>>>>>> 3670bb4 (initial commit, v2.1)
return


!z::
<<<<<<< HEAD
InputBox, prompt, Manual Helper, Get-Help ? | less , , 171, 130, , , , 10, %prompt%
if (ErrorLevel = 1 or ErrorLevel = 2 or prompt = "") 
	return
else 
	send, man %prompt% | less {Enter}
return

=======
InputBox, command, Powershell Help, Get-Help ? | less, , 250, 108, , , , 30, 
if ( ErrorLevel = 1 or ErrorLevel = 2 or command = "")
    return
else
    send, get-help %command% | less {enter}
    Sleep, 30
return


!x::
InputBox, command, Powershell Help Examples, Get-Help ? -examples | less, , 250, 108, , , , 30, 
if ( ErrorLevel = 1 or ErrorLevel = 2 or command = "")
    return
else
    send, get-help %command% -examples | less {enter}
    Sleep, 30
return
<<<<<<< HEAD
>>>>>>> 3670bb4 (initial commit, v2.1)
=======
>>>>>>> 2e8b146 (resolved conflicfs)
