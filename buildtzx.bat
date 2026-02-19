@setlocal enabledelayedexpansion

@REM Baud can be 6000, 3000, 2250, 1364 (ROM speed)
set baud=6000
@REM Set to 0 to compress better (and slower) and to not delete temporary binaries.
set develop=0
@REM Set to 0 to remove SCREEN$ to save space and loading time. For games like Dizzy, the screen is not removed, but is cropped to leave the outer area, to compress it better.
set wantscr=1

@if [%develop%]==[0] echo off && cls

REM Override default parameters with command line ones, if any.
set gamelist=*.bat
if NOT [%1]==[] set gamelist=%1.bat
if NOT [%2]==[] set baud=%2
if [%3]==[noscr] set wantscr=0

pushd srctzx

for %%f in (%gamelist%) do (

set name=%%~nf
if exist ..\input\!name!.tap (set input=..\input\!name!.tap) else (if exist ..\input\!name!.tzx set input=..\input\!name!.tzx)
set output=..\output\!name!

if NOT [%baud%]==[6000] set output=!output!_BAUD%baud%
if [%wantscr%]==[0] set output=!output!_noscr
set output=!output!.tzx

if [%develop%]==[1] (set lst=--lst) else (set lst=)

@REM call BAT script that extracts SCREEN$ and main block.
set customProcess=0
call %%f
if [!customProcess!]==[1] goto :cleanup

@REM skip SCREEN$ processing if we decided to not include the SCREEN$ in the output, either because we set wantScr=0 or because it doesn't fit in memory (like for Dizzy7), or is compressed in the original version, or it doesn't exist.
set size=0
if exist !name!.scr (
@REM order screen by columns for better compression
..\tools\hcdisk2 screen order column !name!.scr !name!c.scr : exit
@REM pack screen
call ..\tools\pack.bat !name!c.scr !name!.scr.zx0
call :getfilesize !name!.scr.zx0
)
set scrsize=!size!

@REM pack the main block
call ..\tools\pack.bat !name!.main !name!.main.zx0
call :getfilesize !name!.main.zx0
set mainsize=!size!

..\tools\sjasmplus !name!.asm --raw=!name!.bin -DBAUD=!baud! -DMAIN_SIZE=!mainsize! -DSCR_SIZE=!scrsize! !lst!

..\tools\hcdisk2 format !output! -y : open !output! : bin2bas var !name!.bin !name! : exit
if exist !name!.scr ..\tools\hcdisk2 open !output! : put !name!.scr.zx0 -turbo !baud! : exit
..\tools\hcdisk2 open !output! : put !name!.main.zx0 -turbo !baud! : dir : exit

:cleanup
if [!develop!]==[0] del !name!.bin !name!.scr !name!c.scr !name!.main !name!.main.zx0 !name!.scr.zx0 !name!.lst
echo Produced !output!

)
popd

exit /b

:getfilesize
set size=%~z1
exit /b