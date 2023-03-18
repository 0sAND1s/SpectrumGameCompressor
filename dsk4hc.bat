tools\hcdisk2 format dizzyhc.dsk -t 2 -y : exit
for %%f in (output\*) do tools\hcdisk2 open dizzyhc.dsk : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open dizzyhc.dsk : dir : exit