	DEVICE ZXSPECTRUM48

game_start		equ $6000
game_end		equ	$FFFE
game_entry		equ $6100
game_stack		equ $6000
temp_stack		equ $5C00
game_poke_a		equ 29289
game_poke_v		equ 201


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
		
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	ld		de, game_end		
	call	Unpack		
	push	hl	
		ex		de, hl
		inc		hl
		
		call	ScrDraw
	pop		hl	
	
	ld		de, game_end	
	call	Unpack	
	
	xor		a
	out		($fe), a	
	
	include "poker.asm"

	;signal 48K version loaded
	xor		a
	ld		(23728), a	
	
	ld		sp, game_stack
	jp		game_entry		
		
StartFixed:			
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
