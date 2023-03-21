..\tools\hcdisk2 open %input% : get "DIZZY 33" : get "DIZZY 34" : exit
ren "DIZZY 33" %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
ren "DIZZY 34" %name%.main