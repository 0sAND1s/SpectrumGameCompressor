

	DEVICE ZXSPECTRUM48
	
game_start		EQU	32768
game_len		EQU	8162
game_end		EQU	game_start + game_len - 1
game_stack		EQU	$5C00
temp_stack		EQU	$5C00
game_entry		EQU	game_start
game_poke_a		EQU	33245
game_poke_v		EQU	0
	
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
	ld	bc, End - StartFixed		
	ldir			

	ld	bc, MAIN_SIZE - 1
	add	hl, bc
	ld	de, game_end	
	call	Unpack	
	
	xor	a
	out	($fe), a	

	include "poker.asm"	
	
	ld	sp, game_stack
	jp	game_entry	

StartFixed:
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
