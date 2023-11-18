;Turbo loader extracted from Z802TZX utility by Tomaz Kac  (tomcat@sgn.net).

;Is originally cofigured using 4 loading speeds (baud rate): 1364 (ROM-like), 2250, 3000, 6000.
;Speeds up to 3000 baud can be used with a tape recorder, 6000 only works with PC output.
;Other tools exist that can produce even faster speeds, like 17000 baud, but I found those less reliable, even with the PC output: 
; - ZQLoader: https://github.com/oxidaan/zqloader
; - Otla: https://github.com/sweetlilmre/otla .


		DEVICE ZXSPECTRUM48		
		
		IF BAUD == 1364		;ROM timings
COMPARE 	EQU $80 + 41
DELAY 		EQU 20
		ELSEIF BAUD == 2250
COMPARE 	EQU $80 + 24
DELAY 		EQU 11
		ELSEIF BAUD == 3000
COMPARE 	EQU $80 + 18
DELAY 		EQU 7
		ELSEIF BAUD == 6000
COMPARE 	EQU $80 + 7
DELAY 		EQU 3
		ELSE
COMPARE 	EQU $80 + 7
DELAY 		EQU 3		
		ENDIF

BORDER_COLOUR 		EQU 2	;RED border

/*
LD_BLOCK:  
		CALL LD_BYTES     
		RET  C            
		RST  0008;,ERROR_1 
		DEFB $1A ; R Tape
*/		
		  
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

		LD   A,C             
		XOR  $40 | BORDER_COLOUR          

		LD   C,A             
		AND  $07             
		OR   $08             
		OUT  ($FE),A         
		SCF                  
		RET                   