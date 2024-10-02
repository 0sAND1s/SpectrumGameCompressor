		DEVICE ZXSPECTRUM48
		
		org	$FE5B
		
start:			
		ld	a, ($719C)
		ld	(myfileidx), a
		ld	($600D), a		
		
		call	pagein
		ld	hl, myfile
		call	10830					
				
		ei
		jp	$FE93
		
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	9, "rtypelvl"
myfileidx:				
		db 	"0"
.end
		
