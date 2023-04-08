%@echo off
::- Changelog: (02/20/2023)
::+ 4.5 - added custom episode
::+ 5.0 - added ffprobe and mkvmerge checking
::+ 5.1 - reimplemented vbs playback
::+ 5.2 - added bin folder checking
 

:: Make playing vbs script
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


if not exist "%~dp0bin\" (
  md bin
)

@REM pause
@REM exit /b


:init
chcp 65001 >NUL
set ver=v5.2
set nhcolor=
set Green=%nhcolor%[32m
set White=%nhcolor%[37m
set Cyan=%nhcolor%[36m

set Magenta=%nhcolor%[35m
set Red=%nhcolor%[31m
set Yellow=%nhcolor%[33m
set Lightgray=%nhcolor%[38m
set Bold=%nhcolor%[1m

call :header

set "mkvmerge="
for /f "delims=" %%i in ('dir /s /b /a-d "mkvmerge*.exe" 2^>nul') do set "mkvmerge=%%i" & goto :mkvmbreak

:mkvmbreak
if "%mkvmerge%" == "" (
  echo.
  echo   ^>   %Red%Error^^! %White%File %Yellow%mkvmerge*.exe %White%not found!
  echo       %Bold%Please download %Yellow%mkvmerge.exe.%White% and extract it to the same folder with this script.
  echo       %Bold%Please press any key to continue..%White%
  pause >nul
  start "" explorer %~dp0
  start https://mkvtoolnix.download/downloads.html#windows
  timeout 5 >nul
  exit /b
) else (
  rem mkvmerge found!
)


set "ffprobe="
for /f "delims=" %%i in ('dir /s /b /a-d "ffprobe*.exe" 2^>nul') do set "ffprobe=%%i" & goto :ffbreak

:ffbreak
if "%ffprobe%" == "" (
  echo.
  echo   ^>   %Red%Error^^! %White%File %Yellow%ffprobe*.exe %White%not found!
  echo       %Bold%Please download %Yellow%ffprobe.exe.%White% and extract it to the same folder with this script.
  echo       %Bold%Please press any key to continue..%White%
  pause >nul
  start "" explorer %~dp0
  start https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z
  timeout 5 >nul
  exit /b
  pause >nul
) else (
  rem ffprobe found!
)

cls



:start
set season=S01
set mkvmerge="%~dp0bin\mkvmerge.exe"
set ffprobe="%~dp0bin\ffprobe.exe"
set lang=kor
set drama=KDrama
set type=drama

set /a count = 0
:main
::=================================================================================
title mkvmerge Script %ver%  [mkv+ass / %drama%] - %Season% %count%
if "%type%"=="movie" (title mkvmerge Script %ver%  [mkv+ass / %drama%])


setlocal enableextensions enabledelayedexpansion	

echo  %White%                                                                                ╔════════════] Config: [════════════╗
echo                                                                                  ║ %Green%lang%White%:  1:kor   2: chi  3:zh-tw    ║
echo                                                                                  ║        4:jap   5:th    6:eng-tv   ║
echo                                                                                  ║        7:fil-tv      8:kvariety   ║

echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍              ║┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅║
setlocal
set "spaces=                               "
set "timestamp=              %Green%mkvmerge%White% %Lightgray%Script %Red%%ver%%White%  [mkv+ass / "
set "message=                     ║ a:kor-mov   b:chi-mov  c:jap-mov  ║"
set "line=%timestamp%%Yellow%%drama%%White%]%spaces%"
set "line=%line:~0,93%  %message%
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
echo.
echo.
echo.
echo.
echo %White%╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo               mkvmerge Script %ver%  [mkv+ass / %drama%]
echo                    %Cyan%@rjmolina13 - ronanj.site/gh%White%  
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
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
  echo "%title% - %season%E0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
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
  echo "%title% - %season%SP0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =====================================
)
cd..
:ending
echo.
echo.
REM call "%~dp0play.bat"
cscript //nologo "%~dp0mkvmerge_script-play.vbs"
echo ```````````````````````````````````````````````````````````````
title mkvmerge Script %ver%   [mkv+ass / %drama%]   l    Done muxing^!
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
::if exist srt (cd srt && md empty && robocopy empty "%cd%\srt" *.srt /njs /njh /nc /purge && rd /s empty && cd.. && rd /s srt)
pause
exit
::(goto) 2>nul & del "%~f0"

:movie
echo.
echo.
echo.
echo.
echo %White%╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo               mkvmerge Script %ver%  [mkv+ass / %drama%]
echo                    %Cyan%@rjmolina13 - ronanj.site/gh%White%  
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
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
  echo "%title%"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title%"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title%" --no-subtitles --no-attachments --audio-tracks "1" --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo.
echo.
)
echo.
echo.
echo.
REM call "%~dp0play.bat"
cscript //nologo "%~f0?.wsf"
echo ```````````````````````````````````````````````````````````````
title mkvmerge Script %ver%   [mkv+ass / %drama%]   l    Done muxing^!
echo Finished muxing!
echo.
echo Would you like to move finished muxed files to root dir?
CHOICE  /C:12 /N /M "1) Yes // 2) No: "
IF ERRORLEVEL 2 GOTO wewno
IF ERRORLEVEL 1 GOTO wewyes
echo.

:variety
echo.
echo.
echo.
echo.
echo %White%╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo               mkvmerge Script %ver%  [mkv+ass / %drama%]
echo                    %Cyan%@rjmolina13 - ronanj.site/gh%White%  
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
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
  echo "%title% - %season%E0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
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
  echo "%title% - %season%SP0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
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
  echo "%title% - %season%E0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%E0!count!"
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
  echo "%title% - %season%SP0!count!"
echo =====================================
title mkvmerge Script %ver%   [mkv+ass / %drama%]    l     Muxing...  "%%~nA.mkv"    l     "%title% - %season%SP0!count!"
<nul set /p ="Video resolution is: "
%ffprobe% -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%~nA.mkv"
%mkvmerge% -o "out\%%~nA.mkv" --title "%title% - %season%SP0!count!" --no-subtitles --no-attachments --track-name "0:" --language "0:%lang%" --track-name "1:" --language "1:%lang%" "%%~A" --track-name "0:English [Rubyj]" --language "0:eng" --forced-track "0:yes" --default-track "0:yes" "%%~nA.ass" --no-track-tags --no-global-tags
echo =====================================
)
cd..
goto ending


:z
cls
echo.
echo.
echo.
echo %White%╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo               mkvmerge Script %ver%  [mkv+ass / %drama%]
echo                            %Cyan%@Rubyjane%White%
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
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
echo.
echo.
echo.
echo %White%╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo               mkvmerge Script %ver%  [mkv+ass / %drama%]
echo                            %Cyan%@Rubyjane%White%
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
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


:header
echo.
echo.
echo.
echo.
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍
echo                       %Green%mkvmerge%White% %Lightgray%Script %Red%%ver%%White%
echo                            %Cyan%@Rubyjane%White%
echo ╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍  
goto :eof
