   10 CLEAR VAL"28670": LOAD *"d";NOT PI;"rtypescr"SCREEN$: LOAD *"d";NOT PI;"levelldr"CODE : RANDOMIZE USR VAL"32768": LOAD *"d";NOT PI;"rtypemain1"CODE: LOAD*"d";NOT PI;"rtypemain2"CODE
   20 BORDER NOT PI: PAPER NOT PI: INK VAL"2": CLS : PRINT #NOT PI; INK VAL"2";"Disk version for HC - 30.09.2023 -=george.chirtoaca@gmail.com=-"   
   30 LET m$="Unlimited Lives": GO SUB VAL"200": IF k$="y" THEN POKE VAL "37374",NOT PI
   40 LET m$="Imunity": GO SUB VAL"200": IF k$="y" THEN POKE VAL "38253",VAL "58": POKE VAL"38260",VAL"58": POKE VAL"50049",VAL"0"
  100 RANDOMIZE USR VAL "34301"
  200 PRINT m$;"(y/n): ";
  210 PAUSE NOT PI: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN GO TO VAL"210"
  220 PRINT k$: RETURN