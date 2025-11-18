..\tools\hcdisk2 open %input% : get ERIC1 -n %name%.main1 : bincut %name%.main1 %name%.main2 46 : bitxor %name%.main2 %name%.main : exit
del %name%.main1 %name%.main2
