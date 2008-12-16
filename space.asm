TITLE NAVE SB
.MODEL SMALL
.STACK 100h

.DATA
; Teclas
CR 						EQU		0Dh
LF						EQU		0Ah
TECLA_ESC				EQU		1Bh
ESQUERDA    			EQU     4Bh
DIREITA     			EQU     4Dh

; JOGADOR
NAVE_JOGADOR_FREN		DB		' ', ' ',176,' ',176,' ',"$"	
NAVE_JOGADOR_MEIO		DB		' ', ' ',219,176,219,' ',"$"
NAVE_JOGADOR_TRAS		DB		' ', 176,219,219,219,176,' ', "$" 	

POS_NAVE_X				DB		42		;Posição Inicial do carro na tela

NUMERO_VIDAS            DB      03d

;INIMIGO
DIR_NAVE_INIMIGA		DB		'D'
POS_NAVES_INIMIGAS_X    DB     00d, 10d, 20d, 30d
AUX_MOV                    DB      ?

; Flags
PAUSED                  DB      'J'

; Debug
DEBUG_STRING            DB      'WTF'




.CODE

MAIN PROC 
	MOV	AX,	@DATA
	MOV	DS,	AX
	
	CALL DESENHA_FUNDO_PADRAO
	GAME_LOOP:
	    ; condições de parada
	    CMP NUMERO_VIDAS, 00d
	    JE FIM_JOGO
	    
	    ; entrada de dados
	    CALL KBHIT
        CMP PAUSED, 'P' ;VERIFICA SE ESTÁ PAUSADO, SE ESTIVER FAZ NADA
        JE PAUSA
        
        ;lógica
        CALL MOVE_NAVES_INIMIGAS
        
        PAUSA:
        ; Desenho
        CALL DESENHA
        
				
		;DELAY :D
		CALL DELAY
		
	JMP GAME_LOOP
	
	FIM_JOGO:
	MOV AH, 4Ch
	INT 21h

MAIN ENDP

DESENHA PROC
    ;CALL DEBUG_MSG
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
		
		CMP AL, CR          ; Pausa o jogo
		JE PAUSE_SWITCH
		
		CMP PAUSED, 'P' ; Verifica se está pausado, verdadeiro termina o kbhit
		JE KBHIT_END
			
		CMP AH,'M'
		JE ACERTA_NAVE_DIREITA
		
		CMP AH,'K'
		JE ACERTA_NAVE_ESQUERDA
		
		JMP KBHIT_END ; Outra tecla
		
		TIRA_VIDA:
		    DEC NUMERO_VIDAS
		    JMP KBHIT_END
		    ;DEC 
		
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
        
	        JMP KBHIT_END
			
		PAUSE_SWITCH:           ; Pausa e despausa
		    CMP PAUSED, 'P' 
		    JE UNPAUSE          ; tira pausa se estiver pausado
		    MOV PAUSED, 'P'     ; pausa
		    JMP KBHIT_END
		    UNPAUSE:
		        MOV PAUSED, 'J'
		    JMP KBHIT_END
		    
			    
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
	DESENHA_RETANGULO 00Ah  0000h 184Fh
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
	
	MOV CX,1000
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
	PUSH BX

    MOV CL, 04h
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    DRAW_ENEMY:
        MOV DL, [BX]
        MOV AUX_MOV, DL
    	GOTOXY AUX_MOV 1
	    WRITE_STRING NAVE_JOGADOR_MEIO
	
	    GOTOXY AUX_MOV 2
	    WRITE_STRING NAVE_JOGADOR_FREN
	    
        INC BX
        LOOP DRAW_ENEMY
	


    CALL ESCONDE_CURSOR

    POP BX
	POP DX
	POP CX
	
	RET
DESENHA_NAVE_INIMIGA ENDP

MOVE_NAVES_INIMIGAS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV CL, 04h
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    MOVE_ALL:
        CALL MOVE_NAVE_INIMIGA
        INC BX
        LOOP MOVE_ALL
        
    
    POP CX
    POP BX
    POP AX
MOVE_NAVES_INIMIGAS ENDP

MOVE_NAVE_INIMIGA PROC	
    PUSH CX
    PUSH DX
    
    MOV DL, [BX]
    MOV AUX_MOV, DL

	CMP AUX_MOV, 0D
	JE NAVE_INIMIGA_DIR
	
	CMP AUX_MOV, 73D
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
		MOV DL, AUX_MOV
		INC DL
		MOV AUX_MOV, DL
		JMP FIM_MOVE_NAVE_INIMIGA
		
	MOV_NAVE_INIMIGA_ESQ:
		MOV DL, AUX_MOV
		DEC DL
		MOV AUX_MOV, DL	
	
	FIM_MOVE_NAVE_INIMIGA:
	CALL ESCONDE_CURSOR
		
    MOV DL, AUX_MOV
	MOV [BX], DL
	
	POP DX
	POP CX
	
	RET
MOVE_NAVE_INIMIGA ENDP

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

DEBUG_MSG PROC
    PUSH CX
    PUSH DX
    PUSH BX
    
    GOTOXY 30 10
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    WRITE_STRING [BX], '$'
    
    CALL ESCONDE_CURSOR
    
    POP BX
    POP DX
    POP CX
    
    RET
DEBUG_MSG ENDP

END MAIN
