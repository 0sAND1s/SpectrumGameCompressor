Main block at $5B00
Entry point at $8100
Level loader at address $F01F
Wanted level number in A
Loaded level digit at $F04B
Level loading address at $638D
Level loader byte sequence: F5 11 01 00 21 4B F0 ...
Level loader offset in main block (before moving): $790
Lever loader returns to $60B4
Printing stop tape message $6271 then jump to $600A

Second loader: $620B?
Tape loader routine: $F000
Level number stored at $6105
Level digit stored at $629D
If level is 0, jumps to $6078, to load first level maybe
Location good for second loader replacement: $6231, bytes 218F62CD7860, offset $927
After loading level jump to $600A