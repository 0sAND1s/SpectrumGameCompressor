setlocal enabledelayedexpansion
rem echo off
cls
set name=StrmLrd2
set input=..\input\%name%.tap
set develop=0

..\tools\hcdisk2 open %input% : get $ -n %name%.scr : get Delivran5 -n %name%-1.main : get Delivran6 -n %name%-2.main : get Delivran7 -n %name%-3.main : exit

..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit
@REM pack screen
call ..\tools\pack.bat %name%c.scr %name%.scr.packed
call :getfilesize %name%.scr.packed
set havescr=-DHAVE_SCR 
set scrsize=%size%

for %%l in (1 2 3) do (
call ..\tools\pack.bat %name%-%%l.main %name%.main.packed
call :getfilesize %name%.main.packed

..\tools\sjasmplus.exe ..\srctap\%name%.asm --raw=%name%.ldr -DSCR_SIZE=%scrsize% -DMAIN_SIZE=!size! %havescr% -DNAME=%name%-%%l -DLEVEL=%%l
copy /b %name%.ldr + %name%.main.packed + %name%.scr.packed %name%.out
..\tools\hcdisk2 format ..\output\%name%-%%l.tap -y : open ..\output\%name%-%%l.tap : bin2bas var %name%.out %name%-%%l : dir : exit
)

del /Q %name%*.scr %name%*.main %name%*.packed %name%*.out %name%.ldr

goto :EOF

:getfilesize
set size=%~z1
exit /b
