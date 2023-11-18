;Dizzy1 compressed version loader, Chirtoaca George, 17.03.2023	
;This one was a mess to figure out since the initial position of the compressed main block was too low, lower than the final destination of uncompressed block, so the compressed data was getting overwritten when decompressing.

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	$5C00
temp_buf_end	EQU $FFFF
game_start		EQU	23734
game_len		EQU	41801
game_end		EQU	$FFFE
game_entry		EQU	game_start
game_poke_a		EQU	62745
game_poke_v		EQU	0
	
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

	;unpack screen
	ld		bc, SCR_SIZE + MAIN_SIZE - 1
	add		hl, bc
	ld		de, temp_buf_end			
	call	Unpack			
		
	push	 hl
		;draw screen from temp buffer
		inc		de
		ex		de, hl				
		call	ScrDraw
	pop		hl

	jp	StartFixed
StartFixed:	

	ld		bc, -(MAIN_SIZE - 1)
	add		hl, bc
	;move game code up in RAM, from begining	
	ld		bc, MAIN_SIZE
	;allow safety offset of 4
	ld		de, game_start - 4	
	ldir
				
	;go back one byte after LDIR
	dec		de
	;unpack game into place
	ex		de, hl	
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
