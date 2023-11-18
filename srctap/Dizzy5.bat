..\tools\hcdisk2 open %input% : get "-=Dizzy53" -n %name%.scr : get "-=Dizzy54" -n %name%.main : exit
if %wantScr%==0 (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)