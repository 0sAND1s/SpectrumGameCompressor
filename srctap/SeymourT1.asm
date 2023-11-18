

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	32696
temp_stack		EQU $5C00
game_start		EQU	32696
game_len		EQU	28800
game_end		EQU	$F037
game_entry		EQU	32696
game_poke_a		EQU	48475
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
		ld		de, 16384
		ld		bc, 2048
		ldir
		
		ld		de, 16384 + 6144
		ld		bc, 256
		ldir
		
	pop		hl
	ld		de, game_end
	call	Unpack
	
	xor		a
	out		($fe), a			

	include "poker.asm"	
	
	ld		sp, game_stack	
	jp		game_entry	
	
StartFixed:			
	include "scr_draw.asm"				
Unpack:	
	include	"dzx0_turbo_back.asm"
End:

block1:
	incbin SeymourT1.2.packed
block2:
	incbin SeymourT1.1.packed
blockend:
