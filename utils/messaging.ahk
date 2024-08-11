; #S

ShowSplash(title, message, width, height, x_pos, y_pos, timeout){
    SplashTextOn, width, height, %title%, %message%
    WinMove, %title%, , x_pos, y_pos
    Sleep timeout
    SplashTextOff
}