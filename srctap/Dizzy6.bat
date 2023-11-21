..\tools\hcdisk2 open %input% : get "Yolkfolk3" -n %name%.scr : get "Yolkfolk4" -n %name%.main : exit
if %wantScr%==0 (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)