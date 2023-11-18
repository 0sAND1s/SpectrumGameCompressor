rem We need to compress 3 distinct blocks for this one.
set doCompress=0
..\tools\hcdisk2 open %input% : get DIZZY6 : get DIZZY4 : get DIZZY7 : get DIZZY8 : exit
copy /b DIZZY6 + DIZZY4 %name%.main
call ..\tools\pack %name%.main %name%.1.packed
call ..\tools\pack DIZZY7 %name%.2.packed
call ..\tools\pack DIZZY8 %name%.3.packed
del DIZZY4 DIZZY6 DIZZY7 DIZZY8