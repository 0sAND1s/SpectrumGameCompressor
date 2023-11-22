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
call %%f
if [%develop%]==[0] del !name!.bin !name!.scr !name!c.scr !name!.main !name!.main.zx0 !name!.scr.zx0 !name!.lst
echo Produced !output!

)
popd