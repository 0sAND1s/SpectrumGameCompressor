..\tools\hcdisk2 open %input% : get "T.DIZZY3" -n %name%.scr : get "T.DIZZY4" -n %name%.main : exit
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
