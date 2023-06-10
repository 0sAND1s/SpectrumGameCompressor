..\tools\hcdisk2 open %input% : get Renegade.c -n %name%.1.main : get Renegade.x -n %name%.2.main : exit
copy /b %name%.1.main + %name%.2.main %name%.main
del %name%.1.main %name%.2.main