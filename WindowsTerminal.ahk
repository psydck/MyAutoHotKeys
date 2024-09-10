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
return


!z::
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

