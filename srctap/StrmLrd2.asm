

	DEVICE ZXSPECTRUM48
	
game_start		EQU	25088
game_len		EQU	40195
game_end		EQU	game_start + game_len - 1
game_stack		EQU	0
temp_stack		EQU	$5C00	
game_entry		EQU	27460

	IF LEVEL==1
game_poke_a		EQU	37923
game_poke_v		EQU	58
	ELSEIF LEVEL==2
game_poke_a		EQU	37969
game_poke_v		EQU	58
	ELSEIF LEVEL==3
game_poke_a		EQU	37879
game_poke_v		EQU	58	
	ENDIF
	
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
	ld	bc, SCR_SIZE + MAIN_SIZE - 1
	add	hl, bc
	
	IFDEF HAVE_SCR
	ld	de, game_end	
	call	Unpack		
	push	hl	
		ex	de, hl
		inc	hl
	
		call	ScrDraw
	pop	hl	
	ENDIF
	
	ld	de, game_end	
	call	Unpack	
	
	xor	a
	out	($fe), a	

	include "poker.asm"	
	
	IF LEVEL==2 || LEVEL==3
	ld	hl, 27009	
	ld	(hl), 201
	ENDIF	
	
	ld	sp, game_stack
	jp	game_entry	
	
StartFixed:			
	include "scr_draw.asm"				
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
