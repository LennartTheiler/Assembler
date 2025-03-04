$include (hska_include.inc)

VARS SEGMENT DATA
RSEG VARS
	STACK: 		DS 20
	COUNTER: 	DS 1
	FLAG:		DS 1

CSEG AT 0x00;
	jmp INIT

ORG 0x0B
	jmp ISR_T0

ORG 0x100;
	
	
	
INIT: 
	mov sp, #STACK
	mov P3_DIR,	#0xFF
	mov FLAG,	#0x00
	mov TCON, 	#0x00
	mov TMOD,	#0x01;
	mov TL0,	#0xA0		;Enable timerinterrupt
	mov TH0,	#0x15		;Enable global interrupt
	mov COUNTER, #200
	setb TR0
	setb ET0
	setb EA
	
MAIN:
	//mov a, COUNTER
	mov a, FLAG				; Polling
	jz MAIN					;jump zero
	mov FLAG, 	#0x00
	dec COUNTER
	mov a, COUNTER
	jnz MAIN				;jump not zero; Überprüft den Akku. Wenn A!=0, springt er. Bei A=0 wird das Programm weiter ausgeführt
	
	
	inc P3_DATA
	jmp MAIN

ISR_T0:
	mov TL0,	#0xA0
	mov TH0,	#0x15
	//dec COUNTER
	mov FLAG, 	#0xFF; Set Flag
	reti


END