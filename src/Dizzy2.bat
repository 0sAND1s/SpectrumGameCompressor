..\tools\hcdisk2 open %input% : get "T.DIZZY3" : get "T.DIZZY4" : exit
ren "T.DIZZY3" %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
ren "T.DIZZY4" %name%.main
