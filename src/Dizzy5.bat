..\tools\hcdisk2 open %input% : get "-=Dizzy5=3" : get "-=Dizzy5=4" : exit
ren "-=Dizzy5=3" %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
ren "-=Dizzy5=4" %name%.main