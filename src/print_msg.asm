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
		halt
		djnz	PrintMsgLoop			
	pop		bc		
	jr		Msg + MsgLen
Msg	defb	" ENTER=start, L=unlimited lives", 13, 127, "2023 george.chirtoaca@gmail.com"	
MsgLen equ	$ - Msg