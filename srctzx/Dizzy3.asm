
	DEVICE ZXSPECTRUM48

game_start		equ	$6000
game_end		equ	$FFFE
game_entry		equ $6100
game_poke_a		equ 63001
game_poke_v		equ 0
game_stack		equ $5D00
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			
		
	di	
	
	;move loader into place	
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, UnpackEnd - StartFixed		
	ldir	
	ld		de, TurboLoader
	ld		bc, End - TurboLoader
	ldir
	
	;load scren to temp buffer and unpack it	
	ld		ix, 32768
	ld		de, SCR_SIZE
	ld		a,$ff	
	call	TurboLoader	
	
	push	ix
	pop		hl
	dec		hl	
	
	;unpack screen to temp buffer and display it
	ld		de, $C000
	call	Unpack				
	ex		de, hl
	inc		hl	
	call	ScrDraw		
	
	;load and unpack main block
	ld		ix, game_start - 5
	ld		de, MAIN_SIZE
	ld		a, $ff	
	call	TurboLoader
	
	push	ix
	pop		hl
	dec		hl	
		
	ld		sp, temp_stack 
	ld		de, game_end		
	call	Unpack	

	xor		a	
	out		($fe), a
	ld		($5c4b), a					;signal 48K model, the game checks this
	out		($fe), a
	
	include "poker.asm"
	
	jp		game_entry

StartFixed:				
	include "scr_draw.asm"					
	
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:
	
	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"
End: