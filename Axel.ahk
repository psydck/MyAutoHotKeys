; ----------------------------------------------------------------------------------------------
; Axel Multi-stream File Download Automation Script [AHK]
; created 23/08/2024 (version 2024.08.23)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------
#SingleInstance Force

#IfWinActive, ahk_exe msedge.exe
#include .\constants\myYoutubeFolders.ahk ;contains { AUDIO_DIR, MAIN_DIR, VIDEO_DIR } as strings
#include .\utils\axel.ahk

!d:: 

    ; Get the copied Url from Clipboard
    ; Get the output file path

    if((download_path := GetDownloadPath(MAIN_DIR,  (url := Trim(Clipboard)))) == 0){
        ExitApp
    }

    ; Get Maximum Download connections

    if((connections := GetMaximumConnections(64)) == 0){
        ExitApp
    }

    ; Download the file

    Download(url, download_path, connections)

return