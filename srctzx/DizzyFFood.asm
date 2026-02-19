	DEVICE ZXSPECTRUM48

game_start		equ 24576
game_len		equ 40959
game_end		equ	65534
game_entry		equ 24832
game_poke_a		equ 47844
game_poke_v		equ 167
game_stack		equ 24574
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			
	
	;move loader into place	
	di
	ld	sp, temp_stack
	
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, UnpackEnd - StartFixed			
	ldir									
		
	ld	de, TurboLoader
	ld	bc, End - TurboLoader
	ldir

	
	IF SCR_SIZE > 0
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
	ld	(23627), a					;signal 48K model, the game checks this
	
	out	($fe), a
	
	include "poker.asm"
	
	ld	sp, game_stack
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