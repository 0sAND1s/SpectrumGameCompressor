rem We need to compress 3 distinct blocks for this one.
..\tools\hcdisk2 open %input% : get DIZZY6 : get DIZZY4 : get DIZZY7 : get DIZZY8 : exit
copy /b DIZZY6 + DIZZY4 %name%.main
call ..\tools\pack %name%.main %name%.1.packed
call ..\tools\pack DIZZY7 %name%.2.packed
call ..\tools\pack DIZZY8 %name%.3.packed
del DIZZY4 DIZZY6 DIZZY7 DIZZY8

copy /b %name%.1.packed+%name%.2.packed+%name%.3.packed %name%.main.zx0
if NOT [%develop%]==[1] (del *.packed) else (set lst=--lst)
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% %lst%
..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

del %name%.bin %name%.main.zx0 %name%.lst %name%.main
goto :EOF

:getfilesize
set fsize=%~z1
exit /b
