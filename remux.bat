REM @echo off
color 6
echo "this is used to convert av1 videos from rav1e to mp4 and then optionally to convert to avif"



set /P VIDEOIN=[video to remux here]
set /P VIDEOUT=[output video file here]

ffmpeg -i %VIDEOIN% -codec copy %VIDEOUT%

echo "Done remuxing do you want to make avif?"

REM https://gpac.wp.imt.fr/
CHOICE /T 20 /C yn /M "NOTE MP4Box (GPAC Multimedia opensource project) is needed to continue" /D y
IF ERRORLEVEL ==2 exit
IF ERRORLEVEL ==1 goto avif-start

rem AVIF is generally very similar to .mp4 therefor is not necessary to transcode

:avif-start

REM OUTPUT and INPUT need to be same directory
REM all of this is absolutly retarded but seemingly necessary...
REM this is needed for no good reason
setlocal ENABLEDELAYEDEXPANSION
REM set file 
REM get ending extension Wildcards only work backwards for some assinine reason 
set why=%VIDEOUT:*.=%
REM set final extention
set ext=avif
REM Call is absolutly necessary as it causes a second expanding layer. needs double quotes for some reason.
call set END=%%VIDEOUT:%why%=!ext!%%
REM echo %END%
move %VIDEOUT% %END%

mp4box -ab avis %END%