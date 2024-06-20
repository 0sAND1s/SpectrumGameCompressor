..\tools\hcdisk2 open %input% : get BaSh3 -n %name%.scr : exit
for /l %%f in (4,1,13) do ..\tools\hcdisk2 open %input% : get BaSh%%f : exit
ren BaSh4 %name%.main
for /l %%f in (5,1,13) do copy /b %name%.main+BaSh%%f %name%.main
if %wantScr%==0 del %name%.scr
del /Q BaSh*