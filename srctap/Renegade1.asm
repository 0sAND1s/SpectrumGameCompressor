

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	19000
temp_stack		EQU	$5C00 - 10
game_start		EQU	$5C00
game_len		EQU	41888
game_end		EQU	65439
game_entry		EQU	23768
game_poke_a		EQU	41047
game_poke_v		EQU	182
	
	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			

	;move loader into place		
	di
	ld	sp, temp_stack 
	
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, End - StartFixed			
	ldir					
	
	;unpack screen
	IFDEF HAVE_SCR
	ld	bc, SCR_SIZE + MAIN_SIZE - 1
	add	hl, bc
	ld	de, $FFFF	
	call	Unpack		
	push	hl	
		ex	de, hl
		inc	hl
	
		call	ScrDraw
	pop	hl	
	ENDIF
	
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
	dec	de
	;unpack game into place
	ex	de, hl	
	ld	de, game_end		
	call	Unpack	
	
	xor	a
	out	($fe), a	
	
	;patch for eliminating slowness due to IN $FF; taken from the version from Rares Atodiresei. blue border still produced.
	ld	hl, $9B40
	xor	a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	
	
	
	include "poker.asm"	
	
	ld	sp, game_stack
	jp	game_entry	
	
	include "scr_draw.asm"			
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
