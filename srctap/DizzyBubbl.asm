	DEVICE ZXSPECTRUM48

game_start		equ $5C00
game_len		equ 37024
game_end		equ	60575
game_entry		equ 32920
game_poke_a		equ 43232
game_poke_v		equ 0
game_stack		equ $5C00
temp_stack		equ 0

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
	
	jp		StartFixed
StartFixed:					

	ld		bc, -MAIN_SIZE+1
	add		hl, bc
	ld		de, game_start - 3
	ld		bc, MAIN_SIZE
	ldir
			
	ex		de, hl
	dec		hl
	ld		de, game_end	
	call	Unpack

	xor		a	
	ld		(46412), a					;signal 48K model, the game checks this
	out		($fe), a
	inc		a
	ld		($ffff), a
	
	
	include "poker.asm"
		
	ld		sp, game_stack
	jp		game_entry

	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	