

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	24999
temp_stack		EQU $5C00
game_start		EQU	25000
game_len		EQU	40535
game_end		EQU	$FFFE
game_entry		EQU	32768
game_poke_a		EQU	45425
game_poke_v		EQU	182
	
	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			

	;move loader into place		
	di
	ld		sp, temp_stack 
	
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir					
	
	ld		bc, MAIN_SIZE - 1
	add		hl, bc	
	ld		de, game_end		
	call	Unpack	
	
	xor		a
	out		($fe), a	

	include "poker.asm"	
	
	ld		sp, game_stack
	jp		game_entry	
	
StartFixed:	
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
