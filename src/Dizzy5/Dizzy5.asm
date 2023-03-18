
	DEVICE ZXSPECTRUM48

exo_mapbasebits	equ	$5C00
game_end		equ	65534
game_entry		equ 45805
game_poke_a		equ 51291
game_poke_v		equ 0
game_stack		equ $5ED0
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "../print_msg.asm"			
	
	;move loader into place	
	di
	ld		sp, temp_stack
	
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
	
	include "../poker.asm"

	;signal 48K machine
	xor		a
	ld		($728E), a		
	
	dec		a
	ld		($FFFF), a	
	
	ld		sp, game_stack
	xor		a
	jp		game_entry

StartFixed:
	include "../scr_draw.asm"
	include	"../deexo_simple_b.asm"
End:	