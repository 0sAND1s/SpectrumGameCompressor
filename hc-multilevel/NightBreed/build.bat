REM @echo off

set name=nbreed
set input=nightbre.tap
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get BREED2 -n %name%scr : get BREED4 -n %name%lvl0 : get BREED6 -n %name%lvl1 : get BREED8 -n %name%lvl2 : get BREED10 -n %name%lvl3 : get BREED12 -n %name%lvl4 : get BREED14 -n %name%lvl5 : get BREED16 -n %name%lvl6 : exit

@REM Patch for unlimited lives
fsutil file setZeroData offset=14972 length=1 %name%lvl1
fsutil file setZeroData offset=18401 length=1 %name%lvl2
fsutil file setZeroData offset=14979 length=1 %name%lvl3

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game with disk level loader
..\..\tools\hcdisk2 binpatch %name%lvl0 %name%ldr 17823 : exit

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas run : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%lvl0 -t b -s 31790 : put %name%lvl1 -t b -s 25600 : put %name%lvl2 -t b -s 25600 : put %name%lvl3 -t b -s 25600 : put %name%lvl4 -t b -s 35390 : put %name%lvl5 -t b -s 35390 : put %name%lvl6 -t b -s 40000 : dir : exit

@REM Cleanup
del %name%scr %name%lvl0 %name%lvl1 %name%lvl2 %name%lvl3 %name%lvl4 %name%lvl5 %name%lvl6 %name%ldr %levelldr%