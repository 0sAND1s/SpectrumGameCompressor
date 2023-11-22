..\tools\hcdisk2 open %input% : get "DIZZY 33" -n %name%.scr : get "DIZZY 34" -n %name%.main : exit

if [%wantscr%]==[0] (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
del %name%o.scr
)

..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit
call ..\tools\pack.bat %name%c.scr %name%.scr.zx0
call :getfilesize %name%.scr.zx0
set scrsize=%fsize%

call ..\tools\pack %name%.main %name%.main.zx0
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE=%scrsize% %lst%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%.bin %name% : exit
..\tools\hcdisk2 open %output% : put %name%.scr.zx0 -turbo %baud% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

goto :EOF

:getfilesize
set fsize=%~z1
exit /b
