
	DEVICE ZXSPECTRUM48

game_start		equ	24137
game_end		equ	65531
game_entry		equ 24158
game_poke_a		equ 29623
game_poke_v		equ 182
game_stack		equ $5C00
temp_stack		equ $5C00

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
	
	;load scren to temp buffer and unpack it
	IF	SCR_SIZE > 0
LoadScr:	
	ld		ix, 25000
	ld		de, SCR_SIZE
	ld		a,$ff
	scf
	call	TurboLoader	
	jr		c, ScrShow
	
	;Signal load error
	call	LoadError
	jr		LoadScr
	
ScrShow:	
	push	ix
	pop		hl
	dec		hl
	
	;unpack screen to temp buffer and display it
	ld		de, $C000
	call	Unpack				
	ex		de, hl
	inc		hl	
	call	ScrDraw	
	ENDIF
	
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
	
	jp StartFixed
	
StartFixed:		
UnpackMain:	
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
	
	;signal load OK
	dec		a
	ld		($FFFF), a	
	
	include "poker.asm"	
	
	xor		a
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
	
	IF SCR_SIZE > 0
	include "scr_draw.asm"				
	ENDIF
	
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:
	
	;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"
End: