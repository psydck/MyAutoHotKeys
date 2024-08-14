; ----------------------------------------------------------------------------------------------
; Programming Project Initial Creation Automationed Script [files & folders]
; created 11/08/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; ----------------------------------------------------------------------------------------------

START_FOLDER := "D:\Development"    ; you may change this, to a folder you like

; Common files
get_docker_ignore(){ 
    return ".dockerignore" 
}
get_git_ignore(){ 
    return ".gitignore" 
}

; Termanal Colors
get_red_color(){ 
    return "\033[0;31m" 
}
get_green_color(){ 
    return "\033[1;32m" 
}
get_yellow_color(){ 
    return "\033[1;33m" 
}
get_cyan_color(){ 
    return  "\033[0;36m"
}
get_magenta_color(){ 
    return "\033[0;35m"
}
get_reset_color(){ 
    return "\033[0m"
}