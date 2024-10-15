
	DEVICE ZXSPECTRUM48

game_start		equ 33300
game_len		equ 18900
game_end		equ game_start+game_len-1
game_entry		equ 42000
game_stack		equ 0
temp_stack		equ $5C00
game_poke_a		equ 42837
game_poke_v		equ 182

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
	
	ld	hl, 24000	
	ld	(23651), hl	;STKBOOT
	ld	(23653), hl	;STKEND
	ld	hl, 1
	ld	(23613), hl
	
	xor	a
	out	($fe), a
	ld	(23624), a
			
	include "poker.asm"
	
	;start game	
	ld	sp, game_stack
	ei
	jp	game_entry
	
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	
