rem @echo off
set blkScr="DIZZY 33"
set blkMain="DIZZY 34"
..\..\tools\hcdisk2 open %input% : get %blkScr% : get %blkMain% : exit
