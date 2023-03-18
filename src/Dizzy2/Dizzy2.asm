	DEVICE ZXSPECTRUM48

exo_mapbasebits	equ	$5C00
game_start		equ $6000
game_end		equ	$FFFE
game_entry		equ $6100
game_stack		equ $6000
temp_stack		equ $5C00
game_poke_a		equ 29289
game_poke_v		equ 201


	org		$5B00 - (EndMobile - StartMobile)
	
StartMobile:
	;display message	
	include "../print_msg.asm"			
	
	;move loader into place	
	di
	ld		sp, temp_stack
	
	ld		de, StartFixed	
	ld		hl, EndMobile - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir									
		
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	ld		de, game_end		
	call	deexo		
	push	hl	
		ex		de, hl
		inc		hl
		call	ScrDraw		
	pop		hl	
	
	ld		de, game_end	
	call	deexo	
	
	include "../poker.asm"

	;signal 48K version loaded
	xor		a
	ld		(23728), a	
	
	ld		sp, game_stack
	jp		game_entry
EndMobile:		
		
StartFixed:		
	include "../scr_draw.asm"
	include	"../deexo_simple_b_fast.asm"
End:
