		DEVICE ZXSPECTRUM48
		
		org	$5EBA
		
start:		
;		di
				
		ld		a, ($D697)
		ld		(myfileidx), a
		ld		($D6A7), a
		call	pagein
		ld		hl, myfile
		call	10830
						
;		ei		
		
		jr		$5EEC
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	8, "ren2lvl"
myfileidx:				
		db 	"0"
.end

		savebin	"ren2ldr",start,.end-start
