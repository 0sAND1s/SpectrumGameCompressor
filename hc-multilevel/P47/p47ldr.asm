		DEVICE ZXSPECTRUM48
		
		org	$825E
		
start:		
		di
		ld	a, ($750D)	
		push	af
		add	$5E
		ld	($6007), a
		pop	af
		add	'0'
		ld	(myfileidx), a
		call	pagein
		ld	hl, myfile
		call	10830
		
		ei
		jr	$82A3
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	7, "P47lvl"
myfileidx:				
		db 	"0"
.end

		savebin	"p47ldr",start,.end-start
