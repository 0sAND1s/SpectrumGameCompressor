rem @echo off
..\..\tools\hcdisk2 open %input% : get "T.DIZZY3" : get "T.DIZZY4" : exit
ren "T.DIZZY3" %name%.scr
ren "T.DIZZY4" %name%.main
