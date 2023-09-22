   10 CLEAR 34815: LOAD *"d";0;"ren2scr"SCREEN$ : LOAD *"d";0;"ren2main"CODE
   20 LOAD *"d";0;"levelldr"CODE : RANDOMIZE USR 32768
   25 BORDER 0: PAPER 0: INK 2: CLS : PRINT #0; INK 2;"Disk version for HC - 11.09.2022 -=GEORGE.CHIRTOACA@GMAIL.COM=-"
   30 LET m$="Turbo speed": GO SUB 200: IF k$="y" THEN  POKE 62769,0
   40 LET m$="Unlimited lives": GO SUB 200: IF k$="y" THEN  POKE 59911,182
   50 LET m$="Unlimited time": GO SUB 200: IF k$="y" THEN  POKE 62936,0
   60 LET m$="Skip level with pause": GO SUB 200: IF k$="y" THEN  LET a=59353: POKE a,195: POKE a+1,228: POKE a+2,214
  100 RANDOMIZE USR 40576
  200 PRINT m$;" (y/n)?: ";
  210 PAUSE 0: LET k$=INKEY$: IF k$<>"y" AND k$<>"n" THEN  GO TO 210
  220 PRINT k$: RETURN