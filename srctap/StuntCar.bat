..\tools\hcdisk2 open %input% : get "stunt ca4" -n %name%.main1 : bincut %name%.main1 %name%.main2 0 39168 : bitmirror %name%.main2 %name%.main : exit
del %name%.main1 %name%.main2