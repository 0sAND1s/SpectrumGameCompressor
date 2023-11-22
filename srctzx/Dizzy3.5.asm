
	DEVICE ZXSPECTRUM48

game_start		equ $6C2F
game_end		equ	$C4E4
game_entry		equ $6C32
game_poke_a		equ 32879
game_poke_v		equ 0
game_stack		equ $6044
temp_stack		equ $0

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
	ld		de, SCR_SIZE1
	ld		a,$ff	
	call	TurboLoader	
	
	push	ix
	pop		hl
	dec		hl	
	
	;unpack screen to temp buffer and display it
	ld		de, $C000	
	call	Unpack								
	inc		de
	ex		de, hl
	
	;draw partial screen		
	ld		de, 16384
	ld		bc,	2048
	ldir
	ld		de, 16384 + 6144
	ld		bc, 256
	ldir		
		
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
	
	include "poker.asm"
	
	ld		sp, game_stack
	jp		game_entry

StartFixed:		
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:
	
	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"
End: