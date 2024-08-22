Poker: 		
	ld	bc, $BFFE
 	in	a, (c)	
		
	ld	l, a
	and	%1
	;check enter key			
	jr	z, PokeEnd
	
	;check L key
	ld	a, l
 	and	%10
	jr	nz, Poker
		
PokeIt:			
	ld	a, game_poke_v
	ld	(game_poke_a), a
;	ld	hl, game_poke_a
;	ld	(hl), game_poke_v
	ld	a, 1
PokeEnd:
