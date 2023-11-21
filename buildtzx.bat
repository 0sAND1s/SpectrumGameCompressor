@setlocal enabledelayedexpansion

@REM Baud can be 6000, 3000, 2250, 1364 (ROM speed)
set baud=6000
@REM Set to 0 to compress better (and slower) and to not delete temporary binaries.
set develop=0
@REM Set to 0 to remove SCREEN$ to save space and loading time. For games like Dizzy, the screen is not removed, but is cropped to leave the outer area, to compress it better.
set wantscr=1

@if [%develop%]==[0] echo off
cls

pushd srctzx
set collection=*.bat
if NOT [%1]==[] set collection=%1.bat
for %%f in (%collection%) do (
set name=%%~nf
if exist ..\input\!name!.tap (set input=..\input\!name!.tap) else (if exist ..\input\!name!.tzx set input=..\input\!name!.tzx)
set output=..\output\!name!.tzx
call %%f
)
popd