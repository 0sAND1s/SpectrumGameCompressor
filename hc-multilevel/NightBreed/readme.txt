Basic loader:
002BH   LD      IX,4000H
002FH   LD      DE,1B00H
0032H   CALL    5D17H
0035H   LD      IX,5B00H
0039H   LD      DE,0005H
003CH   CALL    5D17H
003FH   LD      IX,7C2EH
0043H   LD      DE,48BCH
0046H   CALL    5D17H
0049H   JP      5D1EH

Level Loader: EAD2, L = level index
Loader patch offset: 17823
Level address table: EB98, format: level char, address, length
30, 7C2E, 48BC
31, 6400, 8000
32, 6400, 8000
33, 6400, 8000
34, 8A3E, 59C2
35, 8A3E, 59C2
36, 9C40, 47C0
