This one was hard to port, since the level loader resides in each level block, for the next block.
The build-in cheat modes are:
1. Defining keys as GRUTS gives unlimited lives
2. Holding keys QWERT after a level finishes being loaded/started gives invulnerability.

main block: $C000, $4000
main block entry: $EE48
main block 2: 128K data

level0:
level loader call: $EE5E
level loader: $EE7A
level header, $100 bytes loaded at $FA00
level body, $5ECE bytes, loaded at $5B00
level header loader call 2: $892A, $9DDC - header?
loaded level id: $EE48 -> 'a'
level body loader is in the $100 level header at $EE48, lenght and return address
jump after level loaded: $9C40
128K flag: $E7FA, 0 means 48K

to fix game start that doesn't show key options.

level1: 
	loader at $893A, offset 2E3A, pattern to search for in level blob: $DD $21 $48 $EE
	header loaded at $EE48	
	jump $EE49
	level loaded at $5B00
	jump $9C40
	
$8938 - 3 byte instr. that breaks the loader for block 3: 32, 70, 89