;BC = current address (relocatable code)
PrintMsg:	
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
		halt
		halt
		djnz	PrintMsgLoop			
	pop		bc		
	jr		Msg + MsgLen
Msg	defb	13, " ENTER=start, L=unlimited lives", 13, 127, "2026 george.chirtoaca@gmail.com"	
MsgLen equ	$ - Msg