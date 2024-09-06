..\tools\hcdisk2 open %input% : get SATAN-I3 -n %name%.scr1 : bincut %name%.scr1 %name%.scr 58 : get SATAN-I4 -n %name%.main : exit
del %name%.scr1
if %wantScr%==0 del %name%.scr