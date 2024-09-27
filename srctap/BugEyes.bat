..\tools\hcdisk2 open %input% : get BUG-EYES3 -n %name%.scr : exit
for /L %%i in (8,1,13) do ..\tools\hcdisk2 open %input% : get BUG-EYES%%i -n %name%%%i.part : exit
if %wantScr%==0 del %name%.scr
copy /b %name%13.part+%name%8.part+%name%9.part+%name%10.part+%name%11.part+%name%12.part %name%.main
del %name%*.part