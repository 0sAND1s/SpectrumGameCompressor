..\tools\hcdisk2 open %input% : get Seymour3 -n %name%.scr : get Seymour4 -n %name%.1.main : get Seymour5 -n %name%.2.main : exit
if %wantScr%==0 (
ren %name%.scr %name%o.scr
..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
copy /b %name%.1.main + %name%.2.main %name%.main
del %name%.1.main %name%.2.main