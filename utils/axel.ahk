#include .\os.ahk 

; #D

Download(url, download_path, connections){
    execute := "axel.exe " connections download_path " """ url """ "
    Run, %execute%, , Hide
    ShowSplash("Axel Downloader", "Please, wait for File download to complete!", 500, 150, 1150, 700, 500)
}

; #G

GetDownloadPath(start_path, url){
    title := "Axel Downloader"
    download_path := GetFolder(title, start_path)
    InputBox, Filename, %title%, Provide a Filename,, 600, 150,,,,,
    CreateFile((path := GetPath(download_path, Filename)))
    SetZoneIdentifierStreamInfo(path, url)
    return " --output " path  ; -o f : Specify local output file
}

GetMaximumConnections(defualt_connections){
    title := "Axel Downloader"
    Prompt := "Specify maximum number of connections; Minimum 1 to Maximum 128 Dowload threads "
    InputBox, Connections , %title%, %Prompt%, , 500, 150, , , , , %defualt_connections%
    if (ErrorLevel = 1 or ErrorLevel = 2) {
        message := "Status: Canceled`nInfo: File Not Downloaded"
        ShowSplash("Axel Downloader", message, 500, 150, 1150, 700, 12000)
        return 0
    }

    if (Connections <= 0 or Connections > 128){
        Connections := 128
    } 

    return" -an " Connections " " ; -n x : Specify maximum number of connections
}

