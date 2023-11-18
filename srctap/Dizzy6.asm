
	DEVICE ZXSPECTRUM48

game_end		equ	61628
game_entry		equ $646B
game_poke_a		equ 30891
game_poke_v		equ 182
game_stack		equ $63DB
temp_stack		equ $0

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "print_msg.asm"

	;move fixed code into place	
	;di
	ld		sp, temp_stack
		
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir									
	
	;unpack screen located at the end of load
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	ld		de, game_end	
	call	Unpack	
	
	push	hl
		ex		de, hl
		inc		hl
		call	ScrDraw
	pop		hl

	;unpack game
	ld		de, game_end		
	call	Unpack		
	
	;signal 48K machine
	xor		a
	ld		($6444), a		
	
	out		($fe), a
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	;set poke
	include "poker.asm"
	
	;start game
	ld		sp, game_stack
	xor		a	
	jp		game_entry
	
StartFixed:
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	