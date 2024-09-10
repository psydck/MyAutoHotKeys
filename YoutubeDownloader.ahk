; ----------------------------------------------------------------------------------------------
; Youtube File Downloader [AHK]
; created 01/07/2024 (version 2024.08.11)
; By Sizwe I. Mkhonza
; https://www.linkedin.com/in/sir-afrika/
; https://github.com/psydck/MyAutoHotKeys
; AHK Version 1.1.37.02
; yt-dlp (ver. 2024.08.06) : https://github.com/yt-dlp/yt-dlp/releases
; ----------------------------------------------------------------------------------------------

#include .\utils\ytdlp.ahk 
#include .\constants\myYoutubeFolders.ahk ;contains { AUDIO_DIR, MAIN_DIR, VIDEO_DIR } as strings

#SingleInstance, Force

#IfWinActive, ahk_exe msedge.exe


!a:: DownloadAudio(AUDIO_DIR)
!w:: ReDownloadAudioFiles(AUDIO_DIR) 

!f:: DownloadBestAudioOrVideo(MAIN_DIR)

!v:: DownloadVideo(VIDEO_DIR)
!q:: DownloadQualityVideo(VIDEO_DIR)
!r:: ReDownloadVideoFiles(VIDEO_DIR)

