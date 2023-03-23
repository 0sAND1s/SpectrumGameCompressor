..\tools\hcdisk2 open %input% : get "DIZZY 33" -n %name%.scr : get "DIZZY 34" -n %name%.main : exit
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)