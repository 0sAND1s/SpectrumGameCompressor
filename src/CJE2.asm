	DEVICE ZXSPECTRUM48

game_start		equ 24576
game_end		equ	$FFFE
game_entry		equ $B76F
game_stack		equ $5C00
;POKE was runtime, had to adapt it to type-in.
game_poke_a		equ game_start + $49F6
game_poke_v		equ	182


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
	
	ld		de, game_end	
	call	Unpack		
	xor		a
	out		($fe), a	
	
	ld		(23983), a
	
	push	af	
	dec		a
	ld		($FFFF), a	
	
	include "poker.asm"		
	pop		af
	
	jp		game_entry		
		
StartFixed:			
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
