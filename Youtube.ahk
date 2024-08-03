; -------------------------------------------
; Youtube: YT-Dl
; version 2.1
; created 03/08/2024
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; AHK Version 1.1.37.02
; -------------------------------------------

#SingleInstance, Force

#IfWinActive, ahk_exe msedge.exe

!a:: Download("K:\Videos\NewDownloads\Audio\", "-x --audio-quality 0 --audio-format mp3")

!f:: Download("K:\Videos\NewDownloads\", "-f best")

!v:: Download("K:\Videos\NewDownloads\Video\", "")

Download(start_path, command_args){

    if not InStr( (url := Clipboard) , "youtube.com") {
        MsgBox, 0, Warning, Invalid Youtube link `n %url%, 30
        return
    }

    FileSelectFolder, path, %start_path%, 1, Select Download Folder
    if (ErrorLevel = 1)
        MsgBox, 0, Status, File download was canceled! `n %url%, 30
    else {
        run, yt-dl.exe %command_args% -P "%path%" --console-title "%url%", , Hide
        AppendDownloadHistoryFile(start_path "history.csv", path "," url)
    }

}

AppendDownloadHistoryFile(history_file, content) {
    FileAppend, %content%`n, %history_file%
}