@echo off
color 6
cls

echo "Correct usage is 'Input, Output, framerate, YUV"
REM cd /D "%~dp0"

REM check if argument provided

if [%1]==[] goto get-input

set INPUT=%1
goto check-output

:get-input
echo "Input file here"

set /P INPUT=[input file]
goto check-output


:check-output

if [%2]==[] goto get-output

set "OUTPUT=%2"
goto check-framerate



:get-output
echo "OUTPUT file here"
set /P OUTPUT=[output file]
goto check-framerate


:check-framerate
if [%3]==[] goto get-framerate
set FRAMERATE=%3
goto check-YUV

:get-framerate
set /P FRAMERATE=[input framerate]
goto check-YUV


:check-YUV
if [%4]==[] set goto YUV-start
set YUV=%4

:YUV-start
echo "if you get invalid input try using yuv444p, default is yuv420p" 
CHOICE /T 10 /C 123 /M "1. YUV420p 2. YUV444p 3. Custom)" /D 1
IF ERRORLEVEL ==3 GOTO set-YUV
IF ERRORLEVEL ==2 GOTO set-yuv444p
IF ERRORLEVEL ==1 GOTO set-yuv420p

:set-yuv420p
if [%4]==[] set YUV=yuv420p
if YUV==[yuv420p] goto RUN
goto RUN

:set-yuv444p
if [%4]==[] set YUV=yuv444p
if YUV==[yuv444p] goto RUN
goto RUN

:set-YUV
set /P YUV=[set colour space]
goto RUN

:RUN
ffmpeg -i %INPUT% -f yuv4mpegpipe -r %FRAMERATE% -pix_fmt %YUV% - | avifenc --stdin %OUTPUT% --cicp 1/13/6 --fps %FRAMERATE%
