
	DEVICE ZXSPECTRUM48

game_end		equ $FFFF
game_start		equ 28000
game_entry		equ 28000
game_poke_a		equ 40221
game_poke_v		equ 0
game_stack		equ 27998
temp_stack		equ $5C00

	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message
	include "print_msg.asm"

	;move fixed code into place	
	di
	ld	sp, temp_stack
		
	ld	de, StartFixed	
	ld	hl, StartFixed - StartMobile
	add	hl, bc						
	ld	bc, UnpackEnd - StartFixed			
	ldir		
		
	ld	de, TurboLoader
	ld	bc, End - TurboLoader
	ldir
	
	jp	StartFixed

StartFixed:					
	;load and unpack main block
	ld	ix, game_start - 5
	ld	de, MAIN_SIZE
	ld	a, $ff	
	call	TurboLoader

	push	ix
	pop	hl
	dec	hl	
		
	ld	de, game_end		
	call	Unpack	
	
	xor	a
	out	($fe), a
			
	include "poker.asm"
	
	;start game	
	ld	sp, game_stack
	jp	game_entry
	
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:	

	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"		
End:	
