
	DEVICE ZXSPECTRUM48

game_start		equ $6C2F
game_end		equ	$C4E4
game_entry		equ $6C32
game_poke_a		equ 32879
game_poke_v		equ 0
game_stack		equ $6044
temp_stack		equ $0
temp_buf_end	equ $FF00

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
		
	;unpack screen
	ld		bc, blockEnd - blockMain - 1
	add		hl, bc
	ld		de, temp_buf_end		
	call	Unpack		
	
	;draw partial screen
	push	hl	
		ex		de, hl
		inc		hl
		ld		de, 16384
		ld		bc,	2048
		ldir
		ld		de, 16384 + 6144
		ld		bc, 256
		ldir	
	pop		hl	
	
	;unpack game
	ld		de, game_end	
	call	Unpack

	xor		a		
	out		($fe), a
	
	include "poker.asm"
	
	ld		sp, game_stack
	jp		game_entry

StartFixed:		
Unpack:	
	include	"dzx0_turbo_back.asm"
End:	

blockMain:
	incbin "dizzy3.5.2.packed"
blockScr:
	incbin "dizzy3.5.1.packed"
blockEnd: