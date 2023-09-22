		DEVICE ZXSPECTRUM48
		
		org	$7D49
		
start:						
		ld		a, ($7E00)		
		ld		(myfileidx), a				
		
		call	pagein
		ld		hl, myfile
		call	10830					
		
		jp		$82F3		
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	10, "midreslvl"
myfileidx:				
		db 	"0"
.end
		
