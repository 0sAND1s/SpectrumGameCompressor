REM @echo off

set input="Batman - The Movie (Erbe).tzx"
set output=BatmanHC.dsk
set name=batman

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get $ -n %name%scr : get code -n %name%main : get BATMAN6 -n %name%lvl1 : get BATMAN8 -n %name%lvl2 : get BATMAN10 -n %name%lvl3 : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm
..\..\tools\sjasmplus ..\hcdskldr.asm
..\..\tools\sjasmplus %name%ldr1.asm
..\..\tools\sjasmplus %name%ldr2.asm
..\..\tools\sjasmplus mover.asm

@REM Patch game code with HC disk loaders
..\..\tools\hcdisk2 binpatch %name%main %name%ldr1 1936 : binpatch %name%main %name%ldr2 2348 : exit

@REM Put mover in front of main block
copy /b mover+%name%main %name%main1

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas %name% : put %name%scr -t b -s 16384 : put hcdskldr -t b -s 32768 : put %name%main1 -n %name%main -t b -s 40000 : put %name%lvl1 -t b -s 25485 : put %name%lvl2 -t b -s 25485 : put %name%lvl3 -t b -s 25485 : dir : exit

@REM Cleanup
del %name%scr %name%main %name%lvl1 %name%lvl2 %name%lvl3 %name%ldr1 %name%ldr2 hcdskldr lvlldr.bin %name%main1 mover