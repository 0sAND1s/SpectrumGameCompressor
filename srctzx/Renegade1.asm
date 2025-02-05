

	DEVICE ZXSPECTRUM48
	
game_stack		EQU	19000
temp_stack		EQU	0
game_start		EQU	$5C00
game_len		EQU	41888
game_end		EQU	65439
game_entry		EQU	23768
game_poke_a		EQU	41047
game_poke_v		EQU	182
	
	org		$5B00 - (StartFixed - StartMobile)

StartMobile:
	;display message	
	include "print_msg.asm"			

	;move loader into place		
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
	
	;load scren to temp buffer and unpack it
	IF	SCR_SIZE > 0
LoadScr:	
	ld	ix, 32768
	ld	de, SCR_SIZE
	ld	a,$ff	
	call	TurboLoader	
	
	push	ix
	pop	hl
	dec	hl
	
	;unpack screen to temp buffer and display it
	ld	de, $C000
	call	Unpack				
	ex	de, hl
	inc	hl	
	call	ScrDraw	
	ENDIF
	
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
	
	;patch for eliminating slowness due to IN $FF; taken from the version from Rares Atodiresei.
	ld	hl, $9B40	
	ld	(hl), a
	inc	hl
	ld	(hl), a

	include "poker.asm"	
	
	ld	sp, game_stack
	jp	game_entry	

	include "scr_draw.asm"						
Unpack:	
	include	"dzx0_turbo_back.asm"
UnpackEnd:	

;The tape loader must be placed in uncontended/upper memory, as it's timing sensitive.
	ORG 65000
TurboLoader:		
	include "turboldr.asm"

End:

