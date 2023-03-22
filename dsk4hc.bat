@REM will add all file in the output folder to a disk image for ICE FELIX HC.
@echo off
if not "%1"=="" (set input=output\%1) else (set input=output\*)
if not exist dizzyhc.dsk tools\hcdisk2 format dizzyhc.dsk -t 2 -y : exit
for %%f in (%input%) do tools\hcdisk2 open dizzyhc.dsk : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open dizzyhc.dsk : dir : exit