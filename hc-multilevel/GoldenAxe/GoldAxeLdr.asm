		DEVICE ZXSPECTRUM48
		
		org	64768
		
start:			
		add		'A'
		ld		(myfileidx), a				
		ex		af, af'
		
		call	pagein
		ld		hl, myfile
		call	10830					
				
		ex		af, af'
		;On last level jump, don't ret.
		cp		'N'
		jp		z, 24064
		
		;Check if poke required on block A for unlimited lives.
		cp		'A'
		ret		nz
				
		;Poke with default value, unless patched from BASIC.
		ld		a, 53
		ld		(43010), a
		ret
		
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	9, "goldaxel"
myfileidx:				
		db 	"A"
.end
		
