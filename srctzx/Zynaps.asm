

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	24999
temp_stack		EQU $5C00
game_start		EQU	25000
game_len		EQU	40535
game_end		EQU	$FFFE
game_entry		EQU	32768
game_poke_a		EQU	45425
game_poke_v		EQU	182
	
	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			

	;move loader into place		
	di	
	
	ld		de, StartFixed	
	ld		hl, StartFixed - StartMobile
	add		hl, bc						
	ld		bc, UnpackEnd - StartFixed		
	ldir	
	ld		de, TurboLoader
	ld		bc, End - TurboLoader
	ldir
	
	;load and unpack main block
LoadMain:	
	ld		ix, game_start - 5
	ld		de, MAIN_SIZE
	ld		a, $ff
	scf
	call	TurboLoader
	jr		c, UnpackMain
	
	;Signal load error
	call	LoadError
	jr		LoadMain
	
UnpackMain:	
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
LoadError:
	ld		bc, $ffff
LoadErrorLoop:
	ld		a, r	
	out		($fe), a	
	dec		bc
	ld		a, b
	or		c
	jr		nz, LoadErrorLoop
	ret
	
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:
	
	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"
End:

