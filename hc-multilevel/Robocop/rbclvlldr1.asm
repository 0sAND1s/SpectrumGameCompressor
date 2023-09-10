		DEVICE ZXSPECTRUM48
		
		org	$814C
		
start:				
		ld		(myfileidx), a		
		call	pagein
		ld		hl, myfile
		call	10830					
		
		jr		$81C4
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	7, "rbclvl"
myfileidx:				
		db 	"0"
.end

		savebin	"rbclvlldr1",start,.end-start
