128K flag - determined reading $5B00 - the printer buffer, then set to $F91C, $EF96 - 0 = 48K, 1 = 128K
game entry: 61504
game start addr: $AC00
level header: 
- 1 byte level number, 1 - based
- 2 bytes level length
- ...
- bitmap
- level name


$AD81 - level loader
$EF6F - wanted level number
$DA1B - loaded level number
$CFF7 - tape loader for levels
$5B00 - level load address
$DA1B - level header load address, len 88
$ADEA - return after level loaded or without tape message - $ADF0