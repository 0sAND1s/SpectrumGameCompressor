@echo off

REM for each game folder, will call the game specific script to extract the game files, combine files, skip files, etc.
set gamelist="*"
if not "%1"=="" set gamelist=%1
for /d %%d in (%gamelist%) do call :buildgame %%d
goto end


:buildgame
pushd %1
set name=%1
set input=..\..\input\%name%.tap
set output=..\..\output\%name%.tap
set dontcompress=0
REM skip build if output exists
REM if exist %output% goto skipgamebuild
REM skip build if game.bat not present yet.
if exist game.bat (call game.bat) else (goto skipgamebuild)

REM skip SCREEN$ processing if we decided to not include the SCREEN$ in the output
if exist %blkScr% (
REM order screen by columns for better compression
..\..\tools\scr o %blkScr% %name%.scr 2
REM pack screen
call ..\..\tools\pack.bat %name%.scr %name%scr.exo
call :getfilesize %name%scr.exo
)
set scrsize=%size%

REM pack the main block
if not "%dontcompress%"=="1" (
call ..\..\tools\pack.bat %blkMain% %name%main.exo
call :getfilesize %name%main.exo
)
set mainsize=%size%

REM assemble loader and pass detected blob sizes
..\..\tools\sjasmplus.exe %name%.asm --raw=%name%ldr.bin -DSCR_SIZE=%scrsize% -DMAIN_SIZE=%mainsize%

REM create final blob = loader + main game blob + optional screen.
if exist %name%scr.exo (
copy /b %name%ldr.bin + %name%main.exo + %name%scr.exo %name%.bin
) else (
copy /b %name%ldr.bin + %name%main.exo %name%.bin
)

REM output TAP file with blob in REM line
..\..\tools\hcdisk2 format %output% -y : open %output% : bin2rem %name%.bin %name% : dir : exit
del %blkScr% %blkMain% *.scr *.bin *.exo
rem start %output%

:skipgamebuild
popd
exit /b

:getfilesize
set size=%~z1
exit /b

:end