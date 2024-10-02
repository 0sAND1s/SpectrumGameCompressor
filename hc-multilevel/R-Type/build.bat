REM @echo off
setlocal enabledelayedexpansion

set input=rtype.tap
set name=rtype
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get scr -n %name%scr : get part1 -n %name%main1 : get part2 -n %name%main2 : exit
set l=1
for /L %%i in (6,2,20) do (
..\..\tools\hcdisk2 open %input% : get R-TYPE%%i -n %name%lvl!l! : exit
set /A l=!l!+1
)

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game code with HC disk loader
..\..\tools\hcdisk2 binpatch %name%main2 %name%ldr 8515 : exit

@REM Patch game code to disable anoying prompts
@REM $862E, $FE24 - $FE31, $FE39 - $FE4C, $FEA1 - $FEB9 - prints scroll, start tape, etc
fsutil file setZeroData offset=5678 length=3 %name%main1
fsutil file setZeroData offset=8460 length=14 %name%main2
fsutil file setZeroData offset=8482 length=19 %name%main2
fsutil file setZeroData offset=8585 length=24 %name%main2

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas run : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%main1 -t b -s 28672 : put %name%main2 -t b -s 56600 : exit
for %%l in (1 2 3 4 5 6 7 8) do ..\..\tools\hcdisk2 open %output% : put %name%lvl%%l -t b -s 50350 : exit
..\..\tools\hcdisk2 open %output% : dir : exit

@REM Cleanup
del %name%scr %name%main1 %name%main2 %levelldr% %name%ldr %name%lvl?
