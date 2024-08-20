..\tools\hcdisk2 open %input% : get Chronos4 -n %name%.main1 : bincut %name%.main1 %name%.scr 0 6912  : bincut %name%.main1 %name%.main 8600 39992 : exit
if %wantScr%==0 del %name%.scr
del %name%.main1