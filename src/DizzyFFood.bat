..\tools\hcdisk2 open %input% : get "FASTFOOD3" : get "FASTFOOD4" : exit
if not %skipScr%==1 (ren "FASTFOOD3" %name%.scr) else (del "FASTFOOD3")
ren "FASTFOOD4" %name%.main