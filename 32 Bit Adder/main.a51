$include (hska_include.inc)

VARS SEGMENT DATA;
RSEG VARS
	Stack:		DS 20		; Variablen für erste 32 Bit Zahl initialisieren 
	NUM1_LSB:	DS 1
	NUM1_B1:	DS 1
	NUM1_B2:	DS 1
	NUM1_MSB:	DS 1
	
	NUM2_LSB:	DS 1		; Variablen für zweite 32 Bit Zahl initialisieren 
	NUm2_B1:	DS 1
	NUm2_B2:	DS 1
	NUm2_MSB:	DS 1
	
	RES_LSB:	DS 1		; Variablen für das Ergebnis initialisieren 
	RES_B1:		DS 1
	RES_B2:		DS 1
	RES_MSB:	DS 1
	RES_CARRY:	DS 1

CSEG AT 0x0;
jmp INIT_DATA

ORG 0x100
	ARRAY: DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E
		//		 0,	   1,    2,    3,    4,    5,    6,    7,    8,    9,    A,    B,    C,    D,    E,    F
	
INIT_DATA:
	mov 	NUM1_LSB, #0x67		; Zahl 1 im Zweierkomplement für Addition, hier die 0x00654321, eine 6636321 Dezimal
	mov 	NUM1_B1, #0x89
	mov 	NUM1_B2, #0xAB
	mov 	NUM1_MSB, #0xCD
	
	mov 	NUM2_LSB, #0x67		; Zahl 2 im Zweierkomplement für Addition, hier die 0x00654321, eine 6636321 Dezimal
	mov 	NUm2_B1, #0x89
	mov 	NUm2_B2, #0xAB
	mov 	NUm2_MSB, #0xCD
	
	mov P4_DIR, #0xFF
	mov	P3_DIR, #0xFF
	
MAIN:

	mov		A, NUM2_LSB			; LSB Addieren
	addc	A, NUM1_LSB
	mov		RES_LSB, A
	
	mov		A, NUM2_B1			; B1 Addieren
	addc	A, NUM1_B1
	mov		RES_B1, A
	
	mov		A, NUM2_B2			; B2 Addieren
	addc	A, NUM1_B2
	mov		RES_B2, A
	
	mov		A, NUM2_MSB			; MSB Addieren
	addc	A, NUM1_MSB
	mov		RES_MSB, A
	
	clr 	A					; Wert aus Carry in RES_CARRY schreiben
	RLC		A
	mov 	RES_CARRY, A

ZIFFER2SEGMENT:
	mov 	DPTR, #ARRAY		; Erste Ziffer codieren und über P4_DATA an die Anzeige shcicken
	mov		A, RES_LSB
	ANL		A, #0x0F
	movc	A, @A+DPTR
	mov 	P4_DATA, A
	
	mov 	A, RES_LSB
	ANL 	A, #0xF0
	
	mov R4, #04					; Erste Ziffer codieren und über P4_DATA an die Anzeige shcicken
	ROTATE:						; Um Array benutzen zu können, Accu 4 mal nach rechts rotieren um den Wert am Anfang des Arrays stehen zu haben
		RR A
		DJNZ R4, ROTATE
		
	movc	A, @A+DPTR
	mov		P3_DATA, A
END