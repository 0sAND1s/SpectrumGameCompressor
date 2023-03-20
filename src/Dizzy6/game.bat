rem @echo off
..\..\tools\hcdisk2 open %input% : get "Yolkfolk.3" : get "Yolkfolk.4" : exit
ren "Yolkfolk.3" %name%.scr
if "%cropScr%"=="1" (
ren %name%.scr %name%o.scr
..\..\tools\hcdisk2 screen blank 6x1x22x31 %name%o.scr %name%.scr : exit
)
ren "Yolkfolk.4" %name%.main