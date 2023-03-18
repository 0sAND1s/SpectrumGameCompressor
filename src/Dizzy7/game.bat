rem @echo off
rem set blkScr="dizzy7"
rem set blkMain="dizzy7main.bin"
set dontCompress=1
..\..\tools\hcdisk2 open %input% : get DIZZY6 : get DIZZY4 : get DIZZY7 : get DIZZY8 : exit
copy /b DIZZY6 + DIZZY4 DIZZY7.bin
call ..\..\tools\pack DIZZY7.bin DIZZY7.bin.exo
call ..\..\tools\pack DIZZY7 DIZZY7.exo
call ..\..\tools\pack DIZZY8 DIZZY8.exo
del DIZZY4 DIZZY6 DIZZY7 DIZZY8