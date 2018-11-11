A8255_CON EQU 0606H
A8255_A EQU 0600H
A8255_B EQU 0602H
A8255_C EQU 0604H
DATA	SEGMENT
	TABLE2	DB	3FH
			DB	06H
			DB	5BH
			DB	4FH
			DB	66H
			DB	6DH
			DB	7DH
			DB	07H
			DB	7FH
			DB	6FH
			DB	77H
			DB	7CH
			DB	39H
			DB	5EH
			DB	79H
			DB	71H
	LED1	DB  10H
	LED2	DB	10H
	LED3	DB	10H
	LED4	DB	10H
	LED5	DB	10H
	LED6	DB	10H
	LOC		DB	00H
	FLAG	DB	00H
	TABLE1	DB	11101110B
			DB	11101101B
			DB	11101011B
			DB	11100111B
			DB	11011110B
			DB	11011101B
			DB	11011011B
			DB	11010111B
			DB	10111110B
			DB	10111101B
			DB	10111011B
			DB	10110111B
			DB	01111110B
			DB	01111101B
			DB	01111011B
			DB	01110111B
	COUNT	DB 	00H
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS:CODE,DS:DATA
START:		MOV	AX,DATA
			MOV	DS,AX
			LEA	SI,LED1
			LEA	DI,TABLE1
			MOV	DX,A8255_CON
			MOV	AL,10000001B
			OUT	DX,AL
ZZ1:		CALL	SHOW
			CALL	DELAY
			CALL	CLEAR
			MOV	DX,A8255_A
			MOV	AL,00H
			OUT	DX,AL
			
			MOV	DX,A8255_C
			IN	AL,DX
			
			AND	AL,0FH
			CMP	AL,0FH
			JZ	ZZ1
			
			MOV	BH,AL

			MOV	AH,11111110B
			MOV	CX,4
ZZ4:		MOV	DX,A8255_A
			MOV	AL,AH
			OUT	DX,AL
			MOV	DX,A8255_C
			IN	AL,DX
			AND	AL,0FH
			CMP	AL,0FH
			JNZ	ZZ5
			ROL	AH,1
			LOOP	ZZ4
			JMP	ZZ1

ZZ5:		AND	AH,0FH
			MOV	BL,AH
			MOV	CL,4
			SHL BH,CL
			OR	BL,BH
			CMP	BL,77H
			JZ	ZZ7
			MOV	AL,BL
			MOV	CL,0
			
ZZ2:		CMP	AL,[DI]
			JZ	ZZ3
			INC	CL
			INC	DI
			CMP	CL,10H
			JNZ	ZZ2
			LEA	DI,TABLE1
			JMP	ZZ1
ZZ3:		CALL DELAY1
			CALL	CHANGE
			LEA	DI,TABLE1
			JMP	ZZ1			
			
ZZ7:		CALL	CLEAR
ZZ8:			JMP	ZZ8			
			
SHOW	PROC	NEAR
			PUSH	CX
			PUSH	BX
			PUSH	AX
			PUSH	SI
			PUSH	DI
			MOV	CX,6
			MOV	AH,11011111B
			LEA	SI,LED1
			LEA	DI,TABLE2
			
XX1:		MOV	AL,[SI]
			CMP	AL,10H
			JZ	XX2
			MOV	DX,A8255_A
			MOV	AL,AH
			OUT	DX,AL
			MOV	DX,A8255_B
			MOV	BL,[SI]
			XOR	BH,BH
			MOV	AL,[BX+DI]
			OUT	DX,AL
			
XX2:		INC	SI
			ROR	AH,1
			CALL	DELAY
			LOOP	XX1
			
			
			POP		DI
			POP		SI						
			POP		AX
			POP		BX
			POP		CX
			RET
SHOW	ENDP

CHANGE	PROC	NEAR
		PUSH	SI
		PUSH	DI
		PUSH	CX
		PUSH	AX
		PUSH	BX
		MOV	BL,CL
		LEA		SI,LED1
		MOV	CX,6
WW1:	MOV	AL,10H
		MOV	[SI],AL
		INC	SI
		LOOP	WW1
		CMP	FLAG,01H
		JZ	WW2
		CMP	LOC,06H
		JZ	WW4
		INC	LOC
		JMP	WW3
WW4:	MOV	FLAG,01H
		JMP	WW3
		
		
WW2:	CMP	LOC	,01H
		JZ	WW5
		DEC	LOC
		JMP	WW3
WW5:	MOV	FLAG,00H

WW3:	LEA	SI,LED1
		MOV	AL,LOC
		DEC	AL
		XOR	AH,AH
		ADD SI,AX
		MOV	[SI],BL
		POP		BX
		POP		AX
		POP		CX
		POP		DI
		POP		SI
		RET
CHANGE	ENDP



CLEAR	PROC	NEAR
		PUSH	AX
		MOV	DX,A8255_B
		MOV	AL,00H
		OUT	DX,AL
		POP		AX
		RET
CLEAR	ENDP

DELAY	PROC	NEAR
		PUSH	CX
		MOV		CX,00FFH
AA1:	LOOP	AA1
		POP		CX
		RET
DELAY	ENDP

DELAY1	PROC	NEAR
		PUSH	CX
		MOV	CX,0FFFFH
BB1:	LOOP	BB1
		MOV	CX,0FFFFH
BB2:	LOOP	BB2
		POP	CX
		RET
DELAY1	ENDP
CODE	ENDS
END	START