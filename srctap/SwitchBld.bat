set doCompress=0
..\tools\hcdisk2 open %input% : get SW.BLADE3 : get SW.BLADE4 : exit
call ..\tools\pack SW.BLADE3 %name%.1.packed
call ..\tools\pack SW.BLADE4 %name%.2.packed
del SW.BLADE3 SW.BLADE4