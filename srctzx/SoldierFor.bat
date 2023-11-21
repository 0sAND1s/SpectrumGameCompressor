..\tools\hcdisk2 open %input% : get sofs -n %name%.scr : get sofc -n %name%.main : exit
set fsize=0

if [%wantscr%]==[1] (
..\tools\hcdisk2 screen order column %name%.scr %name%c.scr : exit
call ..\tools\pack.bat %name%c.scr %name%.scr.zx0
call :getfilesize %name%.scr.zx0
)
set scrsize=%fsize%

call ..\tools\pack %name%.main %name%.main.zx0
call :getfilesize %name%.main.zx0

..\tools\sjasmplus %name%.asm --raw=%name%ldr.bin -DBAUD=%baud% -DMAIN_SIZE=%fsize% -DSCR_SIZE=%scrsize%

..\tools\hcdisk2 format %output% -y : open %output% : bin2bas var %name%ldr.bin %name% : exit
if [%wantscr%]==[1] ..\tools\hcdisk2 open %output% : put %name%.scr.zx0 -turbo %baud% : exit
..\tools\hcdisk2 open %output% : put %name%.main.zx0 -turbo %baud% : dir : exit

del %name%ldr.bin %name%.scr %name%c.scr %name%.main %name%.main.zx0 %name%.scr.zx0
goto :EOF

:getfilesize
set fsize=%~z1
exit /b
