..\tools\hcdisk2 open %input% : get "And_A_Half" -n %name%.1 : get "Dizzy_3.3" -n %name%.2 : bincut %name%.1 %name%c.1 106 : exit
call ..\tools\pack %name%c.1 %name%.scr.zx0
call ..\tools\pack %name%.2 %name%.main.zx0
del %name%.2 %name%c.1 %name%.1

call :getfilesize %name%.scr.zx0
set scrsize=%fsize%
call :getfilesize %name%.main.zx0
..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE1=%scrsize% %lst%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open %output% : put %name%.scr.zx0 -turbo %baud% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

goto :EOF

:getfilesize
set fsize=%~z1
exit /b


