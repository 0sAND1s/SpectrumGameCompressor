if [%name%]==[] set name=Zynaps

..\tools\hcdisk2 open %input% : get code -n %name%.main : exit
set fsize=0
set scrsize=%fsize%

call ..\tools\pack %name%.main %name%.main.zx0
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE=%scrsize%

..\tools\hcdisk2 format ..\output\%name%.tzx -y : open ..\output\%name%.tzx : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open ..\output\%name%.tzx : put %name%.main.zx0 -turbo %baud% : dir : exit

del %name%.bin %name%.scr %name%c.scr %name%.main %name%.main.zx0 %name%.scr.zx0
goto :EOF

:getfilesize
set fsize=%~z1
exit /b
