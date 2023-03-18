
	DEVICE ZXSPECTRUM48

exo_mapbasebits	equ	$5C00
game_end		equ	65531
game_entry		equ 24158
game_poke_a		equ 29623
game_poke_v		equ 182
game_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	;include "../print_msg.asm"			
	
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

	;signal 48K machine
	xor		a
	ld		($728E), a	
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	xor		a
	jp		game_entry

StartFixed:
	include "../scr_draw.asm"
	include	"../deexo_simple_b_fast.asm"
End:	