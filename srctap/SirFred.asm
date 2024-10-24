
	DEVICE ZXSPECTRUM48

game_start		equ $5B00
game_len		equ 42071
game_end		equ game_start + game_len - 1
game_entry		equ 46404
game_poke_a		equ 46650
game_poke_v		equ 167
game_stack		equ $0


	org		game_end + 1 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "print_msg.asm"

	;move fixed code into place	
	di
	ld	sp, game_stack
		
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, End - StartFixed			
	ldir		
	
	push	hl
		ld	hl, $5800
		ld	d, h
		ld	e, l
		inc	de
		ld	(hl), l
		ld	bc, 767
		ldir
	pop	hl	

	jp	StartFixed
	
StartFixed:
	;move compressed main block in upper memory	
	ld	de, game_start - 3	
	ld	bc, MAIN_SIZE
	ldir	
	ex	de, hl
	dec	hl	

	;unpack game
	ld	de, game_end	
	call	Unpack
	
	xor	a
	out	($fe), a
			
	include "poker.asm"
	
	;start game		
	jp	game_entry
		
Unpack:	
	include	"dzx0_standard_back.asm"
End:	
