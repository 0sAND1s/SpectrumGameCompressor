
	DEVICE ZXSPECTRUM48

game_start		equ	24137
game_end		equ	65531
game_entry		equ 24158
game_poke_a		equ 29623
game_poke_v		equ 182
game_stack		equ $5C00

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
	ld		de, game_end		
	call	Unpack		
	push	hl	
		ex		de, hl
		inc		hl
		call	ScrDraw		
	pop		hl	

	jp StartFixed
StartFixed:
	
	ld		bc, -MAIN_SIZE + 1
	add		hl, bc
	ld		de, game_start - 3
	ld		bc, MAIN_SIZE
	ldir
	
	dec		de
	ex		de, hl
	ld		de, game_end	
	call	Unpack		

	;signal 48K machine
	xor		a
	ld		($728E), a	
	out		($fe), a
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	include "poker.asm"	
	
	xor		a
	jp		game_entry

	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	