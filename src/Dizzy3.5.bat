set doCompress=0
..\tools\hcdisk2 open %input% : get "And_A_Half" : get "Dizzy_3..3" : bincut "And_A_Half" %name%.1 106 : exit
call ..\tools\pack %name%.1 %name%.1.packed
call ..\tools\pack "Dizzy_3..3" %name%.2.packed
del "And_A_Half" "Dizzy_3..3" %name%.1