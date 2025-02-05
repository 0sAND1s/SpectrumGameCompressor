..\tools\hcdisk2 open %input% : get Renegade$ -n %name%.scr : get Renegade.c -n %name%.1.main : get Renegade.x -n %name%.2.main : exit
copy /b %name%.1.main + %name%.2.main %name%.main
del %name%.1.main %name%.2.main
set fsize=0

if [%wantscr%]==[1] (
..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit
call ..\tools\pack.bat %name%c.scr %name%.scr.zx0
call :getfilesize %name%.scr.zx0
)
set scrsize=%fsize%

call ..\tools\pack %name%.main %name%.main.zx0
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE=%scrsize% %lst%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
if [%wantscr%]==[1] ..\tools\hcdisk2 open %output% : put %name%.scr.zx0 -turbo %baud% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

goto :EOF

:getfilesize
set fsize=%~z1
exit /b
