		DEVICE ZXSPECTRUM48
		
		org	$F01F
		
start:						
		add		'0'
		ld		(myfileidx), a		
		ld		($F04B), a
		
		call	pagein
		ld		hl, myfile
		call	10830					
		
		jp		$60B4		
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	10, "batmanlvl"
myfileidx:				
		db 	"0"
.end

		savebin	"batmanldr1",start,.end-start
