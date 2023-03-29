	DEVICE ZXSPECTRUM48

game_start		equ 23604
game_len		equ 41931
game_end		equ	$FFFE
game_entry		equ 37230
game_stack		equ $5C00
game_poke_a		equ 46911
game_poke_v		equ	0


	org		$5B00 - (StartFixed - StartMobile)
	
StartMobile:
	;display message	
	include "print_msg.asm"			
	
	;move loader into place		
	di
	ld		sp, game_stack
	
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir									
	
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc

	jp		StartFixed
StartFixed:			

	ld		bc, -(MAIN_SIZE - 1)
	add		hl, bc
	;move game code up in RAM, from begining	
	ld		bc, MAIN_SIZE
	;allow safety offset of 3
	ld		de, game_start - 3
	ldir				
	;go back one byte after LDIR
	dec		de
	;unpack game into place
	ex		de, hl	
	
	ld		de, game_end	
	call	Unpack	
	
	xor		a
	out		($fe), a		
	
	ld		(23675), a
	ld		(23299), a
	
	include "poker.asm"
		
	jp		game_entry		
			
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
