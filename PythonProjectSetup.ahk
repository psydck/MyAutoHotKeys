; ----------------------------------------------------------------------------------------------
; Programming Project Initial Creation Automationed Script  [AHK]
; created 11/08/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------
#include .\constants\dev.ahk
#include .\utils\programming_development.ahk


#SingleInstance Force
SendMode Input

#IfWinActive, ahk_exe WindowsTerminal.exe


::.cpy:: ; Create Python Project

    ; prompt user for python project folder
    FileSelectFolder, project_folder, %START_FOLDER%, 1, Setup Python Project Folder

    if (ErrorLevel = 1 or ErrorLevel = 2) {
        return
    }

    ; setup git
    SetupGit(project_folder)
    
    ; setup virtual environment
    SetupVirtualEnvironment(project_folder, (virtualenv_folder := ".venv"))
    
    ; setup requirements
    SetupRequirements(project_folder, (requirements_file := "requirements.txt"), virtualenv_folder)

    ; create python scripts
    CreateCommonFile(project_folder, (python_start_file := "main.py"))
    CreateCommonFile(project_folder, (stash_py_file := "stash.py"))
    IgnoreFile(stash_py_file, project_folder, get_git_ignore())
    IgnoreFile(stash_py_file, project_folder, get_docker_ignore())
    CreateCommonFile(project_folder, "test_main.py")

    ; setup docker
    expose_port := SetupDocker(project_folder, "dockerfile", requirements_file, python_start_file)

    ; setup make
    SetupMake(project_folder, "Makefile", python_start_file, requirements_file, virtualenv_folder, expose_port)

    
    GitCommitInitialState(project_folder)
return

