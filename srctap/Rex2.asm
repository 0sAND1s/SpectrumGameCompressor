	DEVICE ZXSPECTRUM48

game_end		equ	65529
game_entry		equ 38000
game_stack		equ 25000
temp_stack		equ $5C00
game_poke_a		equ 40303
game_poke_v		equ	0


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
	ld		de, game_end		
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
	out		($fe), a		
	
	include "poker.asm"	
	
	;If life cheat was selected, also accept invalid access code for part 2.
	ld		a, game_poke_v
	ld		hl, game_poke_a
	cp		a, (hl)
	jr		nz, NoAccesCodeCheat
	
	ld		a, 58
	ld		(56287), a
	ld		a, 201
	ld		(56405), a
		
NoAccesCodeCheat:	
	ld		sp, game_stack
	jp		game_entry		
		
StartFixed:			
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
