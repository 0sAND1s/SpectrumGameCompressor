	DEVICE ZXSPECTRUM48

game_end		equ	$D39C
game_entry		equ $7B00
game_poke_a		equ 35993
game_poke_v		equ 0
game_stack		equ $5DC0
temp_stack		equ $5C00

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

	;signal 48K model, the game checks this
	/*
	ld		a, 170
	ld		(49152), a
	xor		85
	ld		(65409), a
	*/
	
	xor		a	
	
	out		($fe), a
	
	ld		hl, $FF81
	ld		(hl), a	
	
	;signal load OK	
	dec		a
	dec		hl
	ld		(hl), a		
		
	include "poker.asm"
	
	ld		sp, game_stack
	jp		game_entry


StartFixed:				
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	