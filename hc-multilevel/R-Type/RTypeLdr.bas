   10 CLEAR VAL"28670": LOAD *"d";NOT PI;"rtypescr"SCREEN$: LOAD *"d";NOT PI;"levelldr"CODE : RANDOMIZE USR VAL"32768": LOAD *"d";NOT PI;"rtypemain1"CODE: LOAD*"d";NOT PI;"rtypemain2"CODE
   20 BORDER NOT PI: PAPER NOT PI: INK VAL"2": CLS : PRINT #NOT PI; INK VAL"2";"Disk version for HC - 02.10.2024 -=george.chirtoaca@gmail.com=-"   
   30 LET m$="Unlimited Lives": GO SUB VAL"200": IF k$="y" THEN POKE VAL "37374",NOT PI
   40 LET m$="Imunity": GO SUB VAL"200": IF k$="y" THEN POKE VAL "38253",VAL "58": POKE VAL"38260",VAL"58": POKE VAL"50049",NOT PI
   50 LET m$="Level(1-8)": GO SUB VAL"200": IF k$<"1" OR k$>"8" THEN GO TO VAL "100"
   60 POKE VAL "29084", CODE k$ - VAL "1"
  100 RANDOMIZE USR VAL "34301"
  200 PRINT m$;,": ";:PAUSE NOT PI: LET k$=INKEY$: PRINT k$: RETURN