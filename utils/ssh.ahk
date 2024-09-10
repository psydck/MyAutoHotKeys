SshFolder(AppTitle, start_path){
    Prompt := AppTitle " | Provide an Output Folder"
    FileSelectFolder, output_folder, %start_path%, 1, %Prompt%
    if (ErrorLevel = 1) {
        ExitApp
    }
    return output_folder
}

SshKeyFile(AppTitle, output_folder){
    output_path := ""
    Loop {
        InputBox, output_keyfile, %AppTitle%, Provide an Output Key File name, , 250, 150, , , , , id_rsa 
        if (ErrorLevel){
            ExitApp
        }

        ; check if output_keyfile exists ; prompt to change it if it does.
        output_path := output_folder "\" output_keyfile
        IfNotExist %output_path%
           break
        MsgBox, 4, %AppTitle%, output_path " file exists!`n`nDo you want to provide a new one instead?"
        IfMsgBox No
            ExitApp
    }
    return output_path
}

SshEncryptionLevel(AppTitle){
    Prompt := "Provide an Encryption Level `n" 
    encryption_types := [ "dsa", "ecdsa", "ecdsa-sk", "ed25519", "ed25519-sk", "rsa" ]
    For index, encryption_type in encryption_types
        Prompt .= "`n" index ". " encryption_type
    InputBox, encryption_index, %AppTitle%, %Prompt%, , 250, 215, , , , ,6
    if (ErrorLevel) {
        ExitApp
    }
    return encryption_types[encryption_index]
}

SshPassphrase(AppTitle){
    InputBox, new_passphrase, %AppTitle%, Provide a Passphrase, Hide, 250, 150, , , , , 
    if (ErrorLevel) {
        ExitApp
    }
    return new_passphrase
}

ContinueWithSshKeyGen(AppTitle, output_path, encryption_type){
    warning := "Process of Generating " encryption_type " ssh key; to " output_path " file is about to start...`n`n`tWould you like to continue?"
    MsgBox, 4, %AppTitle%, %warning%, 
    IfMsgBox No
        ExitApp
}

ShowExecutionResult(AppTitle, outcome){
    message := ""
    if (StrLen(outcome) = 0)
        message := "Proccess Failed!"
    else
        message := "Proccess was successful.`n`nResults:`n`n" outcome
    MsgBox, 0, %AppTitle%, %message%
}
