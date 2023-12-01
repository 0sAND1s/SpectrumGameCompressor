@REM will add all file in the output folder to a disk image for Spectrum +3.
rem @echo off
if not "%1"=="" (set input=output\%1) else (set input=output\*.tap)
set output=gamesplus3.dsk
if not exist %output% tools\hcdisk2 format %output% -t 5 -y : exit
for %%f in (%input%) do tools\hcdisk2 open %output% -t 1 : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open %output% -t 1 : dir : exit