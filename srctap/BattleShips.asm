

	DEVICE ZXSPECTRUM48
	
game_start		EQU	$6100
game_len		EQU	$9700
game_end		EQU	$f800
game_stack		EQU	0
temp_stack		EQU	game_stack
game_entry		EQU	$8000

game_poke_a		EQU	47749
game_poke_v		EQU	0
	
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

	;unpack screen
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	
	IFDEF HAVE_SCR
	ld		de, game_end		
	call	Unpack			
	push	hl	
		ex		de, hl
		inc		hl
		
		call	ScrDraw
	pop		hl	
	ENDIF
		
	ld		de, game_end		
	call		Unpack	
	
	xor		a
	out		($fe), a	

	include "poker.asm"	
	
	ld		sp, game_stack
	jp		game_entry	
	
StartFixed:			
	include "scr_draw.asm"				
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
