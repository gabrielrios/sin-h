TITLE DOBRO
.MODEL SMALL
.STACK 100h
.DATA

CR EQU 0Ah
LF EQU 0Dh

MSG DB 'DIGITE UM NUMERO (ENTRE 1 E 9): $'
MSG1 DB 'SEU DOBRO VALE: $'
B DB ?
N DB ?

.CODE
MAIN PROC

MOV DX,@DATA
MOV DS,DX

MOV AH,9
LEA DX,MSG
INT 21h

MOV AH,1
INT 21h
MOV N,AL

CALL DOBRO

;-------------------------------------

DOBRO PROC

MOV DL,N
ADD N,DL

SUB N,30h

CMP N,39h
JG SEGUE
MOV B,30h
JMP FIM

SEGUE:

MOV B,31h
SUB N,10d

DOBRO ENDP

FIM:

MOV AH,2
MOV DL,CR
INT 21h
MOV DL,LF
INT 21h

MOV AH,9
LEA DX,MSG1
INT 21h

MOV AH,2
MOV DL,B
INT 21h
MOV DL,N
INT 21h

MOV AH,4Ch
INT 21h

MAIN ENDP
END MAIN