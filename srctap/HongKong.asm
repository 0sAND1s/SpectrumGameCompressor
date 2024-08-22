
	DEVICE ZXSPECTRUM48

game_end		equ 62579
game_start		equ $5B03
game_entry		equ $F04A
game_poke_a		equ 33128
game_poke_v		equ 0
game_stack		equ $FFFF

	org		64500 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "print_msg.asm"

	;move fixed code into place	
	di
	ld	sp, game_stack
		
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, End - StartFixed			
	ldir		
	
	;unpack screen
	ld	bc, SCR_SIZE + MAIN_SIZE - 1
	add	hl, bc
	
	IFDEF HAVE_SCR
	ld	de, StartFixed-1	
	call	Unpack			
	push	hl	
		ex	de, hl
		inc	hl
		
		call	ScrDraw
	pop	hl	
	ENDIF

	ld	bc, -MAIN_SIZE + 1
	add	hl, bc
	jp	StartFixed
	
StartFixed:
	;move compressed main block in upper memory		
	ld	de, game_start - 2	
	ld	bc, MAIN_SIZE
	ldir	
	ex	de, hl
	dec	hl	

	;unpack game
	ld	de, game_end	
	call	Unpack
	
	xor	a
	out	($fe), a
			
	include "poker.asm"
	
	;start game	
	jp	game_entry
	
	include "scr_draw.asm"		
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	
