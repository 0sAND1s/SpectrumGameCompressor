@echo off

@REM for each game folder, will call the game specific script to extract the game files, combine files, skip files, etc.
@REM naming convention: SCREEN$ = %name%.scr, main block = %name%.main, loader = %name%.ldr

@REM some games, like Dizzy, show the SCREEN$ border during the game. Part of the loading SCREEN$ that's not shown in the game can be cropped, for better compression, reducing 1-3 KB. Set cropScr=1.
set cropScr=0

set gamelist="*"
if not "%1"=="" set gamelist=%1
for /d %%d in (%gamelist%) do call :buildgame %%d
goto end


:buildgame
pushd %1
set name=%1
set input=..\..\input\%name%.tap
set output=..\..\output\%name%.tap
set doCompress=1

@REM skip build if output exists
REM if exist %output% goto skipgamebuild
@REM skip build if game.bat not present yet.
if exist game.bat (call game.bat) else (goto skipgamebuild)

@REM skip SCREEN$ processing if we decided to not include the SCREEN$ in the output
if exist %name%.scr (
@REM order screen by columns for better compression
..\..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit

@REM pack screen
call ..\..\tools\pack.bat %name%c.scr %name%.scr.exo
call :getfilesize %name%.scr.exo
)
set scrsize=%size%

@REM pack the main block
if "%doCompress%"=="1" (
call ..\..\tools\pack.bat %name%.main %name%.main.exo
call :getfilesize %name%.main.exo
)
set mainsize=%size%

@REM assemble loader and pass detected blob sizes. Adding --lst produces the listing file which can help in troubleshooting the ASM loader.
..\..\tools\sjasmplus.exe %name%.asm --raw=%name%.ldr -DSCR_SIZE=%scrsize% -DMAIN_SIZE=%mainsize%

@REM create final blob = loader + main game blob + optional screen.
if exist %name%.scr.exo (
	copy /b %name%.ldr + %name%.main.exo + %name%.scr.exo %name%.out
) else (
	copy /b %name%.ldr + %name%.main.exo %name%.out
)


@REM output TAP file with blob in REM line
..\..\tools\hcdisk2 format %output% -y : open %output% : bin2rem %name%.out %name% : dir : exit

@REM cleanup temp files
del %name%.main %name%*.scr %name%.ldr %name%.out *.exo

@REM start game to test it, if building a single game
if not %gamelist%=="*" start %output%

:skipgamebuild
popd
exit /b

:getfilesize
set size=%~z1
exit /b

:end