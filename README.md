# SpectrumGameCompressor
Tool for semi-automatic game compressing for the ZX Spectrum computer

![ScreenShot](https://raw.githubusercontent.com/0sAND1s/SpectrumGameCompressor/main/SpectrumGameCompressor1.png)
![ScreenShot](https://raw.githubusercontent.com/0sAND1s/SpectrumGameCompressor/main/TurboLoadingTZX.png)

Provides a generic, automated mechanism to create compressed ZX Spectrum games, optimised for minimal file size and portability for loading.
It provides many top, hand picked games converted already, more to come. But also provides all the steps to convert those games starting from the original TAP/TZX image to produce the compressed one-block game in TAP format.
Each resulting compressed game is the smallest version you will probably find, thanks to the very good compression using ZX0 and also because the entire game resides in a single program block.
Currently, included as examples are all official Dizzy games, 15 items. I have about 100 games already compressed previously using Exomizer that I plan to adapt to this tool.
Also, an optional game cheat/trainer is included for unlimited lives for the included games!

Advantages of having one single compressed block for each game is:
- Loading is possible on any storage device and computer, since there's no BASIC loader involved. The games can be loaded from tape, microdrive, +3 disk, MGT disk, Opus disk, TR-DOS disk, etc, without any changes!
- Faster loading time, especially on tape, but also on disk, IF1 serial port, etc
- Less wasted disk space and file slack (space wasted by incompletely filling the file system blocks)
- Fitting many more games on one disk is possible. Example: a Spectrum +3 180KB disk can fit games Dizzy 1, 2, 3, 4, 5, which are big games, that also include the SCREEN$.

The automated steps included in buildtap.bat are:
- extract specific blocks from the ZX Spectrum TAP/TZX file, handled by the game-specific <name>.bat file.
- optimise the SCREEN$ memory layout for better compression, by arranging memory by columns
- compress the blocks, using the ZX0 packer
- assemble a Z80 assembler loader, <name>.asm, that unpacks the game binaries when executed
- package the resulting binary in a TAP file, in a single BASIC program block, written in the "output" folder, as <name>.tap
- clean up after the build.

There are minimal changes when adding a new game to be compressed, as the common code is kept is separate assembly files, only specific game parameters need to change like game start/end address, stack address, execution address.
If a common file needs to be updated, the build script will build all games again.
The generic build script will build all games from the src folder, or just the one specified in command line. Example: "buildtap.bat Dizzy1" will build just the "Dizzy1" game.

In the provided games, 128K games are stripped from 128K specific blobs and only the minimal 48K functionality is kept. It wouldn't fit otherwise in memory all at once most probably.
The SCREEN$ is kept for games that need it, but is optional.

Adding a new game to be compressed requires these steps:
- Find the original version of game in TAP format and add in the input folder. TZX files are supported, as long as they contain standard or turbo blocks, no SpeedLock, etc. Games already cracked are harder to reverse engineer and might be compressed or obfuscated already.
- Identify required parameters for the game, using HCDisk or other TAP/TZX viewer and write them in the .asm file: 
	- stack address: CLEAR statement in BASIC, or "ld sp, xxxxx in assembler"
	- block start address for each block: "LOAD ""CODE xxxxx" or tape block start address in BASIC, or "LD IX, xxxxx" in assebler.
	- block lenght: tape block lenght in BASIC or "LD DE, xxxxx" in assembler
	- entry point address: "RANDOMIZE USR xxxxx" in BASIC or "JP xxxxx" in assembler.
- in the "src" folder, create file dizzy1.bat for example, with the game specific commands to extract required game blobs from the TAP file, using hcdisk2.exe or other tool
- in the "src" folder, create assembler file, eg dizzy1.asm, with the code required at run time for unpacking

The build script supports tweaking using these parameters:
- develop, set to 1 to help with troubleshooting: not perform cleanup after the buid, leave script echo on screen, compress quicker (not optimal), create assembler listing file
- wantScr, set to 1 to not include the SCREEN$ binary in the resulting game image, to save space and shorten loading time. Some people prefer to have the SCREEN$ included.
- doCompress, used internally for games that perform the compression in the name.bat file, like Dizzy 7, because the game has more than one block.

Also provided are to .bat scripts that create DSK files with the games from the output folder, using HCDisk. 
These can be called with no argument or with specific file mask to include on the disk, eg "dsk4plus3.dsk Dizzy1.bat".
- dsk4plus3.bat - creates DSK image gamesplus3.dsk for Spectrum +3.
- dsk4hc.bat - creates DSK image gameshc.dsk for ICE Felix HC (my favorite ZX Spectrum clone).
I noticed that a few games are not running properly on Spectrum +3 when loaded from disk, but work fine on Spectrum 128K/48K or even +3 when loaded from tape. 
It might be that the originals had the issue too, or that are not cracked properly, or that are using memory in the printer buffer area. Any help is appreciated to fix them.

Also added the feature for producing turbo-loading TZX files, in folder 'buildtzx'. The games can be built at once with buildtzx.bat or individually with command 'buildtzx.bat Dizzy3' for example.
The default loading speed is 6000 baud, resulting in loading time of at most 1 minute! Some other supported speeds, configured in buildtzx.bat are 1364 (ROM speed), 2250 (good for tape recording), and 3000. 
The loading border stripes color is showing the progress of loading, in chunks of 8KB left to load: white - 8KB, yellow - 16KB, cyan - 24KB, green - 32KB, magenta - 40KB, red - 48KB.
Using baud 6000, 8KB block is loaded in about 14 seconds, so the color changes every 14 seconds. 
This feature allows fast loading of the compressed games on a ZX Spectrum or clone that only has the tape input as loading option.

The tools used by the build script are all open source. The binaries are included in the "tools" folder. Can also be found here:
- ZX0 excelent compressor by Einar Saukas: https://github.com/einar-saukas/ZX0 . I found it to be faster, smaller and to have better compression than the otherwise very good Exomizer packer.
- SjAsmPlus assembler by z00m128: https://github.com/z00m128/sjasmplus
- HCDisk 2.0 by George Chirtoaca, used for extracting blocks from TAP/TZX files, reordering/blanking SCREEN$ files to improve compressing, bin2rem functionality, file cutting, reading and producing the resulting TAP, TZX files: https://github.com/0sAND1s/HCDisk
- Spectaculator emulator by Jonathan Needle for debugging: https://www.spectaculator.com/
- https://www.the-tipshop.co.uk/ for unlimited life POKEs.
- https://worldofspectrum.org/ , https://www.zx-spectrum.cz/index.php?lang=en for games download
- The turbo loader is taken from tool Z802TZX by Tomas Kac. The tool is found on worldofspectrum.org.