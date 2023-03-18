@echo off
tools\hcdisk2 format dizzyplus3.dsk -t 5 -y : exit
for %%f in (output\*) do tools\hcdisk2 open dizzyplus3.dsk -t 1 : tapimp "%%f" * -convldr : exit
tools\hcdisk2 open dizzyplus3.dsk -t 1 : dir : exit