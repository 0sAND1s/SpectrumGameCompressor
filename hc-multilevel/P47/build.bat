REM @echo off
cls
setlocal enabledelayedexpansion

set name=P47
set input=%name%.TAP
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get P47$ -n %name%scr : get P47C -n %name%main : exit

set i=0
for /L %%l in (5,2,19) do (
..\..\tools\hcdisk2 open %input% : get P-47%%l -n %name%lvl!i! : exit
set /A i=!i!+1
)

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game code with HC disk loader
..\..\tools\hcdisk2 binpatch %name%main %name%ldr 8305 : exit

@REM Put files to disk image
echo 10 LOAD *"d";0;"P47HC" > run.bas
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp run.bas run 10 : basimp %name%ldr.bas %name%HC : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%main -t b -s 24500 : exit

for /L %%l in (0,1,7) do hcdisk2 open %output% : put %name%lvl%%l -t b -s 45056 : exit

hcdisk2 open %output% : dir : exit

@REM Cleanup
del %name%scr %name%main %name%lvl? %name%ldr %levelldr% run.bas