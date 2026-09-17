REM @echo off
cls
setlocal enabledelayedexpansion

set name=Shinobi
set input=%name%.TZX
set output=%name%HC.DSK
set levelldr=levelldr

@REM Extract blobs
..\..\tools\hcdisk2 open %input% : dir : get screen -n %name%SCR : get code -n %name%Main : exit

set i=0
for /L %%l in (6,2,22) do (
..\..\tools\hcdisk2 open %input% : get SHINOBI%%l -n %name%L!i! : exit
set /A i=!i!+1
)

@REM Assemble loader
..\..\tools\sjasmplus ..\levelloader.asm --raw=%levelldr%

@REM Patch main game block with disk loader for level 0
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$EE5E -DLVL_JMP=$86C6 -DLVL_IDX=$30 -DINVULN_ADDR1=$ABCE --lst=%name%ldr.lst
..\..\tools\hcdisk2 binpatch %name%Main %name%ldr 12076 : exit
@REM set 48K flag
fsutil file setZeroData offset=10440 length=1 %name%Main

@REM Put files to disk image
echo 10 LOAD *"d";0;"ShinobiHC" > run.bas
..\..\tools\hcdisk2 format %output% -t 2 -y : open %output% : basimp run.bas run 10 : basimp %name%ldr.bas %name%HC : put %name%SCR -t b -s 16384 : put %levelldr% -t b -s 32768 : put %name%Main -t b -s 48946 : exit

@REM patch disk loader in block level 0, for level 1
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$893A -DLVL_JMP=$9C40 -DLVL_IDX=$31 --lst=%name%L0.lst
hcdisk2 binpatch %name%L0 %name%ldr 11834 : exit
@REM POKE for lives
@REM fsutil file setZeroData offset=11419 length=1 %name%L0
hcdisk2 open %output% : put %name%L0 -t b -s 23296 : exit

@REM patch disk loader in block level 1, for level 2
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$9DDC -DLVL_JMP=$86C6 -DLVL_IDX=$32 -DINVULN_ADDR1=$ACE3 --lst=%name%L1.lst
hcdisk2 binpatch %name%L1 %name%ldr 17116 : exit
hcdisk2 open %output% : put %name%L1 -t b -s 23296 : exit

@REM patch disk loader in block level 2, for level 3
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$895A -DLVL_JMP=$9C40 -DLVL_IDX=$33 --lst=%name%L2.lst
hcdisk2 binpatch %name%L2 %name%ldr 11866 : exit
@REM POKE for lives
@REM fsutil file setZeroData offset=11403 length=1 %name%L2
@REM NOP out instruction that overwrites our level loader
fsutil file setZeroData offset=11832 length=3 %name%L2
hcdisk2 open %output% : put %name%L2 -t b -s 23296 : exit

@REM patch disk loader in block level 3, for level 4
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$9DDC -DLVL_JMP=$85BA -DLVL_IDX=$34 -DINVULN_ADDR1=$AC19 -DINVULN_ADDR2=$B840 --lst=%name%L3.lst
hcdisk2 binpatch %name%L3 %name%ldr 17116 : exithcdisk2 open %output% : put %name%L3 -t b -s 23296 : exit

@REM patch disk loader in block level 4, for level 5
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$884F -DLVL_JMP=$9C40 -DLVL_IDX=$35 --lst=%name%L4.lst
hcdisk2 binpatch %name%L4 %name%ldr 11599 : exit
@REM POKE for lives
@REM fsutil file setZeroData offset=11138 length=1 %name%L4
hcdisk2 open %output% : put %name%L4 -t b -s 23296 : exit

@REM patch disk loader in block level 5, for level 6
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$9DDC -DLVL_JMP=$9C40 -DLVL_IDX=$36 -DINVULN_ADDR1=$AE5B -DINVULN_ADDR2=$8794 --lst=%name%L5.lst
hcdisk2 binpatch %name%L5 %name%ldr 17116 : exit
hcdisk2 open %output% : put %name%L5 -t b -s 23296 : exit

@REM patch disk loader in block level 6, for level 7
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$8963 -DLVL_JMP=$86C6 -DLVL_IDX=$37 --lst=%name%L6.lst
hcdisk2 binpatch %name%L6 %name%ldr 11875 : exit
@REM POKE for lives
@REM fsutil file setZeroData offset=11414 length=1 %name%L6
hcdisk2 open %output% : put %name%L6 -t b -s 23296 : exit

@REM patch disk loader in block level 7, for level 8
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$9DDC -DLVL_JMP=$9C40 -DLVL_IDX=$38 -DINVULN_ADDR1=$AD79 -DINVULN_ADDR2=$866A --lst=%name%L7.lst
hcdisk2 binpatch %name%L6 %name%ldr 17116 : exit
hcdisk2 open %output% : put %name%L7 -t b -s 23296 : exit

@REM patch disk loader in block level 8, for level 0
..\..\tools\sjasmplus %name%ldr.asm --raw=%name%ldr -DLVL_ORG=$882C -DLVL_JMP=$859D -DLVL_IDX=$30 -DINVULN_ADDR1=$ABCE --lst=%name%L8.lst
hcdisk2 binpatch %name%L6 %name%ldr 11564 : exit
@REM POKE for lives
@REM fsutil file setZeroData offset=11116 length=1 %name%L8
hcdisk2 open %output% : put %name%L8 -t b -s 23296 : exit

hcdisk2 open %output% : dir : exit

@REM Cleanup
del %name%scr %name%main %name%L? %name%ldr %levelldr% *.lst run.bas