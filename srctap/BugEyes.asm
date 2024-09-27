;Blocks loading order:
;0.4000,1B00
;;EA60,01F4,EC54
;;9C40,000A,9C4A
;;A028,000A,A032
;;A7F8,000A,A802
;2.ACA8,07D0,B478
;3.B478,07D0,BC48
;4.BC48,1F40,DB88
;5.DB88,0FA0,EB28
;6.EB28,0870,F398
;1.A4D8,07D0,ACA8

	DEVICE ZXSPECTRUM48
	
game_start		EQU	$A4D8
game_len		EQU	20160
game_end		EQU	game_start + game_len - 1
game_stack		EQU	$5C00
temp_stack		EQU	$5C00
game_entry		EQU	$A4D8
game_poke_a		EQU	43393
game_poke_v		EQU	0
	
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
	ld	bc, End - StartFixed		
	ldir			

	;unpack screen
	ld	bc, SCR_SIZE + MAIN_SIZE - 1
	add	hl, bc
	
	IFDEF HAVE_SCR
	ld	de, game_end	
	call	Unpack		
	push	hl	
		ex	de, hl
		inc	hl
	
		call	ScrDraw
	pop	hl	
	ENDIF
	
	ld	de, game_end	
	call	Unpack	
	
	xor	a
	out	($fe), a	

	include "poker.asm"	
	
	ld	sp, game_stack
	jp	game_entry	
	
StartFixed:			
	include "scr_draw.asm"				
Unpack:	
	include	"dzx0_turbo_back.asm"
End:
