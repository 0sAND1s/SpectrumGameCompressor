   10 CLEAR VAL"24575": LOAD *"d";NOT PI;"midresscr"SCREEN$: LOAD *"d";NOT PI;"levelldr"CODE : RANDOMIZE USR VAL"32768": LOAD *"d";NOT PI;"midresmain"CODE
   20 BORDER NOT PI: PAPER NOT PI: INK VAL"2": CLS : PRINT #NOT PI; INK VAL"2";"Disk version for HC - 19.09.2023 -=george.chirtoaca@gmail.com=-"   
   30 LET m$="Unlimited Lives": GO SUB VAL"200": IF k$="y" THEN POKE VAL "36480",NOT PI
   40 LET m$="Unlimited Amo": GO SUB VAL"200": IF k$="y" THEN POKE VAL"39975",NOT PI
   50 LET m$="Unlimited Backpacks": GO SUB VAL"200": IF k$="y" THEN POKE VAL"39996",NOT PI
  100 RANDOMIZE USR VAL"31712"
  200 PRINT m$;"(y/n): ";
  210 PAUSE NOT PI: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN GO TO VAL"210"
  220 PRINT k$: RETURN