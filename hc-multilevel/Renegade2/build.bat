REM @echo off

set input=RENGADE2.TAP
set output=REN2HC.DSK
set name=ren2

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get LOIRO -n %name%scr : get main -n %name%main : get "TARGET R5" -n %name%lvl1 : get "TARGET R7" -n %name%lvl2 : get "TARGET R9" -n %name%lvl3 : get "TARGET R11" -n %name%lvl4 : get "TARGET R13" -n %name%lvl5 : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm
..\..\tools\sjasmplus ..\hcdskldr.asm
..\..\tools\sjasmplus ren2ldrhc.asm

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%.bas Ren2HC : put %name%scr -t b -s 16384 : put %name%main -t b -s 34816 : put hcdskldr -t b -s 32768 : put %name%ldrhc -t b -s 51898 : put %name%lvl1 -t b -s 25600 : put %name%lvl2 -t b -s 25600 : put %name%lvl3 -t b -s 25600 : put %name%lvl4 -t b -s 25600 : put %name%lvl5 -t b -s 25600 : dir : exit

@REM Cleanup
del %name%scr %name%main %name%lvl1 %name%lvl2 %name%lvl3 %name%lvl4 %name%lvl5 %name%ldrhc hcdskldr lvlldr.bin