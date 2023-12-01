@REM will add all file in the output folder to a disk image for TR-DOS.
@echo off
if not "%1"=="" (set input=output\%1) else (set input=output\*.tap)
set output=games.trd
REM Create output only if it doesn't exist yet, so that games can be added one by one to the same image.
if not exist %output% tools\hcdisk2 format %output% -t 11 -y : exit
for %%f in (%input%) do tools\hcdisk2 open %output% : tapimp "%%f" : exit
tools\hcdisk2 open %output% : dir : exit