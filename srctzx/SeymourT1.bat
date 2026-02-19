set doCompress=0
..\tools\hcdisk2 open %input% : get SEYMOUR3 -n %name%.1 : get SEYMOUR4 -n %name%.2 : exit
call ..\tools\pack %name%.1 %name%.scr.zx0
call ..\tools\pack %name%.2 %name%.main.zx0
del %name%.1 %name%.2

call :getfilesize1 %name%.scr.zx0
set scrsize=%fsize%
call :getfilesize1 %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE1=%scrsize% %lst%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open %output% : put %name%.scr.zx0 -turbo %baud% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

set customProcess=1
goto :EOF

:getfilesize1
set fsize=%~z1
exit /b