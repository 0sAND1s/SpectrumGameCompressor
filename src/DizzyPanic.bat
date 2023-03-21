..\tools\hcdisk2 open %input% : get "Dizzy4" : get "Dizzy5" : exit
if not %skipScr%==1 (ren "Dizzy4" %name%.scr) else (del "Dizzy4")
ren "Dizzy5" %name%.main