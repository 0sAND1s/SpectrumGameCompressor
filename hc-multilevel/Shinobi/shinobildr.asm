		DEVICE ZXSPECTRUM48
			
loaderFixed	EQU 	$EE48	

		org	LVL_ORG
		
		ld	hl, moverEnd
		ld	de, start
		ld	bc, end - start
		ldir
		jp	loaderFixed
moverEnd:
		
		org	loaderFixed
start:		
		call	pagein
		ld	hl, myfile
		call	10830		;call disk load routine in phantom RAM

levelStart:
	
	IF	LVL_IDX == $30	;if loading level 0
		call	$F60C	;show the key setup screen and jump to invulnerability key check
	ENDIF
	/*
		LD A, $C9		;RET instruction
		LD (INVULN_ADDR1), A	
	ELSE
		;Invulnerability, if any of QWERT keys are pressed after load of levels 0,2,4,6,8, with patch on addresses $ABCE, $ACE3, $AC19+$B840, $AE5B+$8794, $AD79+$866A
		;Define keys as GRUTS for unlimited lives.
	
		IFDEF	INVULN_ADDR1
			;LD BC,$FBFE		;read QWERT row
			;IN A,(C)
			;AND $1F
			;JR NZ, levelStart
			LD A, $C9		;RET instruction
			LD (INVULN_ADDR1), A			
			IFDEF	INVULN_ADDR2
				LD (INVULN_ADDR2), A	
			ENDIF
		ENDIF	
	
	ENDIF
	*/
		jp	LVL_JMP	;to define
pagein:		
		ld	hl,0
		push	hl
		jp	8
myfile:		
		db	9, "ShinobiL"
myfileidx:				
		db 	LVL_IDX	;to define
end:

		savebin	"shinobildr",start,end-start
