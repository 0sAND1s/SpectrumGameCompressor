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
	;di
	ld		sp, temp_stack
	
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir									
		
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	
	IFDEF HAVE_SCR
	ld		de, $FF00		
	call	Unpack		
	push	hl	
		ex		de, hl
		inc		hl
		call	ScrDraw		
	pop		hl	
	ENDIF
	
	ld		de, game_end	
	call	Unpack

	xor		a	
	ld		(23627), a					;signal 48K model, the game checks this
	
	out		($fe), a
	
	include "poker.asm"
	
	ld		sp, game_stack
	jp		game_entry


StartFixed:				
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	