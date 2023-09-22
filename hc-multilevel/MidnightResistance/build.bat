REM @echo off

set input="Midnight Resistance - Side 1 (Erbe).tzx"
set name=midres
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get $ -n %name%scr : get code1 -n %name%main : get "M Res 487" -n %name%lvl1 : get "M Res 489" -n %name%lvl2 : get "M Res 4811" -n %name%lvl3 : get "M Res 4813" -n %name%lvl4 : get "M Res 4815" -n %name%lvl5 : get "M Res 4817" -n %name%lvl6 :  get "M Res 4819" -n %name%lvl7 :  get "M Res 4821" -n %name%lvl8 : get "M Res 4823" -n %name%lvl9 : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Patch game code with 2 disk loaders
..\..\tools\hcdisk2 binpatch %name%main %name%ldr 5449 : exit

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%.bas %name%HC : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%main -t b -s 26624 : put %name%lvl1 -t b -s 56553 : put %name%lvl2 -t b -s 56553 : put %name%lvl3 -t b -s 56553 : put %name%lvl4 -t b -s 56553 : put %name%lvl5 -t b -s 56553 : put %name%lvl6 -t b -s 56553 : put %name%lvl7 -t b -s 56553 : put %name%lvl8 -t b -s 56553 : put %name%lvl9 -t b -s 56553 : dir : exit

@REM Cleanup
del %name%scr %name%main %name%lvl1 %name%lvl2 %name%lvl3 %name%lvl4 %name%lvl5 %name%lvl6 %name%lvl7 %name%lvl8 %name%lvl9 %name%ldr %levelldr%