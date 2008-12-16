TITLE NAVE SB
.MODEL SMALL
.STACK 100h

.DATA
CR 						EQU		0Dh
LF						EQU		0Ah



STR_TITULO	 			DB 		"     _________  ____  _____  ________   _____  _____  _______     _________ ",CR,LF
			 			DB 		"    |_   ___  ||_   \|_   _||_   ___ `.|_   _||_   _||_   __ \   |_   ___  |",CR,LF
			 			DB 		"      | |_  \_|  |   \ | |    | |   `. \ | |    | |    | |__) |    | |_  \_|",CR,LF
			 			DB 		"      |  _|  _   | |\ \| |    | |    | | | '    ' |    |  __ /     |  _|  _ ",CR,LF
			 			DB 		"     _| |___/ | _| |_\   |_  _| |___.' /  \ `--' /    _| |  \ \_  _| |___/ |",CR,LF
			 			DB 		"    |_________||_____|\____||________.'    `.__.'    |____| |___||_________|$"

						

TECLA_ESC				EQU		1Bh
ESQUERDA    			EQU     4Bh
DIREITA     			EQU     4Dh

NAVE_JOGADOR_FREN		DB		' ', ' ',176,' ',176,' ',"$"	
NAVE_JOGADOR_MEIO		DB		' ', ' ',219,176,219,' ',"$"
NAVE_JOGADOR_TRAS		DB		' ', 176,219,219,219,176,' ', "$" 	

POS_NAVE_X				DB		42		;Posição Inicial do carro na tela

DIR_NAVE_INIMIGA		DB		'D'
POS_NAVE_INIMIGA_X		DB		0D

.CODE

MAIN PROC 
	MOV	AX,	@DATA
	MOV	DS,	AX
	
	CALL DESENHA_FUNDO_PADRAO
	JOGANDO:
		CALL DESENHA
	JMP JOGANDO
	
	FIM_JOGO:
	MOV AH, 4Ch
	INT 21h

MAIN ENDP

DESENHA PROC
	CALL KBHIT
	CALL DESENHA_NAVE
	CALL DESENHA_NAVE_INIMIGA
	RET
DESENHA ENDP

KBHIT PROC
	PUSH AX
	PUSH DX
	
	INICIO_KBHIT:
	
		MOV AH,01h
		INT 16h 		; Retorna ZF = 0 se uma tecla foi pressionada
		JZ KBHIT_END 	; salta se ZF = 1, ou seja, se nada foi pressionado 
		
		MOV AH,10h
		INT 16h	;se alguma tecla foi pressionada lê o caracter pressionado
				
		CMP	AL,TECLA_ESC
		JE FIM_JOGO
		
		CMP AH,'M'
		JE ACERTA_NAVE_DIREITA
		
		CMP AH,'K'
		JE ACERTA_NAVE_ESQUERDA
		
		JMP KBHIT_END ; Outra tecla
		
		ACERTA_NAVE_DIREITA:
			CMP POS_NAVE_X, 73D
			JE KBHIT_END
			
			MOV AH, POS_NAVE_X
			INC AH
			MOV POS_NAVE_X, AH
			
			JMP KBHIT_END
			
		ACERTA_NAVE_ESQUERDA:
			CMP POS_NAVE_X, 0D ;Limita esquerdo na nave
			JE KBHIT_END
			
			MOV AH, POS_NAVE_X
			DEC AH
			MOV POS_NAVE_X, AH

	KBHIT_END:
	
		MOV	AH, 00h
       	INT 1Ah
       	
       	POP DX
       	POP AX
       	
	RET
KBHIT ENDP

;Função que apaga a tela
LIMPA_TELA MACRO
	PUSH AX
	MOV AH,00h
	MOV AL,03h
	INT 10h
	POP AX
ENDM

;Função que recebe uma string e escreve na tela
WRITE_STRING MACRO STRING

	PUSH AX
	PUSH DX
	
	MOV AH,9
	LEA DX,STRING
	INT 21h
	
	POP DX
	POP AX
	
ENDM

;Função que coloca o cursor na posicao X (HORIZONTAL)_ e Y (VERTICAL)
GOTOXY MACRO X,Y

	PUSH AX
	PUSH BX
	PUSH DX

	MOV AH,2
	MOV DL,X
	MOV DH,Y
	MOV BH,0
	INT 10h
	
	POP DX
	POP BX
	POP AX

ENDM

DESENHA_RETANGULO MACRO COR_FUNDO,INICIO_LINHA_COLUNA,FIM_LINHA_COLUNA
	
	MOV	AH,06h
	MOV AL,00h
	MOV	BH,COR_FUNDO
	MOV	CX,INICIO_LINHA_COLUNA 	; CH = inicio das linha  			CL = inicio das colunas
	MOV	DX,FIM_LINHA_COLUNA		; DH = tamanho da  parte vertical	DL = tamanho da parte horizontal
	INT	10h

ENDM

DESENHA_FUNDO_PADRAO PROC
	LIMPA_TELA
	;Fundo
	DESENHA_RETANGULO 09Fh  0000h 184Fh
	;Caixa do menu principal borda
	;DESENHA_RETANGULO 001h  020Ah 1646h 
	;DESENHA_RETANGULO 0CFh  030Bh 1545h 
	RET
DESENHA_FUNDO_PADRAO ENDP

ESCONDE_CURSOR PROC
	
	PUSH AX
	PUSH CX
	
	MOV	AX,0100h
	MOV CX,2607h
	INT 10h
	
	POP CX
	POP AX
	
	RET

ESCONDE_CURSOR ENDP

DELAY PROC

	PUSH AX
	PUSH CX
	
	MOV CX,10000
	LOOP1: 
		PUSH CX
		MOV CX, 8000
		LOOP2: 
			SUB AH,2
			ADD AH,2
			LOOP LOOP2
		
		POP CX
		LOOP LOOP1
	
	POP AX
	POP CX
	
	RET
	
DELAY ENDP

DESENHA_NAVE_INIMIGA PROC

	PUSH CX
	PUSH DX
	CALL DELAY
	
	GOTOXY POS_NAVE_INIMIGA_X 0
	WRITE_STRING NAVE_JOGADOR_MEIO
	
	GOTOXY POS_NAVE_INIMIGA_X 1
	WRITE_STRING NAVE_JOGADOR_FREN
	
	CMP POS_NAVE_INIMIGA_X, 0D
	JE NAVE_INIMIGA_DIR
	
	CMP POS_NAVE_INIMIGA_X, 73D
	JE NAVE_INIMIGA_ESQ
	
	CMP DIR_NAVE_INIMIGA, 'D'
	JE MOV_NAVE_INIMIGA_DIR

	CMP DIR_NAVE_INIMIGA, 'E'
	JE MOV_NAVE_INIMIGA_ESQ
	
	NAVE_INIMIGA_DIR:
		MOV DL, 'D'
		MOV DIR_NAVE_INIMIGA, DL
		JMP MOV_NAVE_INIMIGA_DIR
	
	NAVE_INIMIGA_ESQ:
		MOV DL, 'E'
		MOV DIR_NAVE_INIMIGA, DL
		JMP MOV_NAVE_INIMIGA_ESQ
	
	MOV_NAVE_INIMIGA_DIR: 
		MOV DL, POS_NAVE_INIMIGA_X
		INC DL
		MOV POS_NAVE_INIMIGA_X, DL
		JMP FIM_DESENHA_NAVE_INIMIGA
		
	MOV_NAVE_INIMIGA_ESQ:
		MOV DL, POS_NAVE_INIMIGA_X
		DEC DL
		MOV POS_NAVE_INIMIGA_X, DL	
	
	FIM_DESENHA_NAVE_INIMIGA:
	CALL ESCONDE_CURSOR
		
	POP DX
	POP CX
	
	RET
DESENHA_NAVE_INIMIGA ENDP

DESENHA_NAVE PROC

	PUSH CX
	PUSH DX
	
	GOTOXY POS_NAVE_X 22
	WRITE_STRING NAVE_JOGADOR_FREN
	
	GOTOXY POS_NAVE_X 23
	WRITE_STRING NAVE_JOGADOR_TRAS
	
	CALL ESCONDE_CURSOR
		
	POP DX
	POP CX
	
	RET
	
DESENHA_NAVE ENDP

END MAIN