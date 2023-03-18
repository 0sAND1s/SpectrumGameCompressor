# SpectrumGameCompressor
Tool for semi-automatic game compressing for the ZX Spectrum computer

Provides a generic, automated mechanism to create compressed ZX Spectrum games, optimised for file size. All
Steps are:
- extract specific blocks from a ZX Spectrum TAP/TZX file
- compress the blocks using Exomizer
- assemble a Z80 assembler loader that unpacks the game blobs at runtime
- package the binary in a TAP file, in a BASIC program block
- clean up after build.

The generic build script will build all games from src folder, or just the one specified in command line.
Each game file in the input folder must have the same file name as the corespoding sub-folder in src folder. Each output game file will have a the same matching name.
128K games are stripped from 128K specific blobs and only the minimal 48K functionality is kept. It wouldn't fit otherwise in memory all at once. The SCREEN$ is kept for games that need it, but is optional.
Each resulting compressed game is the smallest version you will probably find, thanks to the very good compression using Exomizer and also because all game reside in a single block.
Advantages of having one single compressed block for each game is:
- faster loading time, especially on tape, but also on disk
- less wasted disk space
- loading is possible on any storage device and computer, since there's no BASIC loader involved.

Adding a new game requires these steps:
- add a TAP or TZX (unprotected) file in the input folder, eg DIZZY1.TAP
- create a subfolder in the src folder, eg DIZZY1
- in the created subfolder create file game.bat with the game specific commands to extract required game blobs from the TAP file, using hcdisk2.exe for example
- in the created subfolder create assembler file, eg dizzy1.asm, with the code required at run time
- the produced compressed game will be provided in the output folder.

Currently there are given as example games Dizzy 1 to Dizzy 7. I have about 100 games already compressed that I will adapt to this tool.
