DATA SEGMENT 
    SIGN DB 00H    ;通过在中断中改变该变量的值控制移动方向
DATA ENDS
CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA
START: 
    MOV AX, 0000H
    MOV DS, AX
 
    MOV DX, 0646H
    MOV AL, 90H
    OUT DX, AL
    MOV DX, 0642H
    MOV AL,80H
    OUT DX,AL
    ;将D7点，D6-D0熄灭
    MOV AX, OFFSET MIR6
    MOV SI, 0038H
    MOV [SI], AX
    MOV AX, CS
    MOV SI, 003AH
    MOV [SI], AX
 
    MOV AX, OFFSET MIR7
    MOV SI, 003CH
    MOV [SI], AX
    MOV AX, CS
    MOV SI, 003EH
    MOV [SI], AX
 
    CLI
    MOV AL, 11H
    OUT 20H, AL
    MOV AL, 08H
    OUT 21H, AL
    MOV AL, 04H
    OUT 21H, AL
    MOV AL, 01H
    OUT 21H, AL
    MOV AL, 3FH
    OUT 21H, AL
    STI
    ;与主实验相同部分此处不再赘述
    ;下面的AA1与AA2相当于两个主程序，控制灯的右移和左移
 	MOV	AX,DATA
 	MOV	DS,AX
 	MOV	BL,80H
MI:
    CMP SIGN,01H
    JZ AA2
AA1: 
    MOV DX, 0642H
    ;读入当前灯的状态
    CMP BL,01H
    JZ MI
    ;判断灯是否是最右侧亮，如果是则不变，不是则继续移动
    ROR BL,1
    ;将AL循环右移1位
    MOV CX,0FFFFH
L1:
    LOOP L1
    MOV CX,0FFFFH
L2:
    LOOP L2
    MOV CX,0FFFFH
L3:
    LOOP L3
    MOV CX,0FFFFH
L4:
    LOOP L4
    ;延时
    MOV	AL,BL
    OUT DX,AL
    ;从8255B口输出右移后的灯的状态
    JMP MI
 
AA2: 
    MOV DX, 0642H
    CMP BL,80H
    JZ MI
    ;判断灯是否是最左侧亮，如果是则不变，不是则继续移动
    ROL BL,1
    ;将AL循环左移1位
    MOV CX,0FFFFH
L5:
    LOOP L5
    MOV CX,0FFFFH
L6:
    LOOP L6
    MOV CX,0FFFFH
L7:
    LOOP L7
    MOV CX,0FFFFH
L8:
    LOOP L8
    ;延时
    MOV	AL,BL
    OUT DX,AL
    ;从8255B口输出右移后的灯的状态
    JMP MI
 
MIR6:
    STI
    MOV SIGN,00H
    ;按下KK1+，灯右移，跳转到AA1
    MOV AL,26H
    OUT 20H,AL
    IRET
 
MIR7:  
    STI 
    MOV SIGN,01H
    ;按下KK2+，灯左移，跳转到AA2
    MOV AL,27H
    OUT 20H,AL
    IRET
 
CODE ENDS
    END START