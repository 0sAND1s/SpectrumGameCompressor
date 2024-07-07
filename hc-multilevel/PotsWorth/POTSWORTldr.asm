		DEVICE ZXSPECTRUM48
		
		org	$AD81
		
start:						
		ld	a, ($EF6F)	
		ld	($DA1B), a
		add	'0'
		ld	(myfileidx), a		
		
		call	pagein
		ld	hl, myfile
		call	10830					
		
		;Copy level header into place.
		ld	hl, $5B00
		ld	de, $DA1B
		ld	bc, 88
		ldir
		
		;Copy level into place, using the biggest size.
		ld	de, $5B00
		ld	bc, 20721
		ldir
		
		jp	$ADF0
		
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	9, "POTSWORT"
myfileidx:				
		db 	"0"
.end
		
