..\tools\hcdisk2 open %input% : get "DIZZY 23" : get "DIZZY 24" : exit
ren "DIZZY 23" %name%.scr
ren "DIZZY 24" %name%.main
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
