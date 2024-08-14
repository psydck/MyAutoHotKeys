; ----------------------------------------------------------------------------------------------
; Programming Project Initial Creation Automationed Script [utils]
; created 11/08/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

#include .\constants\dev.ahk


; #A

AddDefualtRequirements(project_folder, requirements_file){
    requirements_path := project_folder "\" requirements_file
    
    terminal_packages := ["rich"]
    test_packages := ["pytest", "allure-pytest" ,"behave", "allure-behave"]
    game_pacakage := ["pygame"]
    web_package := ["selenium", "playwright", "requests", "beautifulsoup4"]
    document_packages := ["pypdf", "excel"]
    data_science_packages := ["numpy", "pandas", "matplotlib", "tensorflow", "pytorch", "scikit-learn", "keras", "seaborn", "plotly", "nltk", "gensim", "spacy", "scipy", "theano", "pybrain", "bokeh", "hebel"]
    
    defualt_helpful_requirements := [terminal_packages, test_packages, game_pacakage, web_package, document_packages, data_science_packages]
    defualt_helpful_requirements_category := ["Terminal", "Test", "Game", "Web", "Document", "Data"]

    added_packages := ""
    For index, requirements in defualt_helpful_requirements {
        
        requirement_category := defualt_helpful_requirements_category[index]
        category := requirement_category " Packages"

        category_requirements := ""
        For Index, requirement in requirements { 
            category_requirements .= Index . ". " . requirement . "`n" 
            category_requirements := Trim(category_requirements, " ")
        }
        category_requirements := Trim(category_requirements, "`n")
        
        MsgBox, 4, %category%, Do you, want to add the following requirements, individually? `n%category_requirements%`n`n`nAddedd Requirements:`n%added_packages% 
        IfMsgBox Yes
        {
            
            For _, requirement in requirements {

                MsgBox, 4, %category%, Do you, want to add this requirement "%requirement%" ? `n`nAddedd Requirements:`n%added_packages% 
                IfMsgBox Yes
                {
                    added_packages .= requirement . "`n"
                    FileAppend, %requirement% `n, %requirements_path% 
                }

            }
        }
    }
    return added_packages
}

AppendMakeComment(comment, makefile_path){
    if (StrLen(comment) > 0) {
        comment := "# " comment "`n"
        FileAppend, %comment%, %makefile_path% 
    }
}

AppendMakeShortcut(shortcut, echo_title, title_color, commands, makefile_path){

    ; shortcut append
    shortcut := shortcut ":`n"
    FileAppend, %shortcut%, %makefile_path% 
    
    ; echo title append
    if (StrLen(echo_title) > 0) {
        title := "`t@echo -e ""\n------------- " title_color " " echo_title " " get_reset_color() " -------------\n"" `n"
        FileAppend, %title% , %makefile_path%
    }

    ; commands append
    For _, command in commands {
        command := "`t@" command "`n"
        FileAppend, %command%, %makefile_path% 
    }
    
    newline := "`n"
    FileAppend, %newline%, %makefile_path% 
}

AddRequirements(project_folder, requirements_file, added_packages){ 
    requirements_path := project_folder "\" requirements_file
    requirements_added := ""
    Loop {
        InputBox, requirement , Python Requirement, Add a requirement `n`nAddedd Requirements:`n%added_packages% , , , , , , , , %requirements_added%
        if (ErrorLevel = 1){
            break
        } 
        else {
            MsgBox, 4, Python Requirement, Add this "%requirement%" ? `n`nAddedd Requirements:`n%added_packages% 
            IfMsgBox Yes
            {
                added_packages .= requirement . "`n"
                FileAppend, %requirement% `n, %requirements_path% 
            }
        }
    }
}

; #C

CreateCommonFile(project_folder, file){
    file_path := project_folder "\" file
    FileAppend, , %file_path% 
}

; #G

GetAvailableUnsedUserDefinedPort(){
    while true {
        
        Random, getAvailableUnsedUserDefinedPort, 1024, 4951 
    
        queryPortUsage = "netstat -an | findstr ""%getAvailableUnsedUserDefinedPort%"" ""
    
        ; Execute queryPortUsage command via cmd.exe
        shell := ComObjCreate("WScript.Shell")
        exec := shell.Exec(ComSpec " /C " queryPortUsage)
    
        ; Read 
        output = exec.StdOut.ReadAll()
    
        isPortAvailable := StrLen(output) > 0

        if (isPortAvailable) {
            return getAvailableUnsedUserDefinedPort
        }
        
    }
}

; #I

IgnoreFile(ignore_file_or_folder, project_folder, ignore_file){
    ignore_file_path := project_folder "\" ignore_file 
    FileAppend, %ignore_file_or_folder% `n, %ignore_file_path% 
}

InstallRequirements(project_folder, requirements_file, virtualenv_folder){
    virtualenv_path := ".\" virtualenv_folder
    requirements_path := ".\" requirements_file
    
    change_to_project_folder := "cd " project_folder
    activate_virtualenv := virtualenv_path "\Scripts\activate"
    install_requirements := "pip install -r " requirements_path

    RunTempCommandScript(project_folder, [change_to_project_folder, activate_virtualenv, install_requirements])

}

; #R

RunTempCommandScript(project_folder, commands){
    ; create temp installation script
    temp := "temp.ps1"
    temp_path := project_folder "\" temp

    For _, command in commands {
        FileAppend, %command% `n, %temp_path% 
    }
    
    ; execute temp installation script
    RunWait, powershell.exe %temp_path% , , Hide

    ; delete temp installation script
    FileDelete, %temp_path%
}

; #S

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

    command := "`nEXPOSE " GetAvailableUnsedUserDefinedPort() " `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nCMD [ ""python"", """ python_start_file """ ] `n"
    FileAppend, %command%, %dockerfile_path% 


    IgnoreFile(get_docker_ignore(), project_folder, get_docker_ignore())
    IgnoreFile(dockerfile, project_folder, get_docker_ignore())
}

SetupGit(project_folder){
    git_path := project_folder "\"
    
    ; commands
    change_to_project_folder := "cd " project_folder
    initialize_git := "git init . "
    RunTempCommandScript(project_folder, [change_to_project_folder, initialize_git])
}

GitCommitInitialState(project_folder){
    git_path := project_folder "\"
    
    IgnoreFile("temp.ps1", project_folder, get_git_ignore())

    ; commands
    change_to_project_folder := "cd " project_folder
    stage_files := "git add ."
    commit := "git commit -m ""Initail Python Project Setup Commit"" "
    create_dev_branch := "git branch Dev"
    create_test_branch := "git branch Test"
    create_build_branch := "git branch Build"
    RunTempCommandScript(project_folder, [change_to_project_folder, initialize_git, stage_files, commit, create_dev_branch, create_test_branch, create_build_branch])
}

SetupMake(project_folder, makefile, python_start_file, requirements_file, virtualenv_folder){
    makefile_path := project_folder "\" makefile

    ; activate virtual environment
    AppendMakeComment("Virtual Environment", makefile_path)
    AppendMakeShortcut("activate", "", "", ["powershell.exe .\" virtualenv_folder "\Scripts\activate.bat"], makefile_path)
    
    ; git
    AppendMakeComment("Git", makefile_path)
    AppendMakeShortcut("add", "Staged", get_cyan_color(), ["git add $(file)", "git status"], makefile_path)
    AppendMakeShortcut("commit", "Committed", get_green_color(), ["git commit -m ""$(message)"" ",  "git status"], makefile_path)
    AppendMakeShortcut("unstage", "Unstage", get_red_color(), ["git restore --staged $(files)"], makefile_path)
    AppendMakeShortcut("status", "Status", get_yellow_color(), ["git status"], makefile_path)
    AppendMakeShortcut("branch", "Branches", get_yellow_color(), ["git branch"], makefile_path)
    AppendMakeShortcut("switch", "Switching Branch", get_yellow_color(), ["git branch $(branch)"], makefile_path)
    
    ; requirements
    AppendMakeComment("PIP Packages", makefile_path)
    AppendMakeShortcut("install", "Installing Requirements", get_magenta_color(), ["powershell.exe .\" virtualenv_folder "\Scripts\python -m pip install -r " requirements_file], makefile_path)
    AppendMakeShortcut("freeze", "List of Installed Packages", get_green_color(), ["powershell.exe .\" virtualenv_folder "\Scripts\python -m pip list"], makefile_path)
    AppendMakeShortcut("uninstall", "Uninstalling a Package", get_red_color(), ["powershell.exe .\" virtualenv_folder "\Scripts\python -m pip uninstall $(package)"], makefile_path)

    ; python
    AppendMakeComment("Python", makefile_path)
    AppendMakeShortcut("run", "", "", ["powershell.exe .\" virtualenv_folder "\Scripts\python " python_start_file], makefile_path)
    AppendMakeShortcut("test", "", "", ["powershell.exe .\" virtualenv_folder "\Scripts\python -m pytest"], makefile_path)
   
    ; docker
    AppendMakeComment("Docker", makefile_path)
    data := StrSplit(project_folder, "\")
    project_name := data[data.Length()]
    StringReplace, project_name, project_name, %A_Space%, _ , All
    StringLower, image, project_name

    AppendMakeShortcut("image", "Building Docker Image",  get_green_color(), ["docker build . -t " image ], makefile_path)
    AppendMakeShortcut("container", "Creating Docker Container",  get_cyan_color(), ["docker run -d -p 8080:APP_PORT -name app " image], makefile_path)
    AppendMakeShortcut("start_container", "Starting Container", get_green_color(), ["docker container start app"], makefile_path)
    AppendMakeShortcut("stop_container", "Stopping Container", get_red_color(), ["docker container stop app"], makefile_path)
    AppendMakeShortcut("save_image", "Saving Image to zip File", get_magenta_color(), ["docker save -o " image "_docker_image.zip " image ], makefile_path)

}

SetupRequirements(project_folder, requirements_file, virtualenv_folder){
    added_packages := AddDefualtRequirements(project_folder, requirements_file)
    AddRequirements(project_folder, requirements_file, added_packages)
    InstallRequirements(project_folder, requirements_file, virtualenv_folder)
}

SetupVirtualEnvironment(project_folder, virtualenv_folder){
    virtualenv_folder_path := project_folder "\" virtualenv_folder
    RunWait, powershell.exe $(python -m virtualenv %virtualenv_folder_path% -p 3.12), , Hide
    
    IgnoreFile(virtualenv_folder . "\", project_folder, get_git_ignore())
    IgnoreFile(virtualenv_folder . "\", project_folder, get_docker_ignore())
}