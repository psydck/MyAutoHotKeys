; ----------------------------------------------------------------------------------------------
; Axel Multi-stream File Download Automation Script [AHK]
; created 23/08/2024 (version 2024.08.23)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

#IfWinActive, ahk_exe msedge.exe
#include .\constants\myYoutubeFolders.ahk ;contains { AUDIO_DIR, MAIN_DIR, VIDEO_DIR } as strings

!d:: 

    ; Get the copied Url from Clipboard
    url := Trim(Clipboard)

    start_path := MAIN_DIR

    if((download_path := GetDownloadFolder(start_path)) == 0){
        return
    }

    if((connections := GetMaximumConnections(8)) == 0){
        return
    }

    Download(url, download_path, connections)

return

; #D

Download(url, download_path, connections){
    execute := "axel.exe -a " connections download_path url

    ShowSplash("File download started... `n" execute, 5000)
    
    run, axel.exe -a %connections% %download_path% %url%, , Hide

    ShowSplash("Await file download to complete!`nUsing... `n" execute, 15000)
}

; #G

GetDownloadFolder(start_path){
    prompt := "Axel Downloader: Select Download Folder"
    FileSelectFolder, download_path, %start_path%, 1, %prompt%
    if (ErrorLevel = 1) {
        message := "Status: Canceled`nInfo: File Not Downloaded"
        ShowSplash(message, 12000) 
        return 0
    }
    output_file_destination := " -o """ download_path """ "  ; -o f : Specify local output file
    return output_file_destination
}

GetMaximumConnections(defualt_connections){
    Prompt := "Specify maximum number of connections; Minimum 1 to Maximum 64 Dowload threads "
    InputBox, Connections , , %Prompt%, , 500, 600, , , , , %defualt_connections%
    if (ErrorLevel = 1 or ErrorLevel = 2) {
        message := "Status: Canceled`nInfo: File Not Downloaded"
        ShowSplash(message, 12000) 
        return 0
    }
    maximum_number_of_connections := " -n " Connections " " ; -n x : Specify maximum number of connections
    return maximum_number_of_connections
}

; #S

ShowSplash(message, timeout){
    program_title := "Axel Downloader"
    SplashTextOn, 700, 100, %program_title%, %message%
    WinMove, %title%, , 1175, 910
    Sleep timeout
    SplashTextOff
}