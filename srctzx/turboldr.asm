;Turbo loader extracted from Z802TZX utility by Tomaz Kac  (tomcat@sgn.net).

;Is originally cofigured using 4 loading speeds (baud rate): 1364 (ROM-like, but using shorter pilot tones), 2250, 3000, 6000.
;Speeds up to 3000 baud can be used with a tape recorder. Speed 6000 only works with PC output and allows loading a compressed game in about 1 minute.

;Tested 6000 bauds with HC2000 (48K clone) with upgraded "operational amp" circuit and it works fine.
;Tested 6000 bauds with HC-91+ (128K clone) and it doesn't work at 6000 baud, but 3000 is ok.

;Other tools exist that can produce even faster speeds, like 17000 baud, but I found those less reliable, even with the PC output: 
; - ZQLoader: https://github.com/oxidaan/zqloader
; - Otla: https://github.com/sweetlilmre/otla .

;Added variable border color for showing loading progress:
;-WHITE	: less than 8KB left to load
;-YELLOW	: less than 16KB left to load
;-CYAN		: less than 24KB left to load
;-GREEN	: less than 32KB left to load
;-MAGENTA	: less than 40KB left to load
;-RED		: less than 48KB left to load.
		DEFINE SHOW_LOAD_PROGRESS

		DEVICE ZXSPECTRUM48		

;define default baud rate to be 6000
		IFNDEF BAUD
		DEFINE BAUD 6000
		ENDIF
		
		
		IF BAUD==1364		;ROM timings
COMPARE 	EQU $80 + 41
DELAY 		EQU 20
		ELSEIF BAUD==2250
COMPARE 	EQU $80 + 24
DELAY 		EQU 11
		ELSEIF BAUD==3000
COMPARE 	EQU $80 + 18
DELAY 		EQU 7
		ELSEIF BAUD==6000
			;Uncomment the line bellow if showing the loading progress causes issues with 6000 baud loading.
			;UNDEFINE SHOW_LOAD_PROGRESS
COMPARE 	EQU $80 + 7
			IFDEF SHOW_LOAD_PROGRESS
DELAY 		EQU 1			;decreased from 3 to 1, to accomodate extra CPU time required by adding loading progress display with changing border colors.
			ELSE
DELAY 		EQU 3			
			ENDIF
		ENDIF

BORDER_COLOUR 		EQU 2	;RED border

/*
LD_BLOCK:  
		CALL LD_BYTES     
		RET  C            
		RST  0008;,ERROR_1 
		DEFB $1A ; R Tape
*/		

Reload:
		;Preserve A loading flag, address, length.
		push ix
		push de
		push af
			scf
			call LD_BYTES			
		pop  hl
		pop  de
		pop  bc		
		ret  c	
				
		push bc
			call LoadError		
		pop  ix
		ld   a, h
		jr   Reload

		  
LD_BYTES: 
		INC  D            
		EX   AF,AF'       
		DEC  D            
		LD   A,$08        
		OUT  ($FE),A      
		IN   A,($FE)      
		AND  $40          
		LD   C,A          
		CP   A            
		
LD_BREAK:
		RET  NZ           
		
LD_START:  
		CALL LD_EDGE_1    
		JR   NC,LD_BREAK  
		
		LD   H, $00		;$80     ;In the Z802TZX commented loader code, this was $80, but in the binary hex code, it was 0.
	   
LD_LEADER: 
		LD   B, $75
		CALL LD_EDGE_2     
		JR   NC,LD_BREAK   
		LD   A, $B0        		;This was B2 in the commented code. 
		CP   B             
		JR   NC,LD_START   
		INC  H             
		JR   NZ,LD_LEADER  	   

LD_SYNC:   
		LD   B,$B0           
		CALL LD_EDGE_1       
		JR   NC,LD_BREAK     
		LD   A,B             
		CP   $C1             
		JR   NC,LD_SYNC      

		CALL LD_EDGE_1       
		RET  NC              
		LD   H, $00           
		LD   B, $80           
		JR   LD_MARKER       

LD_LOOP:   
		EX   AF,AF'          
		JR   NZ,LD_FLAG      
		LD   (IX+00),L       
		JR   LD_NEXT         

LD_FLAG:
		RL   C               
		XOR  L               
		RET  NZ              
		LD   A,C             
		RRA                  
		LD   C,A             
		JR   LD_FLNEXT       

LD_NEXT:
		;DEC  IX              	;Loading in reverse
		INC  IX              
		DEC  DE              
		
LD_FLNEXT :
		EX   AF,AF'          
		LD   B, $82           
		
LD_MARKER:
		LD   L, $01           

LD_8_BITS: 
		CALL LD_EDGE_2       
		RET  NC              
		LD   A,COMPARE      ;

		CP   B               
		RL   L               
		LD   B, $80           
		JR   NC,LD_8_BITS    

		LD   A,H             
		XOR  L               
		LD   H,A             
		LD   A,D             
		OR   E               
		JR   NZ,LD_LOOP      
		LD   A,H             
		CP   $01             
		RET                  


LD_EDGE_2:
		CALL LD_EDGE_1       
		RET  NC              

LD_EDGE_1:
		LD   A,DELAY         	;

LD_DELAY:
		DEC  A               
		JR   NZ,LD_DELAY     
		AND  A               

LD_SAMPLE:
		INC  B               
		RET  Z               
				
		IN   A,($FE)         
		XOR  C               
		AND  $40             
		JR   Z,LD_SAMPLE     
		
		IFDEF SHOW_LOAD_PROGRESS
		
		LD   A, C             		
		XOR  $47			;alternate sample bit and border color    
		LD   C, A
		
		LD	 A, D			;get 8K block to color mapping
		AND  %11100000
		RLCA
		RLCA
		RLCA				
		OR  C
		XOR %111			;alternate border color again
		
		ELSE
		
		LD   A, C             		
		XOR  $40 | BORDER_COLOUR
		LD   C, A
		
		ENDIF
		
		AND  %111			;keep border colors, exclude sample status in bit 6.
		OR   $08			;shut off mic             
		OUT  ($FE),A        ;out for border color and mic off
		
		SCF                  
		RET                   
		
LoadError:
	ld		bc, $ffff
LoadErrorLoop:
	ld		a, r	
	out		($fe), a	
	dec		bc
	ld		a, b
	or		c
	jr		nz, LoadErrorLoop
	ret			