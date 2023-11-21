
	DEVICE ZXSPECTRUM48

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
	ld		ix, TurboLoader - MAIN_SIZE - 1
	push	ix
	ld		de, MAIN_SIZE
	ld		a, $ff
	scf
	call	TurboLoader
	jr		c, UnpackMain
	
	;Signal load error
	call	LoadError
	jr		LoadMain
	
UnpackMain:		
	;make screen black
	ld		hl, $5800
	ld		d, h
	ld		e, l
	inc		de
	ld		(hl), l
	ld		bc, 767
	ldir
	pop		hl

	jp		StartFixed
	
StartFixed:		
	;move code upper in RAM
	ld		de, game_start - 2
	ld		bc, MAIN_SIZE
	ldir
	dec		de
	ex		de, hl	
		
	;unpack in game scr
	ld		de, $57FF
	call	Unpack
	
	;unpack interrupt code
	ld		de, $420B
	call	Unpack	

	;unpack game
	ld		de, game_end	
	call	Unpack		

	;signal 48K machine
	xor		a
	ld		($411F), a		
	
	out		($fe), a
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	include "poker.asm"
	
	;start game
	ld		sp, game_stack	
	jp		game_entry

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
