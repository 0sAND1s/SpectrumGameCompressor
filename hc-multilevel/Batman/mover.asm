		DEVICE ZXSPECTRUM48
	
	;Move game data to proper address and execute. Relocatable code.
Start:
	;BC = call address from BASIC.
	ld		hl, Data - Start
	or		a
	add		hl, bc	
	ld		de, $5B00
	ld		bc, $2700
	ldir
	di		
	im		2
	jp		$8100
	
Data:

	savebin "mover", Start, Data - Start