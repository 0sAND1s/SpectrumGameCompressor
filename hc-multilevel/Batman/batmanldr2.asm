		DEVICE ZXSPECTRUM48
		
		org	$6237
		
start:					
		ld		a, ($6115)
		add		'0'
		ld		(myfileidx), a						
		
		call	pagein
		ld		hl, myfile
		call	10830					
		
		ld		a, (myfileidx)		
		cp		'2'
		ld		a, $EE
		jr		nz, NotLevel2
		ld		a, $DE
NotLevel2:		
		ld		i, a
		jp		$600A
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	10, "batmanlvl"
myfileidx:				
		db 	"0"
.end

		savebin	"batmanldr2",start,.end-start
