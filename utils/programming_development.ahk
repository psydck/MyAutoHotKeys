; ----------------------------------------------------------------------------------------------
; Programming Project Initial Creation Automationed Script [utils]
; created 11/08/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

#include .\constants\devFiles.ahk


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

    command := "`nEXPOSE APP_PORT `n"
    FileAppend, %command%, %dockerfile_path% 

    command := "`nCMD [ ""python"", """ python_start_file """ ] `n"
    FileAppend, %command%, %dockerfile_path% 


    IgnoreFile(DOCKER_IGNORE, project_folder, DOCKER_IGNORE)
    IgnoreFile(dockerfile, project_folder, DOCKER_IGNORE)
}

SetupGit(project_folder){
    git_path := project_folder "\"
    RunWait, powershell.exe $(git init %git_path%), , Hide
}

SetupMake(project_folder, makefile, python_start_file, requirements_file, virtualenv_folder){
    makefile_path := project_folder "\" makefile

    ; activate virtual environment
    desc:= "activate:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\activate.bat`n`n"


    ; git 
    desc:= "add:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@git add $(file)`n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "commit:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@git commit -m ""$(message)""`n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "status:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@git status`n`n"
    FileAppend, %command%, %makefile_path% 

    
    ; requirements
    desc:= "install:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\python -m pip install -r " requirements_file "`n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "showpack:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\python -m pip list `n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "uninstall:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\python -m pip uninstall $(package)`n`n"
    FileAppend, %command%, %makefile_path% 


    ; python
    desc:= "run:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\python " python_start_file "`n`n"
    FileAppend, %command%, %makefile_path% 

    desc:= "test:`n"
    FileAppend, %desc%, %makefile_path% 
    command := "`t@powershell.exe .\" virtualenv_folder "\Scripts\python -m pytest `n`n"
    FileAppend, %command%, %makefile_path% 


    ; docker
    data := StrSplit(project_folder, "\")
    project_name := data[data.Length()]
    StringReplace, project_name, project_name, %A_Space%, _ , All
    StringLower, image, project_name

    desc:= "image:`n"
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

SetupRequirements(project_folder, requirements_file, virtualenv_folder){
    added_packages := AddDefualtRequirements(project_folder, requirements_file)
    AddRequirements(project_folder, requirements_file, added_packages)
    InstallRequirements(project_folder, requirements_file, virtualenv_folder)
}

SetupVirtualEnvironment(project_folder, virtualenv_folder){
    virtualenv_folder_path := project_folder "\" virtualenv_folder
    RunWait, powershell.exe $(python -m virtualenv %virtualenv_folder_path% -p 3.12), , Hide
    
    IgnoreFile(virtualenv_folder "\", project_folder, GIT_IGNORE)
    IgnoreFile(virtualenv_folder "\", project_folder, DOCKER_IGNORE)
}