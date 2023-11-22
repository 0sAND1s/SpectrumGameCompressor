..\tools\hcdisk2 open %input% : get "ROB SCREEN" -n %name%.scr : get "ROBIN HO3" -n %name%.main : exit
if %wantScr%==0 (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 1x3x21x30 %name%o.scr %name%.scr : exit
)