setlocal enabledelayedexpansion

REM Baud can be 6000, 3000, 2250, 1364 (ROM speed)
set baud=6000
set develop=0
set wantscr=1

cls

pushd srctzx
set collection=*.bat
if NOT [%1]==[] set collection=%1.bat
for %%f in (%collection%) do (
set name=%%~nf
if exist ..\input\!name!.tap (set input=..\input\!name!.tap) else (if exist ..\input\!name!.tzx set input=..\input\!name!.tzx)
call %%f
)
popd