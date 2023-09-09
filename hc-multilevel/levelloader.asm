	device	zxspectrum48

pageout:	equ	$700
shadowram:	equ	$2800
sectorbuff:	equ	shadowram  + 000	;len=256
aubuf:		equ	sectorbuff + 256	;len= 16
fullname:	equ	aubuf      + 016	;len= 11
extpos:		equ	fullname   + 011	;len=  1 ; (0..127)
extnr:		equ	extpos     + 001	;len=  1
aupos:		equ	extnr	   + 001	;len=  1 ; (0..7)
sectpos:	equ	aupos      + 001	;len=  1 ; pozitia sectorului in AU (0..7)
spsave:		equ	sectpos    + 001	;len=  2 ;
intsave:	equ	spsave	   + 002	;len=  1 ;
rwts:		equ	4773

		org	10830
start:
;************************************************************************************
;* incarca de pe discheta fisierul cu numele specificat in (HL)
;* in memorie la adresa si lungimea din headerul fisierului
;************************************************************************************
loadfile:	ld	(spsave),sp	;salveaza vechiul SP
		ld	a,i		
		ld	(intsave),a	;salveaza registrul I
		ld	a,41
		ld	i,a		;I=41
		ld	sp,10592	;SP nou
		call	prepfname	;se pregateste sirul nume ajustat cu spatii.
		call	init		;initializari
		call	getnextsector
		ld	hl,sectorbuff+1
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	l,9		;point to filedata
;pana acum: BC=lungime DE=adresa incarcare HL=adresa inceput date
		push	hl		;se verifica
		ld	hl,247		;daca numarul de bytes ramasi
		cp	a		;de incarcat este
		sbc	hl,bc		;mai mare de 247
		pop	hl		;
		jr	c,multisect	;daca da se continua cu incarcarea restului de sectoare
		ldir			;daca nu transfera singurul sector si iesire
		jr	loaddone
multisect:	push	bc		;salvare lungime
		ld	bc,247
		ldir			;transfer primul sector
		pop	hl		;lungime ramasa
		ld	bc,247
		cp	a
		sbc	hl,bc		;ajustare lungime ramasa
		push	hl		;salvare din HL
		pop	bc		;in BC
;pana aici BC contine lungimea ramasa de incarcat, DE=adresa de incarcare incrementata de LDIR
loadloop:	push	bc
		call	getnextsector
		pop	bc
		ld	hl,sectorbuff
		push	hl
		ld	hl,256
		cp	a
		sbc	hl,bc
		pop	hl
		jr	c,midsect
lastsect:	ldir
		jr	loaddone
midsect:	push	bc
		ld	bc,256
		ldir
		pop	bc
		dec	b
		jr	loadloop
loaddone:	ld	a,(intsave)
		ld	i,a		;restaureaza vechiul I
		ld	sp,(spsave)
		jp	pageout

;************************************************************************************
;* se initializeaza cateva variabile de program
;************************************************************************************
init:		xor	a
		ld	b,4
		ld	hl,extpos
init1:		ld	(hl),a
		inc	hl
		djnz	init1
		ret

;************************************************************************************
;* se initializeaza sirul nume completat cu spatii pana la 11 caractere
;* INPUT: HL=adresa sirului nume utilizator (primul octet=lungime sir)
;************************************************************************************
prepfname:	ld	de,fullname	;se umple bufferul nume
		ld	b,11		;ajustat cu 11 spatii
		ld	a,32
spatiu:		ld	(de),a
		inc	de
		djnz	spatiu		;sfarsit ajustare spatii
		ld	c,(hl)		;in registrul BC
		ld	b,0		;se incarca lungimea numelui
		inc	hl		;hl = inceputul sirului
		ld	de,fullname	;in DE destinatia
		ldir			;se tranfera in bufferul nume ajustat
		ret

;************************************************************************************
;* rutina conversie AU in track si cector
;* INPUT  <- HL = AU  (0..319)
;* OUTPUT -> L=Track (0..79) H=Sector (0..31)
;************************************************************************************
au2ts:		rrc	l
		rrc	l
		ld	a,l
		and	192
		rrc	a
		rrc	a
		rrc	a
		or	h
		ld	h,a
		ld	a,l
		and	63
		ld	l,a
		ld	a,h
		and	3
		rrc	a
		rrc	a
		or	l
		ld	l,a
		ld	a,h
		and	24
		ld	h,a
		ret

;************************************************************************************
;* aduce primul/urmatorul sector al fisierului de pe disk in buffer
;* INPUT: nimic    OUTPUT:sectorbuff <- T,S de pe discheta
;************************************************************************************
getnextsector:	push	de		;salveaza DE
		ld	a,(sectpos)	;pozitia sectorului in AU
		push	af
		cp	0
		jr	nz,nonextau
		call	getnextau
		call	au2ts
		ld	(track),hl	;set track and sector
nonextau:	pop	af
		inc	a
		cp	8
		jr	nz,gnsexit
		xor	a
gnsexit:	ld	(sectpos),a
		;out	(254),a		;flick border
		ld	bc,ioblock
		call	rwts		;citeste fizic track si sector fisier
		di
		ld	hl,sector
		inc	(hl)
		pop	de
		ret

;************************************************************************************
;* INPUT:  nimic
;* OUTPUT: se intoarce in HL urmatoarea unitate de alocare (grup) a fisierului
;************************************************************************************
getnextau:	ld	a,(aupos)	;citesc pozitia AU (0..7)
		cp	0
		jr	nz,noread	;daca <> 0 nu se aduc urm. 8 AU din extensii
		push	af		;prezervam A
		call	get8au		;se culeg urmatoarele 8 AU (sau primele 8 dupa caz)
		pop	af		;...
noread:		rlca			;dublez pozitia pt obtinere deplasament in buffer
		ld	c,a		;stocare deplasament
		ld	b,0		;in BC
		ld	hl,aubuf	;in HL inceput buffer 8 AU
		add	hl,bc		;se obtine adresa fizica a AU in HL
		ld	e,(hl)		;se citeste in DE
		inc	hl		;unitatea de alocare (GRUPUL)
		ld	d,(hl)		;dorit
		push	de		;se copiaza
		pop	hl		;in reg HL
		ld	a,(aupos)
		inc	a
		cp	8
		jr	nz,goodau
		xor	a
goodau:		ld	(aupos),a
		ret

;************************************************************************************
;* input:  nimic
;* output: 8 AU will be copied from next extent matching filename into extent buffer	
;************************************************************************************
get8au:		ld	a,255		;se seteaza
		ld	(sector),a	;citirea fizica implicita
getaunext:	ld	a,(extpos)	;pozitia extensiei in catalog
		cp	128		;s-a terminat catalogul?
		jr	z,halt		;fisierul nu exista sau este deteriorat, etc.
		rrca
		rrca
		rrca
		ld	b,a		;salveaza A pentru bitii 7..5 (restul)
		and	31		;mascheaza catul
		ld	c,a		;acum C contine numarul sectorului in care este extensia dorita
		ld	a,b		;restaureaza A
		rrca			;pune bitii 7..5 in bitii 2..0
		rrca
		rrca
		rrca
		rrca
		and	7		;mascheaza bitii 2..0 pentru a obtine restul
		ld	b,a		;acum B contine pozitia extensiei in sector (0..7)
		ld	a,(sector)	;incarca ultimul sector citit in A
		cp	c		;compara cu sectorul extensiei dorite
		jr	z,samesector	;salt daca este acelasi sector (nu se mai citeste de pe disc)
		ld	a,c		;daca sectorul este diferit atunci
		ld	(sector),a	;se incarca in ioblock
		xor	a
		ld	(track),a	;se incarca track0 in ioblock
		push	bc		;se salveaza bc (pozitia extensiei se afla in C)
		ld	bc,ioblock	;se incarca
		call	rwts		;sectorul de pe disk
		di			;rwts activeaza intreruperile la iesire
		pop	bc		;restaurare pozitia extensiei
samesector:	ld	ix,sectorbuff	;in IX bufferul de sector citit
		ld	a,b		;se multiplica pozitia extensiei cu 32
		rlca			;pentru a obtine
		rlca			;deplasamentul extensiei in cadrul
		rlca			;sectorului
		rlca
		rlca
		ld	b,0
		ld	c,a		;acum BC contine deplasamentul extensiei in cadrul bufferului de sector
		add	ix,bc		;se aduna cu inceputul bufferului => IX=adresa extensiei
		ld	a,(ix)		;extensia este utilizata?
		cp	0
		jr	nz,nextau	;daca nu treci la urmatoarea extensie din catalog
		ld	a,(ix+12)	;se compara numarul extensiei
		ld	hl,extnr	;cu numarul extensiei
		cp	(hl)		;dorit
		jr	nz,nextau	;dca nu sunt egale se reia cu urmatoarea extensie
		inc	ix		;IX=nume fisier din extensie
		ld	hl,fullname	;numele ajustat cu spatii pana la 11 caractere
		ld	b,11		;ciclu pentru toate cele 11 caractere
galoop1:	ld	a,(ix)		;se preia numele litera cu litera din extensia curenta
		and	127		;se mascheaza bitul 7 (SYS sau R/O)
		cp	(hl)		;se compara cu numele ajustat
		jr	nz,nextau	;daca una din litere nu se potriveste trece la urmatoarea extensie
		inc	hl		;incrementare pozitie in numele ajustat
		inc	ix		;incrementare pozitie in numele din extensie
		djnz	galoop1		;reia cu urmatorul caracter
		push	ix		;estensia este cea cautata
		pop	hl		;in HL urmatoarea pozitie dupa numar extensie
		ld	c,4		;B este deja 0, se ajusteaza pentru pozitia AU0 in extensie
		add	hl,bc		;se copiaza 8 AU in
		ld	de,aubuf	;bufferul AU (16 bytes)
		ld	bc,16		;indiferent daca nu toate 8
		ldir			;sunt folosite
		ld	hl,extpos	;se incrementeaza pozitia extensiei
		inc	(hl)		;in catalog
		ld	hl,extnr	;se incrementeaza numarul extensiei
		inc	(hl)		;pentru urmatoarea extensie a fisierului
		ret			;terminare rutina
nextau:		ld	hl,extpos	;avanseaza la
		inc	(hl)		;urmatoarea extensie din catalog
		jr	getaunext	;reia ciclul pentru noua extensie

;**********************************
;* face border rosu si opreste cpu
;**********************************
halt:		di
		ld	a,2
		out	(254),a
		halt
		
ioblock:
blocktype:	db	1
drivenr:	db	0
volumenr:	db	0
track:		db	0
sector:		db	255
dma:		dw	sectorbuff
extbuf:		dw	2932h
drivetable:	dw	1feah
rwtscmd:	db	1
rwtsresult:	db	255
vlnrread:	db	255
rwtswksp:	ds	4,255


.end

		savebin	"lvlldr.bin",start,.end-start 
