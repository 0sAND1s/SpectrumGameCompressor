..\tools\hcdisk2 open %input% : get "KWIKSNAX2" : get "KWIKSNAX3" : exit
if not %skipScr%==1 (ren "KWIKSNAX2" %name%.scr) else (del "KWIKSNAX2")
ren "KWIKSNAX3" %name%.main