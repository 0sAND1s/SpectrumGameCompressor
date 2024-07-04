set name=Venturama
set input=..\input\%name%.tzx
set output=..\output\%name%.tap

..\tools\hcdisk2 open %input% : get VENTURAM5 -n %name%.scr : get VENTURAM6 -n %name%.main : exit
..\tools\hcdisk2 format %output% -y : open %output% : basimp %name%.bas : put %name%.scr -t b -s 16384 -n "ventus" : put %name%.main -t b -s 24465 -n "ventuc" : dir : exit
del /Q %name%.scr %name%.main
