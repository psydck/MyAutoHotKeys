:ro:.wifipass::
    ; prompt the user to provide wifi ssid
    Title :=  "Wifi Password Provider"
    prompt := "Provide Wifi SSID"
    InputBox, wifi_ssid, %Title%, %prompt%, , 200, 125
    
    ; exit if choose to cancel
    if (ErrorLevel){
        return
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
