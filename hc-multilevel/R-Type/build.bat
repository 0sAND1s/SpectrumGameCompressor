REM @echo off

set input=rtype.tap
set name=rtype
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get scr -n %name%scr : get part1 -n %name%main1 : get part2 -n %name%main2 : get R-TYPE6 -n %name%lvl1 : get R-TYPE8 -n %name%lvl2 : get R-TYPE10 -n %name%lvl3 : get R-TYPE12 -n %name%lvl4 : get R-TYPE14 -n %name%lvl5 : get R-TYPE16 -n %name%lvl6 : get R-TYPE18 -n %name%lvl7 : get R-TYPE20 -n %name%lvl8 : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game code with HC disk loader
..\..\tools\hcdisk2 binpatch %name%main2 %name%ldr 8515 : exit

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas %name%HC : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%main1 -t b -s 28672 : put %name%main2 -t b -s 56600 : exit
for %%l in (1 2 3 4 5 6 7 8) do ..\..\tools\hcdisk2 open %output% : put %name%lvl%%l -t b -s 50350 : exit
..\..\tools\hcdisk2 open %output% : dir : exit

@REM Cleanup
del %name%scr %name%main1 %name%main2 %levelldr% %name%ldr %name%lvl?