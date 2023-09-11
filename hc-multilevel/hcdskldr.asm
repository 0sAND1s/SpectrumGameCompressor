	device	zxspectrum48

pageout:	equ	$700

		org	32768
start:		
		;GC: Determine current drive and patch it in the level loader, to allow loading levels from drive B: too.
		ld a, 12
		ld ($5CEF), a
		rst 08
		defb 57
		ld	(loadend-17), a

		di
		call	pagein
		ld	hl,loadercode
		ld	de,10830
		ld	bc,loadend-loadercode-1
		ldir
		ld	hl,10753
		ld	(10751),hl	;adresa rutinei de tratare INT
		ld	a,201		;ret
		ld	(10753),a
		ei
		jp	pageout

pagein:		ld	hl,0
		push	hl
		jp	8

loadercode:	incbin	"lvlldr.bin"
loadend:
.end

		savebin	"hcdskldr",start,.end-start
