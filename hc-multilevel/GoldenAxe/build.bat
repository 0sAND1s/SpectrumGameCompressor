REM @echo off

set input=goldenax.tap
set name=goldaxe
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : get axe$ -n %name%scr : get axec0 -n %name%m : exit
for %%l in (A B D F H J L N) do ..\..\tools\hcdisk2 open %input% : get axe-%%l -n %name%l%%l : exit

@REM Assemble loaders
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr

@REM Put files to disk image
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp %name%ldr.bas %name%HC : put %name%scr -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%m -t b -s 28264 : put %name%ldr -t b -s 64768 : put %name%lA -t b -s 38400 : exit
for %%l in (B D F H J L N) do ..\..\tools\hcdisk2 open %output% : put %name%l%%l -t b -s 24064 : exit
..\..\tools\hcdisk2 open %output% : dir : exit

@REM Cleanup
del %name%scr %name%m %name%lA %name%lB %name%lD %name%lF %name%lH %name%lJ %name%lL %name%lN %name%ldr %levelldr%