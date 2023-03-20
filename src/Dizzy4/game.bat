rem @echo off
..\..\tools\hcdisk2 open %input% : get "Dizzy_43" : get Dizzy_44 : get Dizzy_45 : exit
ren "Dizzy_43" %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
copy /b Dizzy_44 + Dizzy_45 %name%.main
del Dizzy_44 Dizzy_45
