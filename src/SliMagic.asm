

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	23600
temp_stack		EQU $5C00
game_start		EQU	25031
game_len		EQU	40490
game_end		EQU	$FFF0
game_entry		EQU	34113
;Had to alter the POKE, the code moves probably.
game_poke_a		EQU	game_start + $3E48
game_poke_v		EQU	0
	
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
	
	;jump to last blob
	ld		bc, blockend - block1 - 1
	add		hl, bc

	;unpack in game scr
	ld		de, game_end		
	call	Unpack		
	push	hl
	
		inc		de
		ex		hl, de
		ld		de, 16384 + 2048 * 2
		ld		bc, 2048
		ldir
		
		ld		de, 16384 + 6144
		ld		bc, 768
		ldir
		
	pop		hl
	ld		de, game_end
	call	Unpack
	
	xor		a
	out		($fe), a		
	ld		($8717),a

	include "poker.asm"	
	
	ld		sp, game_stack
	call	25883
	jp		game_entry	
	
StartFixed:			
	include "scr_draw.asm"				
Unpack:	
	include	"dzx0_turbo_back.asm"
End:

block1:
	incbin "SliMagic.1.packed"
block2:
	incbin "SliMagic.2.packed"
blockend:
