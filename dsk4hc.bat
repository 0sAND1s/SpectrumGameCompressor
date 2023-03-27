@REM will add all file in the output folder to a disk image for ICE FELIX HC.
@echo off
if not "%1"=="" (set input=output\%1) else (set input=output\*)
set output=gameshc.dsk
if not exist %output% tools\hcdisk2 format %output% -t 2 -y : exit
for %%f in (%input%) do tools\hcdisk2 open %output% : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open %output% : dir : exit