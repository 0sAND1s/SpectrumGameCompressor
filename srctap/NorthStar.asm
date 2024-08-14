
	DEVICE ZXSPECTRUM48

game_end		equ $FF93
game_start		equ $5B00
game_entry		equ $B7BF
game_poke_a		equ 48371
game_poke_v		equ 182
game_stack		equ $0

	org		$4000 - (StartFixed - StartMobile)

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
	
	;make screen black, to hide our code in there
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
	ld	de, game_start - 2	
	ld	bc, MAIN_SIZE
	ldir	
	ex	de, hl
	dec	hl	

	;unpack game
	ld	de, game_end	
	call	Unpack
	
	out	($fe), a
			
	include "poker.asm"
	
	;start game	
	jp	game_entry
	
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	
