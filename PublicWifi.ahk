; ----------------------------------------------------------------------------------------------
; Public Wifi Network Automation Script [AHK]
; created 10/09/2024 (version 2024.09.10)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

#Include .\utils\ssh.ahk

#SingleInstance Force

:ro:.wifipass::
    ; prompt the user to provide wifi ssid
    Title :=  "Wifi Password Provider"
    prompt := "Provide Wifi SSID"
    InputBox, wifi_ssid, %Title%, %prompt%, , 200, 125
    
    ; exit if choose to cancel
    if (ErrorLevel){
        ExitApp
    }
    
    ; construct command to fetch wifi password
    find := "Key Content"
    print := "{print $4}"
    command := "netsh wlan show profile name=""" wifi_ssid """ key=clear | grep """ find """ | awk """ print """" 
    
    ; run the command and get the wifi password
    wifi_password := RunWaitOne(command)

    ; prompt the user to either copy to clipboard their password, or display it via the splash screen.
    prompt := "Copy " wifi_ssid " Password to Clipboard? "
    MsgBox, 4,%Title%, %prompt%
    IfMsgBox Yes
        clipboard := wifi_password
    else
        ShowSplash(wifi_ssid " Password is ",  wifi_password, 9000)
return

:ro:.wifiinfo::
    Title :=  "Wifi Info Provider"

    ; construct command to fetch wifi info
    command := "netsh wlan show interface" 

    ; run the command and get the wifi info
    wifi_info := RunWaitOne(command)

    ; prompt the user to either copy the information to their clipboard, or display it via the splash screen.
    prompt := "Copy Info to Clipboard? "
    MsgBox, 4,%Title%, %prompt%
    IfMsgBox Yes
        clipboard := wifi_info
    else
        ShowSplash(Title, wifi_info, 9000)
return

:ro:.sshkeygen::
    Title := "SSH Key Generator"
    ContinueWithSshKeyGen(Title, (output_path := SshKeyFile(Title, SshFolder(Title, "C:\"))), (encryption_type := SshEncryptionLevel(Title)))
    ShowExecutionResult(Title, RunWaitOne("ssh-keygen -t " encryption_type " -f """ output_path """ -N " (new_passphrase := SshPassphrase(Title))))
return

:ro:.sshcopyid::
    ; download sshpass from https://github.com/xhcoding/sshpass-win32/releases/tag/v1.0.1
    target_server_passpharse := SshTargetKey((Title := "Copy the SSH Key to the Server"), "C:\")
    command := "sshpass.exe -f """ target_server_passpharse """ ssh-copy-id -i """ SshPublicKey(Title, "C:\") """ """ SshTargetServer(Title) """ "
    ShowExecutionResult(Title, RunWaitOne(command))
return

:ro:.scp::
    Title := "SCP | secure copy"
    source_opt := ""
    source := ""
    Loop {
        Prompt := "Provide a source?`nOptions:`n1. File, or`n2. Folder"
        InputBox, source_opt, %Title%, %Prompt%, , 250, 250, , , , , 2 
        source := ""
        if (ErrorLevel) {
            ExitApp
        } else if (source_opt = 1) {
            source_opt := ""
            start_folder := "C:\"
            Prompt := "Select a source file"
            FileSelectFile, source, 3, %start_folder%, %Prompt%
            if (ErrorLevel = 1) {
                ExitApp
            } else {
                break
            }
        } else if (source_opt = 2) {
            source_opt := " -r "
            start_folder := "C:\"
            Prompt := "Select a source folder"
            FileSelectFolder, source, %start_path%, 1, %Prompt%
            if (ErrorLevel = 1) {
                ExitApp
            } else {
                break
            }
        } else {
            continue
        }
    }
    
    destination := ""
    Loop {
        Prompt := "Provide a destination address?"
        InputBox, destination, %Title%, %Prompt%, , 250, 150, , , , ,
        if (ErrorLevel) {
            ExitApp
        } else if(StrLen(destination) = 0){
            continue
        } else {
            break
        }
    }
    
    Prompt := "Provide a destination passphrase?`Options:`n1. passphrase`n2. passphrase file"
    InputBox, passphrase_opt, %Title%, %Prompt%, , 250, 250, , , , ,
    passphrase := ""
    if (ErrorLevel) {
        ExitApp
    } else if(passphrase_opt = 1) {
        passphrase_opt := "-p "
        Prompt := "Provide a passphrase"
        InputBox, passphrase, %Title%, %Prompt%, Hide, 250, 150, , , , ,
        if (StrLen(passphrase) = 0) {
            ExitApp 
        }
    } else if(passphrase_opt = 2) {
        passphrase_opt := "-f "
        start_folder := "C:\"
        Prompt := "Provide a passphrase file"
        FileSelectFile, passphrase, 3, %start_folder%, %Prompt%
        if (ErrorLevel = 1) {
            ExitApp
        }
    } else {
        ExitApp
    }

    results := RunWaitOne("sshpass " passphrase_opt " " passphrase " scp -Cp " source_opt " """ source """ " destination )
    MsgBox, 0, Scp, Results:`n%results%
return

RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}

ShowSplash(title, message, timeout){
    SplashTextOn, 700, 100, %title%, %message%
    WinMove, %title%, , 1175, 910
    Sleep timeout
    SplashTextOff
}

