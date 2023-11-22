
	DEVICE ZXSPECTRUM48

game_start		equ 24272
game_end		equ	65534
game_entry		equ 45805
game_poke_a		equ 51291
game_poke_v		equ 0
game_stack		equ $5ED0
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

	;signal 48K machine
	xor		a
	ld		($728E), a		
	out		($fe), a
	
	dec		a
	ld		($FFFF), a	
	
	include "poker.asm"
	
	ld		sp, game_stack
	xor		a
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