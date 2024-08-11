#include .\messaging.ahk 

GetPath(folder, file){
    return  """"folder "\" file """"
}

GetFolder(title, start_path){
    prompt := title " | Select output folder "
    FileSelectFolder, path, %start_path%, 1, %prompt%
    if (ErrorLevel = 1) {
        message := "Status: Canceled`nInfo: File Not Specified!"
        ShowSplash(title, message, 500, 150, 1150, 700, 12000)
        return 0
    }
    return path
}

CreateFile(path){
    command := "powershell.exe touch " path 
    Run, %command%, , Hide
}

SetZoneIdentifierStreamInfo(path, content){
    command := "powershell.exe Set-Content -Path " path " -Stream Zone.Identifier -Value """ content """ "
    Run, %command%, , Hide
}