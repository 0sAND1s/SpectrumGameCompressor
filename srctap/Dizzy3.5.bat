set doCompress=0
..\tools\hcdisk2 open %input% : get "And_A_Half" -n %name%.1 : get "Dizzy_3.3" -n %name%.2 : bincut %name%.1 %name%c.1 106 : exit
call ..\tools\pack %name%c.1 %name%.1.packed
call ..\tools\pack %name%.2 %name%.2.packed
del %name%.2 %name%c.1 %name%.1