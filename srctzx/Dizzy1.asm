;Dizzy1 compressed version loader, Chirtoaca George, 17.03.2023	
;This one was a mess to figure out since the initial position of the compressed main block was too low, lower than the final destination of uncompressed block, so the compressed data was getting overwritten when decompressing.

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	$5C00
game_start		EQU	23734
game_len		EQU	41801
game_end		EQU	$FFFE
game_entry		EQU	game_start
game_poke_a		EQU	62745
game_poke_v		EQU	0
	
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
	
	jp	StartFixed
	
StartFixed:		
	
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
	;unpack game into place
	push	ix
	pop		hl
	dec		hl	
		
	ld		sp, game_stack 
	ld		de, game_end		
	call	Unpack
	
	xor		a
	out		($fe), a	

	include "poker.asm"	
	
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
