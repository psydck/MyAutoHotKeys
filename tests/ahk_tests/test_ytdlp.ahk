#include .\utils\ytdlp.ahk  

BuildHistoryFile(test_path){
    FormatTime, date, , yyyy-MM-dd
    FormatTime, time, ,HH:mm:ss
    test_content := test_path "," date "," time
    ; subject under test
    AppendDownloadHistoryFile(test_path, test_content)

    return test_content
}

:ro:.test_file::
    test_path := ".\test_data_stash\history.csv"
    
    IfExist %test_path%
        FileDelete, %test_path%

    BuildHistoryFile(test_path)

    ; testing
    IfNotExist %test_path%
        MsgBox, 0, Test History File, Failed: test file not created, 100
    else
        MsgBox, 0, Test History File, Pass, 100

    FileDelete, %test_path%
return

:ro:.test_content::
    test_path := ".\test_data_stash\history.csv"

    IfExist %test_path%
        FileDelete, %test_path%

    test_content := BuildHistoryFile(test_path)
    
    ; testing
    FileReadLine, content, %test_path%, 1
    if (StrLen(content) = 0) 
        MsgBox, 0, Test History File Content, Failed: no content, 100
    else if (content = test_content)
        MsgBox, 0, Test History File Content, Pass, 100
    else
        MsgBox, 0,Test History File Content, Failed: test_content dont match, 100

    FileDelete, %test_path%
return

:ro:.test_append::
    test_path := ".\test_data_stash\history.csv"

    IfExist %test_path%
        FileDelete, %test_path%

    BuildHistoryFile(test_path)

    FileReadLine, content, %test_path%, 1
    StringSplit, lastline, content,`n, 
    if (StrLen(lastline) = 0) 
        MsgBox, 0, Test History File Append, Pass, 100
    else
        MsgBox, 0,Test History File Append, Failed -> line 2 = %lastline%, 100

    FileDelete, %test_path%
return