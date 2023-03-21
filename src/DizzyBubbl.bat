..\tools\hcdisk2 open %input% : get "Bubbles2" : get "Bubbles4" : exit
if not %skipScr%==1 (ren "Bubbles2" %name%.scr) else (del "Bubbles2")
ren "Bubbles4" %name%.main