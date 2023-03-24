	DEVICE ZXSPECTRUM48

game_start		equ 24444
game_end		equ	65020
game_entry		equ 35481
game_stack		equ 0
game_poke_a		equ 50545
game_poke_v		equ	0


	org		$5B00 - (StartFixed - StartMobile)
	
StartMobile:
	;display message	
	include "print_msg.asm"			
	
	;move loader into place		
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
	
	ld		de, game_end	
	call	Unpack	
	
	xor		a
	out		($fe), a		
	
	include "poker.asm"
		
	jp		game_entry		
		
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
