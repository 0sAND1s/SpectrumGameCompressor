   10 LOAD *"d";0;"rbcscr"SCREEN$
   12 LOAD *"d";0;"hcdskldr"CODE : RANDOMIZE USR 32768
   15 LOAD *"d";0;"rbcmain"CODE
   25 LOAD *"d";0;"rbclvlldr1"CODE : LOAD *"d";0;"rbclvlldr2"CODE
   30 BORDER 0: PAPER 0: INK 2: CLS : PRINT #0; INK 2;"Disk version for HC - 14.09.2022 -=george.chirtoaca@gmail.com=-"
   40 LET m$="Unlimited energy": GO SUB 200: IF k$="y" THEN  POKE 39540,201
   50 LET m$="Unlimited time": GO SUB 200: IF k$="y" THEN  POKE 45722,201
   60 LET m$="Unlimited amo": GO SUB 200: IF k$="y" THEN  POKE 38450,0
   90 POKE 33079,24: POKE 33080,6: REM These POKEs are required if running on 128K machine, to disable paging and make the game work as in 48K.
  100 RANDOMIZE USR 33049
  200 PRINT m$;"(y/n): ";
  210 PAUSE 0: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN  GO TO 210
  220 PRINT k$: RETURN