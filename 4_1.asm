SSTACK SEGMENT STACK
    DW 64 DUP(?)
SSTACK ENDS
 
CODE SEGMENT
    ASSUME CS:CODE
 
START: 
    MOV DX, 0686H  ;8255控制端口地址，选取的IOY2端口
    MOV AL, 90H    ;8255控制字，90H=10010000B，表示A口输入，B口输出
    OUT DX, AL     ;将上述控制字写入控制端口
 
MI:
    MOV DX, 640H   ;启动A/D采样
    OUT DX, AL
 
    CALL DELAY
    IN AL, DX      ;读A/D采样结果
 
    MOV DX, 0682H
    OUT DX,AL
    JMP MI
 
DELAY:             ;延时程序
    PUSH CX        ;保护现场
    PUSH AX
    MOV CX,0FFFFH;
L1：LOOP L1    
    POP AX 
    POP CX 
    RET
 
CODE ENDS 
    END START