%@echo off
::- Changelog: (05/12/2024)
::+ 4.5 - added custom episode
::+ 5.0 - added ffprobe and mkvmerge checking
::+ 5.1 - reimplemented vbs playback
::+ 5.2 - added bin folder checking
::+ 5.3 - reduced lines, calls :header instead of printing header mutiple lines
::+ 5.4 - colorized current show being processed
::+ 5.5 - add auto download dependencies
::+ 5.6-7 - add auto extract
::+ 5.8 - add auto 7zip detection & download
::+ 5.9 - improvements
::+ 6.0 - batch script final ver
::+ 6.1 - fixes
::+ 6.2-4 - fixed 7zip detection and fixes
::+ 6.5 - removed subtitle watermark (cc: @lionavila)
::+ 6.6-8 - added custom font for attatching via subtitles, custom and current dir font
::+ 6.9 - fixed custom font and cd custom font detection
::+ 7.0 - added custom subtitle track tag, added secret font dl menu, improved code readability and organization, added script source custom font
::+ 7.1 - made detection of special episodes toggleable, add toggle to main menu

:: Check play sound .vbs if exists else creates
if not exist "%~dp0mkvmerge_script-play.vbs" (
  echo Dim oPlayer > "%~dp0mkvmerge_script-play.vbs"
  echo Set oPlayer = CreateObject("WMPlayer.OCX"^) >> "%~dp0mkvmerge_script-play.vbs"
  echo. >> "%~dp0mkvmerge_script-play.vbs"
  echo ' Play audio >> "%~dp0mkvmerge_script-play.vbs"
  echo oPlayer.URL = "C:\Windows\Media\Windows Notify Calendar.wav" >> "%~dp0mkvmerge_script-play.vbs"
  echo oPlayer.controls.play >> "%~dp0mkvmerge_script-play.vbs"
  echo While oPlayer.playState ^<^> 1 ' 1 = Stopped >> "%~dp0mkvmerge_script-play.vbs"
  echo WScript.Sleep 100 >> "%~dp0mkvmerge_script-play.vbs"
  echo Wend >> "%~dp0mkvmerge_script-play.vbs"
  echo. >> "%~dp0mkvmerge_script-play.vbs"
  echo ' Release the audio file >> "%~dp0mkvmerge_script-play.vbs"
  echo oPlayer.close >> "%~dp0mkvmerge_script-play.vbs"
)

:: Checks if bin folder exists else creates
if not exist "%~dp0bin\" (
  md bin
)

:: Initialization of variables and checking of files
:init
:: Enable rendering of ASCII symbols
chcp 65001 >NUL

:: Variables Block
set ver=v7.0
:: Define ASCII Colors
set nhcolor=
set Green=%nhcolor%[32m
set White=%nhcolor%[37m
set Cyan=%nhcolor%[36m

set Magenta=%nhcolor%[35m
set Red=%nhcolor%[31m
set Yellow=%nhcolor%[33m
set Lightgray=%nhcolor%[38m
set Bold=%nhcolor%[1m

:: Actual start of the script
:start
set csr=no
set subname=
set season=S01
set lang=kor
set drama=KDrama
set type=drama
set special=n
set /a count = 0
title mkvmerge_script %ver%  [mkv+ass / %drama%] - %Season%

:: Dependencies variables, url, version, filename
set sz="C:\Program Files\7-Zip\7z.exe"
call :szdl
set "mkvtoolnix_url=https://mkvtoolnix.download/windows/releases/"
set "ffmpeg_url=https://www.gyan.dev/ffmpeg/builds/"
set "mkvtoolnix_version=83.0"
@REM set "ffmpeg_version=6.1"
set "mkvtoolnix_dlurl=%mkvtoolnix_url%%mkvtoolnix_version%/mkvtoolnix-64-bit-%mkvtoolnix_version%.7z"
@REM set "ffmpeg_dlurl=%ffmpeg_url%ffmpeg-%ffmpeg_version%.tar.gz"
set "ffmpeg_dlurl=%ffmpeg_url%ffmpeg-git-essentials.7z"
set "mkvtoolnix-file=mkvtoolnix-64-bit-%mkvtoolnix_version%.7z"
set "ffmpeg-file=ffmpeg-git-essentials.7z"

call :header
set "mkvmerge="
if not exist "%~dp0bin\" (
    mkdir "%~dp0bin"
)
for /f "delims=" %%i in ('dir /s /b /a-d ".\bin\mkvmerge*.exe" 2^>nul') do set "mkvmerge=%%i" & goto :mkvmbreak

:: :mkvmbreak and :ffbreak checks if dependencies exists else auto downloads it
:mkvmbreak
if "%mkvmerge%" == "" (
  echo.
  echo   ^>   %Red%Error^! %White%File %Yellow%"mkvmerge.exe" %White%not found!
  echo       %Bold%Will automatically download and extract %Yellow%"mkvmerge.exe"%White%...
  timeout 5 >nul
  cd bin
  call :dl-mkv
  cd ..
  timeout 5 >nul
  cls
)

set "ffprobe="
for /f "delims=" %%i in ('dir /s /b /a-d "ffprobe*.exe" 2^>nul') do set "ffprobe=%%i" & goto :ffbreak

:ffbreak
if "%ffprobe%" == "" (
  echo.
  echo   ^>   %Red%Error^! %White%File %Yellow%"ffprobe.exe" %White%not found!
  echo       %Bold%Will automatically download and extract %Yellow%"ffprobe.exe"%White%...
  timeout 5 >nul
  cd bin
  call :dl-ff
  cd ..
  timeout 5 >nul
  echo.
  echo.
  echo       %Bold%Please press any key to continue...%White%
  pause >nul
  cls
  if not defined _relaunched (set _relaunched=1 & start "" cmd /c "%~dpnx0" %* & exit)
)
cls

:: Main Menu
:main
if "%special%"=="n" (set "sp=%Red%N%White%") else if "%special%"=="y" (set "sp=%Green%Y%White%")
title mkvmerge_script %ver%  [mkv+ass / %drama%] - %Season% %count%
if "%type%"=="movie" (title mkvmerge_script %ver%  [mkv+ass / %drama%])


setlocal enableextensions enabledelayedexpansion	

echo  %White%                                                                                ╔════════════] Config: [════════════╗
echo                                                                                  ║ %Green%lang%White%:  1:kor   2: chi  3:zh-tw    ║
echo                                                                                  ║        4:jap   5:th    6:eng-tv   ║
echo                                                                                  ║        7:fil-tv      8:kvariety   ║

echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍              ║┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅║
setlocal
set "spaces=                               "
set "title1a=           %Green%mkvmerge%White%_%Lightgray%script %Red%%ver%%White%  [mkv+ass / "
set "title1b=                   ║ a:kor-mov   b:chi-mov  c:jap-mov  ║"
set "line=%title1a%%Yellow%%drama%%White% + %Yellow%%season%%White%]%spaces%"
set "line=%line:~0,105%  %title1b%
echo %line%
echo                    %Cyan%@rjmolina13 - ronanj.site/gh%White%                                  ║ d:th-mov    e:eng-mov  f:fil-mov  ║
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍              ║ %Cyan%season%White%: S1:S01  S2:S02  S3:S03    ║
echo                                                                                  ║         S4:S04  S5:S05  S6:S06    ║
echo                                                                                  ║         S:custom    0:default     ║
set "spaces1=                                                "
set "timestamp1='    Enter %Yellow%%drama%%White% Folder Path with"
set "message1=         ║   %Yellow%ssf:%White% script source font  sp: %sp%  ║"
set "line1=%timestamp1%%spaces1%"
set "line1=%line1:~0,80%  %message1%
echo                                                                                  ║         z: custom Ep   %Red%x: Exit%White%    ║
echo                                                                                  ║ %Yellow%sr:%White% cust. font %Yellow%csr:%White% cust. font/cd ║
echo                                                                                  ║     %Yellow%sb:%White% custom sub track tag      ║
echo %line1%
echo '    *.mkv and *.ass ready to be muxed:                                          ╚═══════════════════════════════════╝
set /p loc="'     %Yellow%> "
if /i "%loc%"=="exit" (exit) 
if /i "%loc%"=="x" (exit /b)
if /i "%loc%"=="1" (set "lang=kor" && set "drama=KDrama" && cls && goto main)
if /i "%loc%"=="2" (set "lang=zh-CN" && set "drama=CDrama" && cls && goto main)
if /i "%loc%"=="3" (set "lang=zh-TW" && set "drama=TWDrama" && cls && goto main)
if /i "%loc%"=="4" (set "lang=jpn" && set "drama=JDrama" && cls && goto main)
if /i "%loc%"=="5" (set "lang=th" && set "drama=Thai Drama" && cls && goto main)
if /i "%loc%"=="6" (set "lang=en" && set "drama=TV Show" && cls && goto main)
if /i "%loc%"=="7" (set "lang=fil" && set "drama=Fil TV" && cls && goto main)
if /i "%loc%"=="8" (set "lang=kor" && set "drama=KVariety" && set "type=variety"  && cls && goto main)

if /i "%loc%"=="a" (set "lang=kor" && set "drama=KMovie" && set "type=movie" && cls && goto main)
if /i "%loc%"=="b" (set "lang=zh-CN" && set "drama=CMovie" && set "type=movie" && cls && goto main)
if /i "%loc%"=="c" (set "lang=jpn" && set "drama=JMovie" && set "type=movie" && cls && goto main)
if /i "%loc%"=="d" (set "lang=th" && set "drama=Thai Movie" && set "type=movie" && cls && goto main)
if /i "%loc%"=="e" (set "lang=en" && set "drama=Eng Movie" && set "type=movie" && cls && goto main)
if /i "%loc%"=="f" (set "lang=fil" && set "drama=Fil Movie" && set "type=movie" && cls && goto main)

if /i "%loc%"=="0" (set "lang=kor" && set "drama=KDrama" && set "season=S01" && cls && goto start)
if /i "%loc%"=="s1" (set "season=S01" && cls && goto main)
if /i "%loc%"=="s2" (set "season=S02" && cls && goto main)
if /i "%loc%"=="s3" (set "season=S03" && cls && goto main)
if /i "%loc%"=="s4" (set "season=S04" && cls && goto main)
if /i "%loc%"=="s5" (set "season=S05" && cls && goto main)
if /i "%loc%"=="s" (goto s)
if /i "%loc%"=="z" (goto z)
if /i "%loc%"=="sr" (goto sr)
if /i "%loc%"=="csr" (goto csr)
if /i "%loc%"=="sb" (goto csubname)
if /i "%loc%"=="dl" (goto fontextract)
if /i "%loc%"=="ssf" (goto ssf)
if /i "%loc%"=="sp" (if /i "%special%"=="n" (set "special=y") else (set "special=n")) && cls && goto main

cls
:season
if "%type%"=="movie" (goto movie)
if "%type%"=="variety" (goto variety)
call :header && echo.
pushd "%loc%"
if /i "%special%"=="y" (if exist "*SP*" md sp && move "*SP*" sp)
echo.
echo %White%'    Current directory is: 
echo '     %Yellow%"%cd%"%White%
echo.
set /p title="'    Enter %drama% Title: %Magenta%"
if "%title%"=="b" (cls && goto main)
if "%title%"=="B" (cls && goto main)
echo %White%'
if exist "*.srt" md srt && move "*.srt" srt
if exist "*.srt" move "*.srt" srt
cls

setlocal enabledelayedexpansion
set "found=false"

if "%csr%"=="yes" (
    for %%i in ("%loc%\*.otf" "%loc%\*.ttf") do (
        set "font=%%i" && (
            if defined font (
                echo.
                echo %Green%Found font file^^!: %Yellow%"!font!"%White%
                set "found=true"
                echo.
            )
        )
    )

    if "!found!"=="false" (
        echo.
        echo %Red%No font files %Yellow%"*.otf" %Red%or %Yellow%"*.ttf" %Red%found in %White%"!loc!"%Red%.%White%
        echo If you enabled %Yellow%"csr"%White% or %Yellow%"Attach font from current directory"%White%,
        echo but no font file is present, the script will continue without the font file.
        echo.
        set "csr=no"
        timeout 5 >nul
    )
) else (
    rem Proceeding with the script because %csr% is not "yes"
)

if "%csr%"=="yes" if defined font (
    call :csryes
    goto finished
)

if "%csr%"=="no" if defined font (
    echo %Green%Font file specified is: %Yellow%"!font!"%White% && echo. && call :csryes
    goto finished
)

if "%csr%"=="no" if not defined font (
    call :csrno
    goto finished
)

:csryes
for %%A IN (*.mkv) do (
    set /a count += 1
    echo.
    echo %Yellow%"%title% - %season%E0!count!"%White%
    echo =============================================
    title mkvmerge_script %ver% [mkv+ass / %drama%]   l   Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
    <nul set /p ="Video resolution is: %Cyan%"
    %ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv" & set /p "=%White%" <nul
    if not "%subname%"=="" (
        %mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [%subname%]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --attach-file "%font%" --no-track-tags --no-global-tags
    ) else (
        %mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --attach-file "%font%" --no-track-tags --no-global-tags
    )
)
goto :eof

:csrno
for %%A IN (*.mkv) do (
    set /a count += 1
    echo.
    echo %Yellow%"%title% - %season%E0!count!"%White%
    echo =============================================
    title mkvmerge_script %ver% [mkv+ass / %drama%]   l   Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
    <nul set /p ="Video resolution is: %Cyan%"
    %ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv" & set /p "=%White%" <nul
    if not "%subname%"=="" (
      %mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [%subname%]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
    ) else (
        %mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
    )
    echo. && echo.
)
goto :eof

:finished
echo.
if exist sp (goto spyes) else goto ending
:spyes
cd sp
for %%A IN (*.mkv) do (
  set /a count = 0
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =============================================
title mkvmerge_script %ver% [mkv+ass / %drama%]   l   Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =============================================
)
cd..
:ending
echo. && echo.
cscript //nologo "%~dp0mkvmerge_script-play.vbs"
echo =============================================
title mkvmerge_script %ver% [mkv+ass / %drama%]   l   Done muxing^^!
echo %Green%Finished muxing^^!%White%
echo.
CHOICE  /C:yn /N /M "Would you like to move finished muxed files to root directory? (y/n): "
IF ERRORLEVEL 2 GOTO moveno
IF ERRORLEVEL 1 GOTO moveyes
echo.

:moveno
pause && exit


:moveyes
echo.
md empty
robocopy empty "%cd%" *.mkv /njs /njh /nc /purge
robocopy empty "%cd%" *.ass /njs /njh /nc /purge
robocopy empty "%cd%" *.txt /njs /njh /nc /purge
robocopy empty "%cd%\srt" *.srt /njs /njh /nc /purge
rd empty
echo.
timeout 4 >nul
move /y out\*.*
timeout 4 >nul
rd out
echo.
echo %cd%
if exist sp (cd sp && md empty && robocopy empty "%cd%\sp" *.mkv /njs /njh /nc /purge)
if exist out (rd empty && move "out\*.mkv" && rd out && cd.. && move "sp\*.mkv" && del "sp\*.ass" && rd sp)
if exist srt (rd srt)
pause
exit

:movie
call :header && echo.
pushd "%loc%"
echo.
echo %White%'    Current directory is: 
echo '     %Yellow%"%cd%"%White%
echo.
set /p title="'    Enter %drama% Title: %Magenta%"
if "%title%"=="b" (cls && goto main)
if "%title%"=="B" (cls && goto main)
echo %White%'
if exist "*.srt" del "*.srt"
cls
echo %loc%
for %%A IN (*.mkv) do (
  echo.
  echo %Yellow%"%title%"%White%
echo =============================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title%"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title%" --no-subtitles --no-attachments --audio-tracks "1" --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo. && echo.
)
echo. && echo.
goto :ending

:variety
call :header && echo.
pushd "%loc%"
echo.
echo %White%'    Current directory is: 
echo '     %Yellow%"%cd%"%White%
echo.
set /p title="'    Enter %drama% Title: %Magenta%"
if "%title%"=="b" (cls && goto main)
if "%title%"=="B" (cls && goto main)
echo.
echo %White%'    Select episode counting method: 
echo '     %Yellow% (a) Start from E01 %White%
echo '     %Yellow% (b) Start from a specific number continously %White%
echo '     %Yellow% (c) Specific episode number + one time only %White%
set /p countmet="'    Enter %Yellow%(a)%White%, %Yellow%(b)%White% or %Yellow%(c)%White%: "
if "%countmet%"=="a" (cls && goto epcount)
if "%countmet%"=="b" (goto epjump)
if "%countmet%"=="c" (goto epcust)
echo %White%'
echo.
:epcount
if exist "*.srt" del "*.srt"
cls
for %%A IN (*.mkv) do (
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%E0!count!"%White%
echo =============================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo. && echo.
)
echo.
if /i "%special%"=="y" (if exist sp (goto spyes)) else (goto ending)
:spyes
cd sp
for %%A IN (*.mkv) do (
  set /a count = 0
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =============================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =============================================
)
cd..
goto ending

:epjump
echo.
echo %White%'
set /p count="'    Enter episode number: "
echo %White%'
if exist "*.srt" del "*.srt"
cls
for %%A IN (*.mkv) do (
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%E0!count!"%White%
echo =============================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo. && echo.
)
echo.
if exist sp (goto spyes) else goto ending
:spyes
cd sp
set /a count = 0
for %%A IN (*.mkv) do (
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =============================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =============================================
)
cd..
goto ending


:z
cls && call :header && echo. && echo.
echo %White%'    Current Episode: %Yellow% !count! %White%
echo.
echo '    Input Custom Episode Number:
set /p count="'    (the number before the last episode) "
if "!count!"=="b" (cls && goto main)
if "!count!"=="B" (cls && goto main)
echo.
echo '    Episode is set to: %Yellow%!count!%White%
echo %White%'
timeout 3 >nul && cls && goto main

:s
cls && call :header && echo. && echo.
echo %White%'    Current Season: %Yellow% %Season% %White%
echo.
echo '    Input Custom Season Number:
set /p season="'    (letter S + two digit number) "
if "%season%"=="b" (set season=S01 && cls && goto main)
if "%season%"=="B" (set season=S01 && cls && goto main)
echo %White%'
cls && goto main

:sr
cls && call :header && echo. && echo.
echo %White%'    %Yellow%Attach custom font to be used by subtitles.%White%
echo %White%'    %Yellow%Font file path must exclude "quotation marks".%White%
echo.
set /p font="'    Font location: "
if "%font%"=="b" (cls && goto main)
if "%font%"=="B" (cls && goto main)
echo.
echo '    Custom font is: %Yellow%"%font%"%White%
echo. && timeout 3 >nul && cls && goto main


:csr
cls && call :header && echo. && echo.
echo %White%'    %Yellow%This mode will attach custom font in the current %White%
echo %White%'    %Yellow%directory to be used by subtitles.%White%
echo.
set csr=yes
echo. && echo. && timeout 3 >nul && cls && goto main

:ssf
cls && call :header && echo. && echo.
@REM goto fontextract
echo %White%'    %Yellow%This mode will attach custom font in the current %White%
echo %White%'    %Yellow%script directory to be used by subtitles.%White%
echo.
for %%i in ("%~dp0*.otf" "%~dp0*.ttf") do (set "font=%%i")
echo. && echo. && timeout 3 >nul && cls && goto main

:csubname
cls && call :header && echo. && echo.
echo %White%'    When you select the subtitle track inside the video
echo %White%'    player, by default it shows as %Yellow%"[English]",%White%
echo %White%'    this option allows you to set a custom subtitle%White%
echo %White%'    track name after %Yellow%"[English]"%White%, your input will
echo %White%'    be shown after the language.
echo.
set /p subname="'    Custom Subtitle Track Name: %Yellow%"
if "%subname%!"=="b" (cls && goto main)
if "%subname%"=="B" (cls && goto main)
echo. && echo.
echo '    %White%Custom Subtitle Track Name is: %Yellow%"%subname%"%White%,
echo '    will show as: %Yellow%"English [%subname%]"%White%.
echo. && timeout 8 >nul && cls && goto main

:: Header, display program text on top of the script
:header
echo. && echo. && echo. && echo.
echo %White% ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo            %Green%mkvmerge%White%_%Lightgray%script %Red%%ver%%White%  [mkv+ass / %Yellow%%drama%%White% + %Yellow%%season%%White%]%spaces%
echo                    %Cyan%@rjmolina13 - ronanj.site/gh%White%
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍  
goto :eof


:: Downloader script / first block
:dl-ff
set "filename=%ffmpeg-file%"
set "url=%ffmpeg_dlurl%"
set "exe=ffprobe.exe"
call :download_and_extract
for /f %%f in ('dir /B /T:C ffmpeg-*') do set "file=%%f" >nul
move "%file%\bin\%exe%" "%~dp0bin" >nul
rd /S /Q "%file%" >nul
echo       %Bold%Downloaded and extracted %Yellow%"%filename%"%White%.
goto :EOF

:: Downloader script / second block
:dl-mkv
set "filename=%mkvtoolnix-file%"
set "url=%mkvtoolnix_dlurl%"
set "exe=mkvmerge.exe"
call :download_and_extract
move "mkvtoolnix\%exe%" "%~dp0bin" >nul
rd /S /Q mkvtoolnix >nul
echo       %Bold%Downloaded and extracted %Yellow%"%filename%"%White%.
goto :EOF

:: =====================================
:: Function to download and extract
:download_and_extract
cls && echo. && echo. && echo. && echo. && echo. && echo. && echo. && echo. && echo.
echo   ^>   %Red%Error^! %White%File %Yellow%"%exe%" %White%not found!
echo       %Bold%Will automatically download and extract %Yellow%"%exe%"%White%...
echo       %Bold%Now downloading %Yellow%"%filename%"%White%...
@REM powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%filename%')"
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%filename%'"
if %errorlevel% neq 0 (
    echo Failed to download "%filename%"
    goto :EOF
)
@REM echo Extracting "%filename%"...
%sz% x -o. "%filename%" -r -y %exe% >nul
del "%filename%" >nul
goto :EOF


:: Function to download 7zip if it isn't installed
:szdl
setlocal enabledelayedexpansion
cls
if not exist !sz! (
    echo   ^>   %Red%Error^^! %White%File %Yellow%7-Zip %White%is not installed^^!
    echo       %Bold%Downloading and installing... %White%

    ::Define download URL and download location
    set download_url=https://www.7-zip.org/a/7z2403-x64.exe
    set "download_location=%TEMP%\7zInstaller.exe"

    :: Download 7-Zip installer using PowerShell
    echo.
    powershell -Command "Invoke-WebRequest -Uri '!download_url!' -OutFile '!download_location!' -Verbose"
    :: Install 7-Zip silently
    echo.
    echo   ^>   %Bold%Click %Green%"Yes"%White% when prompted with UAC.%White%
    start /wait "" "!download_location!" /S
    if errorlevel 1 (
      cls
      del "!download_location!" >nul
      echo   ^>   %Red%Error^^! %White%Failed to install %Yellow%"7-Zip"%White%.
      echo       %Bold%Please press any key to exit...%White%
      pause >nul && exit
    )
    
    :: Check if installation was successful
    if not exist !sz! (
      cls
      echo   ^>   %Red%Error^^! %White%Failed to install %Yellow%"7-Zip"%White%.
      del "!download_location!" >nul
      timeout 5 >nul && exit
    ) else (
      cls
      del "!download_location!" >nul
      echo   ^>   %Yellow%"7-Zip" %Green%installed successfully^!%White%
      echo       %Bold%Please press any key to continue...%White%
      pause >nul
      if not defined _relaunched (set _relaunched=1 & start "" cmd /c "%~dpnx0" %* & exit)
    )
)
goto :EOF

:fontextract
setlocal EnableDelayedExpansion

if not exist "%~dp0NetflixSans-Medium.otf" (
    set "base64URL=https://gist.githubusercontent.com/rjmolina13/651ba894bb7495c0292aa8a36e3220ca/raw/f727c365da24a7a2b94d94fcedf011bbc5f6c3d1/font.txt"
    set "base64File=%~dp0font.txt"
    set "fontFile=%~dp0NetflixSans-Medium.otf"

    cls && call :header && echo. && echo.
    echo %White%'    Downloading %Yellow%secret font file%White%... 
    powershell -command "& {$webClient = New-Object System.Net.WebClient; try {$webClient.DownloadFile('!base64URL!', '!base64File!')} catch { exit 1}}"

    if errorlevel 1 (
        echo. && echo.
        echo %White%'    %Red%Download failed%White%, returning to menu...
        timeout 5 >nul && cls && goto main
    )

    echo %White%'    Converting Base64 text to font file...
    certutil -decode "!base64File!" "!fontFile!" >nul 2>&1

    REM Clean up downloaded file
    del "!base64File!" >nul
    timeout 5 >nul && cls && goto main
) else (
    cls && call :header
    echo. && echo.
    echo %White%'    %Green%File %Yellow%"%~dp0NetflixSans-Medium.otf" %Green%exists^^!
    timeout 5 >nul && cls && goto main
)




