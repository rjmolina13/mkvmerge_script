%@echo off
::- Changelog: (04/04/2024)
::+ 4.5 - added custom episode
::+ 5.0 - added ffprobe and mkvmerge checking
::+ 5.1 - reimplemented vbs playback
::+ 5.2 - added bin folder checking
::+ 5.3 - reduced lines, calls :header instead of printing header mutiple lines
::+ 5.4 - colorized current show being processed
::+ 5.5 - add auto download dependencies
::+ 5.6 - add auto extract
::+ 5.8 - add auto 7zip detection & download
::+ 5.9 - improvements
::+ 6.0 - batch script final ver


:: Check play sound vbs if exists else creates
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
set ver=v6.0

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

:: Real start
:start
set season=S01
set lang=kor
set drama=KDrama
set type=drama
set /a count = 0

:: Variables, url, version, filename
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

:: :mkvmbreak and :ffbreak checks if dependencies exists else prompts user to download
:mkvmbreak
if "%mkvmerge%" == "" (
  echo.
  echo   ^>   %Red%Error^^! %White%File %Yellow%mkvmerge*.exe %White%not found!
  echo       %Bold%Please download %Yellow%mkvmerge.exe %White% and extract it to the same folder with this script.
  echo       %Bold%Please press any key to continue..%White%
  pause >nul
  cd bin
  call :dl-mkv
  cd ..
  timeout 5 >nul
) else (
  rem mkvmerge found!
)


set "ffprobe="
for /f "delims=" %%i in ('dir /s /b /a-d "ffprobe*.exe" 2^>nul') do set "ffprobe=%%i" & goto :ffbreak

:ffbreak
if "%ffprobe%" == "" (
  echo.
  echo   ^>   %Red%Error^! %White%File %Yellow%ffprobe*.exe %White%not found!
  echo       %Bold%Please download %Yellow%ffprobe.exe.%White% and extract it to the same folder with this script.
  echo       %Bold%Please press any key to continue..%White%
  pause >nul
  cd bin
  call :dl-ff
  cd ..
  timeout 5 >nul
  echo       %Bold%Please press any key to continue..%White%
  pause >nul
  cls
) else (
  rem ffprobe found!
)
cls


:: Main manu
:main
::=================================================================================
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
set "message1=         ║         z: custom Ep   %Red%x:Exit%White%     ║"
set "line1=%timestamp1%%spaces1%"
set "line1=%line1:~0,80%  %message1%
echo %line1%
REM echo '    Enter %drama% Folder Path with                                               ╚═══════════════════════════════════╝
echo '    *.mkv and *.ass ready to be muxed:                                          ╚═══════════════════════════════════╝
set /p loc="'     %Yellow%> "
if "%loc%"=="exit" (exit) 
if "%loc%"=="EXIT" (exit) 

if "%loc%"=="x" (exit)
if "%loc%"=="X" (exit)
if "%loc%"=="1" (echo %white%. && set "lang=kor" && set "drama=KDrama" && cls && goto main)
if "%loc%"=="2" (echo %white%. && set "lang=zh-CN" && set "drama=CDrama" && cls && goto main)
if "%loc%"=="3" (echo %white%. && set "lang=zh-TW" && set "drama=TWDrama" && cls && goto main)
if "%loc%"=="4" (echo %white%. && set "lang=jpn" && set "drama=JDrama" && cls && goto main)
if "%loc%"=="5" (echo %white%. && set "lang=th" && set "drama=Thai Drama" && cls && goto main)
if "%loc%"=="6" (echo %white%. && set "lang=en" && set "drama=TV Show" && cls && goto main)
if "%loc%"=="7" (echo %white%. && set "lang=fil" && set "drama=Fil TV Show" && cls && goto main)
if "%loc%"=="8" (echo %white%. && set "lang=kor" && set "drama=KVariety" && set "type=variety"  && cls && goto main)

if "%loc%"=="a" (echo %white%. && set "lang=kor" && set "drama=KMovie" && set "type=movie" && cls && goto main)
if "%loc%"=="b" (echo %white%. && set "lang=zh-CN" && set "drama=CMovie" && set "type=movie" && cls && goto main)
if "%loc%"=="c" (echo %white%. && set "lang=jpn" && set "drama=JMovie" && set "type=movie" && cls && goto main)
if "%loc%"=="d" (echo %white%. && set "lang=th" && set "drama=Thai Movie" && set "type=movie" && cls && goto main)
if "%loc%"=="e" (echo %white%. && set "lang=en" && set "drama=Eng Movie" && set "type=movie" && cls && goto main)
if "%loc%"=="f" (echo %white%. && set "lang=fil" && set "drama=Fil Movie" && set "type=movie" && cls && goto main)

if "%loc%"=="0" (echo %white%. && set "lang=kor" && set "drama=KDrama" && set "season=S01" && cls && goto start)
if "%loc%"=="s1" (echo %white%. && set "season=S01" && cls && goto main)
if "%loc%"=="S1" (echo %white%. && set "season=S01" && cls && goto main)
if "%loc%"=="s2" (echo %white%. && set "season=S02" && cls && goto main)
if "%loc%"=="S2" (echo %white%. && set "season=S02" && cls && goto main)
if "%loc%"=="s3" (echo %white%. && set "season=S03" && cls && goto main)
if "%loc%"=="S3" (echo %white%. && set "season=S03" && cls && goto main)
if "%loc%"=="s4" (echo %white%. && set "season=S04" && cls && goto main)
if "%loc%"=="S4" (echo %white%. && set "season=S04" && cls && goto main)
if "%loc%"=="s5" (echo %white%. && set "season=S05" && cls && goto main)
if "%loc%"=="S5" (echo %white%. && set "season=S05" && cls && goto main)
if "%loc%"=="s" (echo %white%. && goto s)
if "%loc%"=="S" (echo %white%. && goto s)
if "%loc%"=="z" (echo %white%. && goto z)
if "%loc%"=="Z" (echo %white%. && goto z)
cls
:season
if "%type%"=="movie" (goto movie)
if "%type%"=="variety" (goto variety)
call :header
echo.
pushd "%loc%"
if exist "*SP*" md sp && move "*SP*" sp
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
for %%A IN (*.mkv) do (
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%E0!count!"%White%
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo.
echo.
)
echo.
if exist sp (goto wewsp) else goto ending
:wewsp
cd sp
for %%A IN (*.mkv) do (
  set /a count = 0
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =====================================
)
cd..
:ending
echo.
echo.
cscript //nologo "%~dp0mkvmerge_script-play.vbs"
echo ```````````````````````````````````````````````````````````````
title mkvmerge_script %ver%   [mkv+ass / %drama%]   l    Done muxing^!
echo Finished muxing!
echo.
echo Would you like to move finished muxed files to root dir?
CHOICE  /C:12 /N /M "1) Yes // 2) No: "
IF ERRORLEVEL 2 GOTO wewno
IF ERRORLEVEL 1 GOTO wewyes
echo.

:wewno
pause
exit


:wewyes
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
call :header
echo.
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
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title%"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title%" --no-subtitles --no-attachments --audio-tracks "1" --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo.
echo.
)
echo.
echo.
goto :ending

:variety
call :header
echo.
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
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo.
echo.
)
echo.
if exist sp (goto wewsp) else goto ending
:wewsp
cd sp
for %%A IN (*.mkv) do (
  set /a count = 0
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =====================================
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
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%E0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo.
echo.
)
echo.
if exist sp (goto wewsp) else goto ending
:wewsp
cd sp
set /a count = 0
for %%A IN (*.mkv) do (
  echo.
  set /a count += 1
  echo.
  echo %Yellow%"%title% - %season%SP0!count!"%White%
echo =====================================
title mkvmerge_script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =====================================
)
cd..
goto ending


:z
cls
call :header
echo.
echo.
echo %White%'    Current Episode: %Yellow% !count! %White%
echo.
echo '    Input Custom Episode Number:
set /p count="'    (the number before the last episode) "
if "!count!"=="b" (cls && goto main)
if "!count!"=="B" (cls && goto main)
echo.
echo '    Episode is set to: %Yellow%!count!%White%
echo %White%'
timeout 3 >nul
cls && goto main

:s
cls
call :header
echo.
echo.
echo %White%'    Current Season: %Yellow% %Season% %White%
echo.
echo '    Input Custom Season Number:
set /p season="'    (letter S + two digit number) "
if "%season%"=="b" (set season=S01 && cls && goto main)
if "%season%"=="B" (set season=S01 && cls && goto main)
echo %White%'
cls && goto main

:: Header, display program text on top of the script
:header
echo.
echo.
echo.
echo.
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
echo       %Bold%Now downloading %Yellow%"%filename%"%White%...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%filename%')"
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
if not exist %sz% (
    echo 7-Zip not found. Downloading and installing...

    REM Define download URL
    set "download_url=https://www.7-zip.org/a/7z2403-x64.exe"

    REM Define download location
    set "download_location=%TEMP%\7zInstaller.exe"

    REM Download 7-Zip installer using PowerShell
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%download_location%')"

    REM Install 7-Zip silently
    start /wait "" "%download_location%" /S

    REM Check if installation was successful
    if not exist %sz% (
        echo Failed to install 7-Zip.
        exit /b 1
    )

    REM Clean up downloaded installer
    del "%download_location%"
)
goto :EOF