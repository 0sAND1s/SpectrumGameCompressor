rem @echo off
set blkScr="Dizzy_43"
set blkMain="dizzy4main"
..\..\tools\hcdisk2 open %input% : get %blkScr% : get Dizzy_44 : get Dizzy_45 : exit
copy /b Dizzy_44 + Dizzy_45 %blkMain%
del Dizzy_44 Dizzy_45
