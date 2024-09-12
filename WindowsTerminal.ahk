; ----------------------------------------------------------------------------------------------
; Windows Terminal Powershell Automation Script [AHK]
; created 08/08/2024 (version 2024.08.10)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; -------------------------------------------

#IfWinActive ahk_exe WindowsTerminal.exe

#space:: 
send, ls {Enter}
return


!z::
InputBox, prompt, Manual Helper, Get-Help ? | less , , 171, 130, , , , 10, %prompt%
if (ErrorLevel = 1 or ErrorLevel = 2 or prompt = "") 
	return
else 
	send, man %prompt% | less {Enter}
return
