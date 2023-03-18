
	DEVICE ZXSPECTRUM48

exo_mapbasebits	equ	$FF00
game_end		equ	$FD91
game_start		equ $5B00
game_entry		equ $8200
game_poke_a		equ 57267
game_poke_v		equ 0
game_stack		equ $FDF0
temp_stack		equ $0

	org		$4400 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "../print_msg.asm"

	;move fixed code into place	
	di
	ld		sp, temp_stack
		
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, End - StartFixed			
	ldir						

	;make screen black
	push	hl
		ld		hl, $5800
		ld		d, h
		ld		e, l
		inc		de
		ld		(hl), l
		ld		bc, 767
		ldir
	pop		hl	
	
	;jump to last blob
	ld		bc, blockend - block1 - 1
	add		hl, bc
		
	;unpack in game scr
	ld		de, $57FF
	call	deexo
	
	;unpack interrupt code
	ld		de, $420B
	call	deexo	

	jp		StartFixed
	
StartFixed:
	;move compressed main block in upper memory		
	ld		de, game_start - 3	
	ld		bc, - (block2 - block1) + 1
	add		hl, bc
	ld		bc, block2 - block1
	ldir	
	ex		de, hl
	dec		hl	

	;unpack game
	ld		de, game_end	
	call	deexo	

	;set poke
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
	ld		($411F), a		
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	;start game
	ld		sp, game_stack	
	jp		game_entry
	
	;include "../scr_draw.asm"
	include	"../deexo_simple_b_fast.asm"
End:	

block1:
	incbin "dizzy7.bin.exo"
block2:
	incbin "dizzy7.exo"
block3:
	incbin "dizzy8.exo"
blockend: