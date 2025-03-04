$include (hska_include.inc)

VARS SEGMENT DATA
RSEG VARS
	STACK: 		DS 10
	SendByte: 	DS 1
	Flag:	 	DS 1

CSEG AT 0x00
jmp INIT

ORG 0x23 ;ISR1
	jmp ISR
	

ORG 0x100
INIT:
	mov Flag, 0x0
	mov SendByte, 0x30
	mov P1_DIR, 	#0x02
	mov P3_DATA,	#0xFF
	mov P3_DIR,		#0x00
	
	;UART
	mov MODPISEL, 	#0x00
	mov PORT_PAGE, 	#2
	mov P1_ALTSEL0, #0x01
	mov P1_ALTSEL1, #0x02
	mov PORT_PAGE, 	#0
	
	;BAUDRATE 9600 / BR_VALUE+1, also -1 rechnen
	mov BCON,		#0x00
	mov BG, 		#155
	mov BCON,		#0x81
	mov SCON,		#0x50
	
	;INTER. oder Polling
	setb ES			;enable interrupts
	setb EA
	setb TI


MAIN:
	mov A, Flag
	JZ Main
	mov Flag, #0x00
	Mov SBUF, Sendbyte
	
	inc Sendbyte
	
	mov A, #0x60
	CJNE A, SendByte, MAIN
	mov SendByte, #0x30
	jmp MAIN


ISR:				//Shared Interrupt (ALso abfragen warum INterrupt ausgelöst
	jnb RI, ISR1;
	clr RI
	mov P3_DATA, SBUF	//todo: nicht beide das gleiche Falg setzen
	
ISR1:
	jnb TI, ISR2
	clr TI
	mov Flag, #0x01
	
ISR2:
	reti
END