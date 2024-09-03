
	DEVICE ZXSPECTRUM48

game_end		equ 40768-1
game_start		equ 32768
game_entry		equ 32768
game_poke_a		equ 32851
game_poke_v		equ 200
game_stack		equ 32767
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "print_msg.asm"

	;move fixed code into place	
	di
	ld	sp, temp_stack
		
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, End - StartFixed			
	ldir		
		
	ld	bc, SCR_SIZE + MAIN_SIZE - 1
	add	hl, bc

	jp	StartFixed
	
StartFixed:

	;unpack game
	ld	de, game_end	
	call	Unpack
	
	xor	a
	out	($fe), a
			
	include "poker.asm"
	
	;start game	
	ld	sp, game_stack
	jp	game_entry
	
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	
