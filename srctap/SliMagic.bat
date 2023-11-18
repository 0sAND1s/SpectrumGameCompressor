set doCompress=0
..\tools\hcdisk2 open %input% : get MAGIC!3 -n %name%.1 : get MAGIC!4 -n %name%.2 : exit
call ..\tools\pack %name%.1 %name%.1.packed
call ..\tools\pack %name%.2 %name%.2.packed
del %name%.1 %name%.2