TITLE Programa para somar dois numeros inteiros menores do que 10

.MODEL SMALL
.STACK 100h
.DATA
CR        EQU 0Dh
LF        EQU 0Ah
NUM1      DB ?
NUM2      DB ?
MENSAGEM1 DB 'A soma de $'
MENSAGEM2 DB ' vale $'

.CODE

MAIN PROC

; Inicializando o registrador DS
MOV AX,@DATA
MOV DS,AX

; Apresentar o simbolo de interrogacao
MOV AH,02h
MOV DL,'?'
INT 21h
; Capturar o primeiro numero
MOV AH,01h
INT 21h
MOV NUM1,AL
; Capturar o segundo numero
MOV AH,01h
INT 21h
MOV NUM2,AL
;  Saltar linha
MOV AH,02h
MOV DL,CR
INT 21h
MOV DL,LF
INT 21h

; Exibindo a MENSAGEM1
LEA DX,MENSAGEM1
MOV AH,09h
INT 21h

MOV AH,02h
MOV DL,NUM1
INT 21h
MOV DL,' '
INT 21h
MOV DL,'e'
INT 21h
MOV DL,' '
INT 21h
MOV DL,NUM2
INT 21h

; Exibindo a MENSAGEM2
LEA DX,MENSAGEM2
MOV AH,09h     
INT 21h        

; Exibindo a soma entre NUM1 e NUM2
MOV AH,02h
MOV DL,NUM1
ADD DL,NUM2
SUB DL,30h
INT 21h

MOV AH,4Ch
INT 21h

MAIN ENDP

	END MAIN