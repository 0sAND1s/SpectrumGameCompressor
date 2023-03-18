
	DEVICE ZXSPECTRUM48

exo_mapbasebits	equ	$5C00
game_end		equ	$FFFE
game_entry		equ $6100
game_poke_a		equ 63001
game_poke_v		equ 0
game_stack		equ $5D00
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "../print_msg.asm"			
	
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
	ld		de, game_end		
	call	deexo		
	push	hl	
		ex		de, hl
		inc		hl
		call	ScrDraw		
	pop		hl	
	
	ld		de, game_end	
	call	deexo	
	
KeyTest:	
 	ld		bc, $FEFE
 	in		a, (c)
 	and		1 	
	jr		nz, NoPoke
		
	ld		hl, game_poke_a
	ld		(hl), game_poke_v		
NoPoke:		
	
	xor		a	
	ld		($5c4b), a					;signal 48K model, the game checks this
	jp		game_entry

StartFixed:		
	include "../scr_draw.asm"
	include	"../deexo_simple_b_fast.asm"
End:	