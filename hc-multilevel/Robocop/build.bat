REM @echo off

set input=robocop.tap
set output=Robocop1HC.DSK
set name=rbc

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get screen -n %name%scr : get code -n %name%main : get "ROBOCOP5" -n %name%lvl1 : get "ROBOCOP7" -n %name%lvl2 : get "ROBOCOP9" -n %name%lvl3 : get "ROBOCOP11" -n %name%lvl4 : get "ROBOCOP13" -n %name%lvl5 : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm
..\..\tools\sjasmplus ..\hcdskldr.asm
..\..\tools\sjasmplus rbclvlldr1.asm
..\..\tools\sjasmplus rbclvlldr2.asm

@REM Patch game code with 2 disk loaders
..\..\tools\hcdisk2 binpatch %name%main rbclvlldr1 333 : binpatch %name%main rbclvlldr2 13845 : exit

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas Robocop1HC : put %name%scr -t b -s 16384 : put hcdskldr -t b -s 32768 : put %name%main -t b -s 32767 : put %name%lvl1 -t b -s 43608 : put %name%lvl2 -t b -s 43608 : put %name%lvl3 -t b -s 43608 : put %name%lvl4 -t b -s 43608 : put %name%lvl5 -t b -s 43608 : dir : exit

@REM Cleanup
del %name%scr %name%main %name%lvl1 %name%lvl2 %name%lvl3 %name%lvl4 %name%lvl5 %name%ldrhc hcdskldr lvlldr.bin rbclvlldr1 rbclvlldr2