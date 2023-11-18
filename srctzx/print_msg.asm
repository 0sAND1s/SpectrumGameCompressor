;BC = current address (relocatable code)
PrintMsg:	
	push	bc	
		;create custom font table
		LD DE, $C738	;custom font table
		PUSH DE
		PUSH DE
		LD BC, $0300	;font table length = 768 decimal
		LD HL, $3D00	;font table in ROM
		LDIR
		POP DE
		DEC D
		LD ($5C36),DE  ;CHARS variable
		POP HL
		LD BC, $02F8	;
ChrLoop:		
		LD A,L
		DEC A
		AND 06
		LD D,A
		SRA D
		LD A,(HL)
		PUSH AF
		LD A,00
		OR D
		POP AF
		JR Z, Rotate
Shift:		
		SLA A
		DEC D
		JR NZ,Shift

Rotate:		
		RRA
		OR (HL)
		LD (HL),A
		INC HL
		DEC BC
		LD A,B
		OR C
		JR NZ, ChrLoop
		
		;clear screen
		ld		hl, $4000
		ld		d, h
		ld		e, l
		inc		de
		ld		bc, 6911
		ld		(hl), l
		ldir
		
	pop	bc
	push	bc		
		push	bc
			xor		a
			call	$1601						
		pop		bc
		
		ld		hl, Msg - PrintMsg
		add		hl, bc	
		ld		b, MsgLen
PrintMsgLoop:	
		ld		a, (hl)
		rst		$10
		inc		hl
		djnz	PrintMsgLoop			
	pop		bc		
	
	jr		Msg + MsgLen
Msg	defb	13, 16, 2, 17, 0, " ENTER=start, L=unlimited lives ", 127, "2023 george.chirtoaca@gmail.com"	
MsgLen equ	$ - Msg