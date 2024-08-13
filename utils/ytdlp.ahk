; ----------------------------------------------------------------------------------------------
; Youtube File Downloader [utils]
; created 01/07/2024 (version 2024.08.11) 
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; yt-dlp (ver. 2024.08.06) : https://github.com/yt-dlp/yt-dlp/releases
; ----------------------------------------------------------------------------------------------

HISTORY_FILE := "history.csv"

; #A

AppendDownloadHistoryFile(history_file_path, content) { 
    FileAppend, %content%`n, %history_file_path%
}

; #D

Download(start_path, command_args) {

    url := Trim(Clipboard)

    containsYoutube := InStr( url , "youtube.com")
    containsYoutu := InStr( url , "youtu.be")

    isUrlValid := containsYoutube or containsYoutu

    if ( not isUrlValid ){
        SplashTextOn, 700, 100, Youtube Downloader, Status: Warning`nInfo: Invalid Youtube link `nUrl: %url%
        Sleep 12000
        SplashTextOff
        return
    }

    FileSelectFolder, path, %start_path%, 1, Select Download Folder
    if (ErrorLevel = 1) {
        SplashTextOn, 700, 100, Youtube Downloader, Status: Canceled`nInfo: File Not Downloaded`nURL: %url%
        Sleep 12000
        SplashTextOff    
    }
    else {
    
        SplashTextOn, 700, 100, Youtube Downloader, Status: Inprogress`nInfo: File downloading...`nURL: %url%
        Sleep 15000
        SplashTextOff

        run, yt-dlp.exe %command_args% -P "%path%" --console-title "%url%", , Hide
        
        FormatTime, date, , yyyy-MM-dd
        FormatTime, time, ,HH:mm:ss
        
        data := path "," url "," date "," time
        history_file_path := start_path HISTORY_FILE

        AppendDownloadHistoryFile(history_file_path, data)

        SplashTextOn, 700, 100,  Youtube Downloader, Status: Success`nInfo: Await file to download completely`nURL: %url%
        Sleep 15000
        SplashTextOff

    }

}

DownloadAudio(start_path){
    command_args := "-x --audio-quality 0 --audio-format mp3"
    Download(start_path, command_args)
}

DownloadBestAudioOrVideo(start_path){
    command_args := "-f best"
    Download(start_path, command_args)
}

DownloadByFilter(url, folder, file, command_args){
    containsYoutube := InStr(original_url, "youtube.com")
    filter := containsYoutube ? "youtube.com/watch?v=" : "youtu.be/" ,
    video_id := StrSplit(url , filter)
    if InStr(file , video_id[2]){
       value := DownloadUrl(folder, url, command_args)
       return value
    }
    else {
        return 0
    }
}

DownloadQualityVideo(video_start_path){
    url := Trim(Clipboard)

    containsYoutube := InStr( url , "youtube.com")
    containsYoutu := InStr( url , "youtu.be")
    isUrlValid := containsYoutube or containsYoutu

    if ( not isUrlValid ){
        SplashTextOn, 700, 100, Youtube Downloader, Status: Warning`nInfo: Invalid Youtube link `nUrl: %url%
        Sleep 12000
        SplashTextOff
        return
    }

    Prompt := RunWaitOne("yt-dlp.exe -F " url)
    
    InputBox, audio , Select Audio ID, %Prompt%, , 841, 600, , , , , 
    if (ErrorLevel = 1 or ErrorLevel = 2) {
        return
    }

    InputBox, video, Select Video ID, %Prompt%, , 841, 600, , , , , 
    if (ErrorLevel = 1 or ErrorLevel = 2) {
        return
    }

    Download(video_start_path,  "-f """ audio "+" video """ --merge-output-format mp4")
}

DownloadUrl(path, url, command_args) {

    containsYoutube := InStr( url , "youtube.com")
    containsYoutu := InStr( url , "youtu.be")

    isUrlValid := containsYoutube or containsYoutu

    if ( not isUrlValid ){
        return 0
    }

    run, yt-dlp.exe %command_args% -P "%path%" --console-title "%url%", , Hide
    return 1
}

DownloadVideo(start_path){
    command_args := ""
    Download(start_path, command_args)
}

; #R

ReDownloadAudioFiles(start_path) {
    command_args := "-x --audio-quality 0 --audio-format mp3"
    ReDownloadParts(start_path, command_args)
}

ReDownloadParts(start_path, command_args){
   
    MsgBox, 4, Youtube Downloader, Redownload Parts? 

    IfMsgBox Yes
    {
        history_file_path := start_path HISTORY_FILE

        Loop, read, %history_file_path%
        {
            data := StrSplit(A_LoopReadLine , ",")
            folder := data[1]
            original_url := data[2]

            if not FileExist(folder) {
                return
            }

            Loop Files, %folder%\*.part
            {

                value := DownloadByFilter(original_url, folder, A_LoopFileFullPath, command_args)
                if (value = 0){
                    first := StrSplit( A_LoopFileFullPath, "[")
                    second := StrSplit( first[2], "]")
                    video_id := Trim(second[1])
                    file_url := containsYoutube ? "https://www.youtube.com/watch?v=" video_id : "https://youtu.be/" video_id
                    DownloadUrl(folder, file_url, command_args)
                }
            }
        } 

        SplashTextOn, 700, 100, Youtube Downloader, Status: Success`nInfo: Redownload Parts Operation complete
        Sleep 15000
        SplashTextOff
    }
    Else
    {
        SplashTextOn, 700, 100, Youtube Downloader, Status: Canceled`nInfo: Redownload Parts Operation canceled
        Sleep 12000
        SplashTextOff     
    }
}

ReDownloadVideoFiles(start_path) {
    command_args := ""
    ReDownloadParts(start_path, command_args)
}

RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec "  -WindowStyle Hidden /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}

