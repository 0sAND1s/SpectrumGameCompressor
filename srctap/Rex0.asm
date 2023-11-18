	DEVICE ZXSPECTRUM48

game_end		equ	65529
game_entry		equ 35460
game_stack		equ 25000
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
	
	ld		sp, game_stack
	jp		game_entry		
		
StartFixed:			
	include "scr_draw.asm"
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
