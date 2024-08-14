
	DEVICE ZXSPECTRUM48

game_end		equ 65020
game_start		equ 27484

game2_start		equ $4000
game2_end		equ game2_start + 4497 - 1

game_entry		equ $4000
game_poke_a		equ 38421
game_poke_v		equ 201

game_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

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
	
	;make screen black, to hide our code in there
	push	hl
		ld	hl, $5800
		ld	d, h
		ld	e, l
		inc	de
		ld	(hl), l
		ld	bc, 767
		ldir
	pop	hl	
	
	;Unpack smaller part to $4000
	ld	bc, blockend - block1 - 1
	add	hl, bc
	ld	de, game2_end
	call	Unpack

	jp	StartFixed
	
StartFixed:	

	;unpack game
	ld	de, game_end	
	call	Unpack
	
	xor	a
	out	($fe), a
	
	;Signal 48K	
	ld	(16466), a
			
	include "poker.asm"
	
	;start game		
	jp	game_entry
	
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	

block1:
	incbin "SwitchBld.1.packed"
block2:
	incbin "SwitchBld.2.packed"
blockend:
