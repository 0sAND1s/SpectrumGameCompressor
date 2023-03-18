 	ld		bc, $FEFE
 	in		a, (c)
 	and		1 	
	jr		nz, NoPoke
		
	ld		hl, game_poke_a
	ld		(hl), game_poke_v
NoPoke:								
