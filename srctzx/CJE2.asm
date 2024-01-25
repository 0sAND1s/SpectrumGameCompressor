	DEVICE ZXSPECTRUM48

game_start		equ	24576
game_end		equ	$FFFE
game_entry		equ	$B76F
game_stack		equ	$5C00
;POKE was runtime, had to adapt it to type-in.
game_poke_a		equ	game_start + $49F6
game_poke_v		equ	182


	org		$5B00 - (StartFixed - StartMobile)
	
StartMobile:
	;display message	
	include "print_msg.asm"			
	
	;move loader into place	
	di
	ld	sp, game_stack
	
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc			
	ld	bc, UnpackEnd - StartFixed		
	ldir					
	
	ld	de, TurboLoader
	ld	bc, End - TurboLoader
	ldir
	
	;load scren to temp buffer and unpack it
	IF	SCR_SIZE > 0
LoadScr:	
	ld	ix, 32768
	ld	de, SCR_SIZE
	ld	a, $ff	
	call	TurboLoader	
	
	push	ix
	pop	hl
	dec	hl
	
	;unpack screen to temp buffer and display it
	ld	de, $C000
	call	Unpack				
	ex	de, hl
	inc	hl	
	call	ScrDraw	
	ENDIF
	
	jp	StartFixed
	
StartFixed:				
	;load and unpack main block
	ld	ix, game_start - 5
	ld	de, MAIN_SIZE
	ld	a, $ff	
	call	TurboLoader

	push	ix
	pop	hl
	dec	hl	
		
	ld	de, game_end		
	call	Unpack	
	
	xor	a
	out	($fe), a	
	
	ld	(23983), a
	
	push	af	
	dec	a
	ld	($FFFF), a	
	
	include "poker.asm"		
	pop	af
	
	jp	game_entry		
		
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:	
	
	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"	
End:
