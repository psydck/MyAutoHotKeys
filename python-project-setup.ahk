; -----------------------------------------------------------------------
; Python Initial Project Creation Automation  [AHK]
; created 11/08/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; -----------------------------------------------------------------------

#SingleInstance Force
SendMode Input

#IfWinActive, ahk_exe WindowsTerminal.exe


start_folder := "D:\Development"


::.cpy:: ; Create Python Project

    ; prompt user for python project folder
    FileSelectFolder, project_folder, %start_folder%, 1, Setup Python Project Folder

    if (ErrorLevel = 1 or ErrorLevel = 2) {
        return
    }

    ; setup git
    SetupGit(project_folder)
    CreateCommonFile(project_folder, ".gitignore")
    
    ; setup virtual environment
    virtualenv_folder := ".venv"
    SetupVirtualEnvironment(project_folder, virtualenv_folder)
    IgnoreFile(virtualenv_folder "\", project_folder, ".gitignore")
    IgnoreFile(virtualenv_folder "\", project_folder, ".dockerignore")

    ; add requirements
    requirements_file := "requirements.txt"
    CreateCommonFile(project_folder, requirements_file)
    AddRequirements(project_folder, requirements_file)
    InstallRequirements(project_folder, requirements_file, virtualenv_folder)

    ; create main python script file
    python_start_file := "main.py"
    CreateCommonFile(project_folder, python_start_file)
    CreateCommonFile(project_folder, "test_main.py")

    ; setup make
    SetupMake(project_folder, "Makefile", python_start_file, requirements_file)

    ; setup docker
    dockerfile := "dockerfile"
    SetupDocker(project_folder, dockerfile, requirements_file, python_start_file)
    IgnoreFile(".dockerignore", project_folder, ".dockerignore")
    IgnoreFile(dockerfile, project_folder, ".dockerignore")

return

SetupGit(project_folder){
    git_path := project_folder "\"
    RunWait, powershell.exe $(git init %git_path%), , Hide
}

SetupVirtualEnvironment(project_folder, virtualenv_folder){
    virtualenv_folder_path := project_folder "\" virtualenv_folder
    RunWait, powershell.exe $(python -m virtualenv %virtualenv_folder_path% -p 3.12), , Hide
}

IgnoreFile(ignore_file_or_folder, project_folder, ignore_file){
    ignore_file_path := project_folder "\" ignore_file 
    FileAppend, %ignore_file_or_folder% `n, %ignore_file_path% 
}

CreateCommonFile(project_folder, file){
    file_path := project_folder "\" file
    FileAppend, , %file_path% 
}

AddRequirements(project_folder, requirements_file){
    requirements_path := project_folder "\" requirements_file
    requirements_added := ""
    Loop {
        InputBox, requirement , Python Requirement, Add a requirement `n %requirement%, , , , , , , , %requirements_added%
        if (ErrorLevel = 1){
            break
        } 
        else {
            MsgBox, 4, Python Requirement, Add this requirement? `n %requirement%, 
            IfMsgBox Yes
            {
                FileAppend, %requirement% `n, %requirements_path% 
                requirements_added := requirements_added "`n" requirement
            }
        }
    }
}

InstallRequirements(project_folder, requirements_file, virtualenv_folder){
    virtualenv_path := ".\" virtualenv_folder
    requirements_path := ".\" requirements_file
    
    change_to_project_folder := "cd " project_folder
    activate_virtualenv := virtualenv_path "\Scripts\activate"
    install_requirements := "pip install -r " requirements_path

    ; create temp installation script
    temp := "temp.ps1"
    temp_path := project_folder "\" temp
    FileAppend, %change_to_project_folder% `n, %temp_path% 
    FileAppend, %activate_virtualenv% `n, %temp_path% 
    FileAppend, %install_requirements% `n, %temp_path% 

    ; execute temp installation script
    RunWait, powershell.exe %temp_path% , , Hide

    ; delete temp installation script
    FileDelete, %temp_path%
}

SetupDocker(project_folder, dockerfile, requirements_file, python_start_file){
    dockerfile_path := project_folder "\" dockerfile
    
    desc:= "FROM python:3:12-slim`n"
    FileAppend, %desc%, %dockerfile_path% 

    command := "`nWORKDIR /app `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nCOPY . . `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nRUN pip install -r " requirements_file " `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nEXPOSE APP_PORT `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nCMD [ ""python"", """ python_start_file """ ] `n"
    FileAppend, %command%, %dockerfile_path% 

}

SetupMake(project_folder, makefile, python_start_file, requirements_file){
    makefile_path := project_folder "\" makefile

    ; install requirements
    desc:= "install:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@python -m pip install -r " requirements_file "`n`n"
    FileAppend, %command%, %makefile_path% 

    ; show installed requirements
    desc:= "show_pip:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@python -m pip list `n`n"
    FileAppend, %command%, %makefile_path% 

    ; python run
    desc:= "run:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@python " python_start_file "`n`n"
    FileAppend, %command%, %makefile_path% 

    ; tests
    desc:= "test:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@pytest `n`n"
    FileAppend, %command%, %makefile_path% 

    ; docker
    data := StrSplit(project_folder, "\")
    project_name := data[data.Length()]
    StringReplace, project_name, project_name, %A_Space%, _ , All
    StringLower, image, project_name

    desc:= "build:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@docker build . -t " image " `n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "container:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@docker run -d -p 8080:APP_PORT -name app " image "`n`n"
    FileAppend, %command%, %makefile_path% 
    
    desc:= "start_container:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@docker container start app `n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "stop_container:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@docker container stop app `n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "save_image:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@docker save -o " image "_docker_image.zip " image "`n`n"
    FileAppend, %command%, %makefile_path% 

}
