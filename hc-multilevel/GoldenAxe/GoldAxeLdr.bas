   10 CLEAR VAL"28263": LOAD *"d";NOT PI;"goldaxescr"SCREEN$: LOAD *"d";NOT PI;"levelldr"CODE : RANDOMIZE USR VAL"32768": LOAD *"d";NOT PI;"goldaxem"CODE: LOAD*"d";NOT PI;"goldaxeldr"CODE
   20 BORDER NOT PI: PAPER NOT PI: INK VAL"2": CLS : PRINT #NOT PI; INK VAL"2";"Disk version for HC - 29.09.2023 -=george.chirtoaca@gmail.com=-"   
   30 LET m$="Unlimited Lives": GO SUB VAL"200": IF k$="y" THEN POKE VAL "64793",VAL "182"
  100 RANDOMIZE USR VAL "57709"
  200 PRINT m$;"(y/n): ";
  210 PAUSE NOT PI: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN GO TO VAL"210"
  220 PRINT k$: RETURN