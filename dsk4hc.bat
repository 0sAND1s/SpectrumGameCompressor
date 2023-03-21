@REM will add all file in the output folder to a disk image for ICE FELIX HC.
tools\hcdisk2 format dizzyhc.dsk -t 2 -y : exit
for %%f in (output\*) do tools\hcdisk2 open dizzyhc.dsk : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open dizzyhc.dsk : dir : exit