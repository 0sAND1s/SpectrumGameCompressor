..\tools\hcdisk2 open %input% : get "DDTR3" : get "DDTR4" : exit
if not %skipScr%==1 (ren "DDTR3" %name%.scr) else (del "DDTR3")
ren "DDTR4" %name%.main