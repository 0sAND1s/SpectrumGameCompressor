		DEVICE ZXSPECTRUM48
		
		org	$66BC
		
start:				
		ld		(myfileidx), a		
		call	pagein
		ld		hl, myfile
		call	10830					
		
		jr		$ + $27
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	7, "rbclvl"
myfileidx:				
		db 	"0"
.end

		savebin	"rbclvlldr2",start,.end-start
