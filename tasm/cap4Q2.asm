TITLE Programa para capturar as iniciais de um usuario e mostra-las em uma coluna

.MODEL SMALL
.STACK 100h

.DATA
CR        EQU 0Dh
LF        EQU 0Ah
LETRA1    DB ?
LETRA2    DB ?
LETRA3    DB ?
MENSAGEM1 DB 'Digite as tres primeiras letras de seu primeiro nome: $'
MENSAGEM2 DB CR,LF,'Estas letras organizadas em coluna sao: $'

.CODE
MAIN PROC

; Apontando DS para o segmento de dados do programa
MOV AX,@DATA
MOV DS,AX
; Exibindo a MENSAGEM1
LEA DX,MENSAGEM1 ; DX contera o offset onde se inicia esta string (MENSAGEM1)
MOV AH,09h
INT 21h
; Capturando as tres letras
MOV AH,01h
INT 21h
MOV LETRA1,AL
INT 21h
MOV LETRA2,AL
INT 21h
MOV LETRA3,AL
; Exibindo a MENSAGEM2
LEA DX,MENSAGEM2
MOV AH,09h
INT 21h
; Imprimindo os tres caracteres
MOV AH,02h
MOV DL,CR
INT 21h
MOV DL,LF
INT 21h
MOV DL,LETRA1
INT 21h
MOV DL,CR
INT 21h
MOV DL,LF
INT 21h
MOV DL,LETRA2
INT 21h
MOV DL,CR
INT 21h
MOV DL,LF
INT 21h
MOV DL,LETRA3
INT 21h

; Finalzando - voltando ao DOS
MOV AH,4Ch
INT 21h

MAIN ENDP

	END MAIN