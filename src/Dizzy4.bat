..\tools\hcdisk2 open %input% : get "Dizzy_43" -n %name%.scr : get Dizzy_44 : get Dizzy_45 : exit
if %wantScr%==0 (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
copy /b Dizzy_44 + Dizzy_45 %name%.main
del Dizzy_44 Dizzy_45
