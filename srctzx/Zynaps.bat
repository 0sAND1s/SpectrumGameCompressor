..\tools\hcdisk2 open %input% : get code -n %name%.main : exit
set fsize=0
set scrsize=%fsize%

call ..\tools\pack %name%.main %name%.main.zx0
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE=%scrsize% %lst%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

goto :EOF

:getfilesize
set fsize=%~z1
exit /b
