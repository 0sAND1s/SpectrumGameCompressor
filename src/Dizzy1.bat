..\tools\hcdisk2 open %input% : get DIZZY3 : get DIZZY4 : exit
ren DIZZY3 %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 5x1x22x31 %name%o.scr %name%.scr : exit
)
ren DIZZY4 %name%.main