   10 CLEAR 30000: LOAD *"d";0;"batmanscr"SCREEN$ : LOAD *"d";0;"hcdskldr"CODE : RANDOMIZE USR 32768: LOAD *"d";0;"batmanmain"CODE
   20 BORDER 0: PAPER 0: INK 2: CLS : PRINT #0; INK 2;"Disk version for HC - 11.09.2023 -=GEORGE.CHIRTOACA@GMAIL.COM=-": PRINT "Hold keys M+I+C+K to skip level"
   25 LET o=40000-23296+19
   30 LET m$="Unlimited lives": GO SUB 200: IF k$="y" THEN POKE 24973+o,0: POKE 24974+o,195
   40 LET m$="Unlimited time": GO SUB 200: IF k$="y" THEN POKE 24347+o,0 
   50 LET m$="Unlimited energy": GO SUB 200: IF k$="y" THEN POKE 24884+o,201
  100 RANDOMIZE USR 40000
  200 PRINT m$;" (y/n)?: ";
  210 PAUSE 0: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN  GO TO 210
  220 PRINT k$: RETURN