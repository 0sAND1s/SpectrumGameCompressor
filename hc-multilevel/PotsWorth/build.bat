REM @echo off
setlocal enabledelayedexpansion

set name=POTSWORT
set input=%name%.tap
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get POTSWORT3 -n %name%s : get POTSWORT4 -n %name%m : exit
set i=1
for /l %%l in (7,2,17) do (
..\..\tools\hcdisk2 open %input% : get POTSWORT%%l -n %name%!i!lvl : exit
set /A i=!i!+1
)
set i=1
for /l %%l in (6,2,16) do (
..\..\tools\hcdisk2 open %input% : get POTSWORT%%l -n %name%!i!hdr : exit
set /A i=!i!+1
)

for /L %%i in (1,1,6) do (
copy /b %name%%%ihdr+%name%%%ilvl %name%%%i
)


@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game with disk level loader
..\..\tools\hcdisk2 binpatch %name%m %name%ldr 385 : exit

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%.bas run : put %name%s -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%m -t b -s 44032 : exit
for /l %%l in (1,1,6) do ..\..\tools\hcdisk2 open %output% : put %name%%%l -t b -s 23296 : exit
..\..\tools\hcdisk2 open %output% : dir : exit


@REM Cleanup
del %name%s %name%m %name%ldr %levelldr% %name%1* %name%2* %name%3* %name%4* %name%5* %name%6*