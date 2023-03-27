@REM for each game folder, will call the game specific script to extract the game files, combine files, skip files, etc.
@REM naming convention: SCREEN$ = %name%.scr, main block = %name%.main, loader = %name%.ldr

@REM If set to 1, files won't be cleaned up, listing file will be produced.
@set develop=0

@if "%develop%"=="1" (
@set lst=--lst
) else (
@echo off
set lst=
cls
)

@REM some games, like Dizzy, show the SCREEN$ border during the game. Part of the loading SCREEN$ that's not shown in the game can be cropped, for better compression, reducing 1-3 KB. Set cropScr=1.
set cropScr=0
@REM we can decide to skipp the SCREEN$ completelly for some games.
set skipScr=0

set gamelist="src\*.bat"
if not "%1"=="" set gamelist=src\%1.bat
for %%d in (%gamelist%) do call :buildgame %%~nd
goto end


:buildgame
pushd src
set name=%1
if exist ..\input\%name%.tap (set input=..\input\%name%.tap) else (if exist ..\input\%name%.tzx set input=..\input\%name%.tzx)
if "%input%"=="" goto skipgamebuild
set output=..\output\%name%.tap
set doCompress=1

@REM Always cleanup temp files before build.
call :cleanup
del %output%

@REM skip build if output exists
REM if exist %output% goto skipgamebuild
@REM skip build if game.bat not present yet.
if exist %name%.asm (call %name%.bat) else (goto skipgamebuild)

@REM skip SCREEN$ processing if we decided to not include the SCREEN$ in the output, either because we set skipScr or because it doesn't fit in memory (like for Dizzy7)
if exist %name%.scr (
@REM order screen by columns for better compression
..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit
@REM pack screen
call ..\tools\pack.bat %name%c.scr %name%.scr.packed
call :getfilesize %name%.scr.packed
set havescr=-DHAVE_SCR 
) else (
set size=0
set havescr=
)

set scrsize=%size%

@REM pack the main block
if "%doCompress%"=="1" (
call ..\tools\pack.bat %name%.main %name%.main.packed
call :getfilesize %name%.main.packed
)
set mainsize=%size%

@REM assemble loader and pass detected blob sizes. Adding --lst produces the listing file which can help in troubleshooting the ASM loader.
..\tools\sjasmplus.exe %name%.asm --raw=%name%.ldr -DSCR_SIZE=%scrsize% -DMAIN_SIZE=%mainsize% %havescr% %lst%

@REM create final blob = loader + main game blob + optional screen.
if exist %name%.scr.packed (
	copy /b %name%.ldr + %name%.main.packed + %name%.scr.packed %name%.out
) else (
	copy /b %name%.ldr + %name%.main.packed %name%.out
)


@REM output TAP file with blob in REM line
..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.out %name% : dir : exit

@REM cleanup temp files after build
if %develop%==0 call :cleanup

@REM start game to test it, if building a single game
if not %gamelist%=="src\*.bat" start %output%

:skipgamebuild
popd
exit /b

:getfilesize
set size=%~z1
exit /b

:cleanup
del %name%.main %name%*.scr %name%.ldr %name%.out *.packed *.lst
exit /b

:end