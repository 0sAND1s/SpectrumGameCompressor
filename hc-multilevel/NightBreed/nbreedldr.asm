		DEVICE ZXSPECTRUM48
		
		org	$EAD2
		
start:		
		ld		a, l
		add		'0'
		ld		(myfileidx), a		
		call	pagein
		ld		hl, myfile
		call	10830						
		
		jr		$EB39
				
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	10, "nbreedlvl"
myfileidx:				
		db 	"0"
.end

		savebin	"nbreedldr",start,.end-start
