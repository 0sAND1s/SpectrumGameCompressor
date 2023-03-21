	
	DEVICE ZXSPECTRUM48

game_start		equ $5D00
game_len		equ 41728
game_end		equ $FFFF
game_entry		equ $8000
game_poke_a		equ 46562
game_poke_v		equ 183
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
	
	IFDEF HAVE_SCR
	ld		de, game_end		
	call	Unpack		
	push	hl	
		ex		de, hl
		inc		hl
		call	ScrDraw		
	pop		hl	
	ENDIF

	jp		StartFixed
StartFixed:			

	;move compressed blob up in memory, to not be overwritten when decompressing.
	ld		bc, -MAIN_SIZE+1
	add		hl, bc
	ld		bc, MAIN_SIZE
	ld		de, game_start - 3
	ldir
	
	ex		de, hl
	dec		hl
	ld		de, game_end	
	call	Unpack
	
	xor		a	
	out		($fe), a
	
	include "poker.asm"
	
	xor		a	
	ld		(23355), a					;signal 48K model, the game checks this
	ld		(32866), a	
	;ld		(49152), a	
		
	jp		game_entry
		
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	