rem @echo off
set blkScr="dizzy5scr"
set blkMain="dizzy5main"
..\..\tools\hcdisk2 open %input% : get "-=Dizzy5=3" : get "-=Dizzy5=4" : exit
ren "-=Dizzy5=3" %blkScr%
ren "-=Dizzy5=4" %blkMain%