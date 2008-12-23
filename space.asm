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
NAVE_JOGADOR_FREN		DB		' ',176,' ',176,"$"	
NAVE_JOGADOR_MEIO		DB		' ',219,176,219,"$"
NAVE_JOGADOR_TRAS		DB		176,219,219,219,176,' ', "$" 

POS_NAVE_X				DB		42		;Posição Inicial do carro na tela

NUMERO_VIDAS            DB      03d

;TIROS
TIRO                    DB      0BAh, "$"
MAX_TIROS               DB      5d
NUM_TIROS               DB      0d
TIROS                   DB      00d, 00d, 00d, 00d, 00d	
TIROS_X                 DB      00d, 10d, 20d, 30d, 40d
TIROS_Y                 DB      20d, 20d, 20d, 20d, 20d
TMP_TIRO_X              DB      ?
TMP_TIRO_y              DB      ?

Z                       DB      20d

;INIMIGO
DIR_NAVE_INIMIGA		DB		'D'
POS_NAVES_INIMIGAS_X    DB      00d, 10d, 20d, 30d
POS_NAVES_INIMIGAS_Y    DB      01d
POS_NAVES_INIMIGAS_Y1   DB      02d
AUX_MOV                 DB      ?

; Flags
PAUSED                  DB      'J'

; Debug
DEBUG_STRING            DB      'WTF$'


;SYSTEM :D
LEFTMOST                DB      0d
TOPMOST                 DB      0d
LINHA_VAZIA				DB		"                                                                              $"



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
        CALL MOVE_TIROS
        
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

LIMPA_TUDO PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH BX
    
	MOV CX,25d
    MOV TOPMOST, 0d
	LIMPA_P:
		MOV AH,2
    	MOV DL,LEFTMOST
    	MOV DH,TOPMOST
    	MOV BH,0
    	INT 10h
			
    	MOV AH,9
    	LEA DX,LINHA_VAZIA
    	INT 21h
    	
		INC TOPMOST
		LOOP LIMPA_P
		
	POP BX
	POP DX
	POP CX
	POP AX
	RET
LIMPA_TUDO ENDP

DESENHA PROC
    ;CALL DEBUG_MSG
    CALL LIMPA_TUDO
	CALL DESENHA_TIROS
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
		
		CMP AL, ' '
		JE L_ATIROU         ; o jogador atirou
		
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
	    
		L_ATIROU:
		    CALL ATIRAR
			    
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

MOVE_NAVES_INIMIGAS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV CL, 04h
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    MOV DL, [POS_NAVES_INIMIGAS_X] ;inimigo mais a esquerda
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 0D
    JE NAVE_INIMIGA_DIR
    
    MOV DL, [POS_NAVES_INIMIGAS_X+3] ;inimigo mais a direita
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 73D
    JE NAVE_INIMIGA_ESQ

    JMP MOVE_ALL    	

	NAVE_INIMIGA_DIR:
    	MOV DL, 'D'
    	MOV DIR_NAVE_INIMIGA, DL        ;desce
    	INC POS_NAVES_INIMIGAS_Y
    	INC POS_NAVES_INIMIGAS_Y1
    	JMP MOVE_ALL
	
    NAVE_INIMIGA_ESQ:
    	MOV DL, 'E'
    	MOV DIR_NAVE_INIMIGA, DL        ;desce
    	INC POS_NAVES_INIMIGAS_Y
    	INC POS_NAVES_INIMIGAS_Y1
    	MOV DIR_NAVE_INIMIGA, DL
    
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
	
	CMP DIR_NAVE_INIMIGA, 'D'
	JE MOV_NAVE_INIMIGA_DIR

	CMP DIR_NAVE_INIMIGA, 'E'
	JE MOV_NAVE_INIMIGA_ESQ
	
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

DESENHA_NAVE_INIMIGA PROC
	PUSH CX
	PUSH DX
	PUSH BX

    MOV CL, 04h
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    DRAW_ENEMY:    
        MOV DL, [BX]
        MOV AUX_MOV, DL
    	GOTOXY AUX_MOV POS_NAVES_INIMIGAS_Y
	    WRITE_STRING NAVE_JOGADOR_MEIO
	
	    GOTOXY AUX_MOV POS_NAVES_INIMIGAS_Y1
	    WRITE_STRING NAVE_JOGADOR_FREN
	    
        INC BX
        LOOP DRAW_ENEMY

    CALL ESCONDE_CURSOR

    POP BX
	POP DX
	POP CX
	
	RET
DESENHA_NAVE_INIMIGA ENDP

DESENHA_TIROS PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CL, MAX_TIROS
    MOV BX, OFFSET TIROS
    
    L_DESENHA_TIROS:

        MOV DL, [BX]        ; item do array para var auxiliar
        MOV AUX_MOV, DL
    
        CMP AUX_MOV, 00d           ; verifica se o tiro deve ser desenhado ou não
        JE L_NAO_DESENHA_TIRO
        
        CALL FIND_TIRO_X ; pega a posicao x do tiro
        CALL FIND_TIRO_Y ; pega o y do tiro
        
        GOTOXY TMP_TIRO_X TMP_TIRO_Y
        WRITE_STRING TIRO
        
        L_NAO_DESENHA_TIRO:
            INC BX
            LOOP L_DESENHA_TIROS
       
    POP DX
    POP CX
    POP BX     
    RET
DESENHA_TIROS ENDP

; PEGA A POSICAO Y DO TIRO ATUAL
FIND_TIRO_Y PROC
    PUSH BX
    PUSH DX
    
    
    MOV BX, OFFSET TIROS_Y
    MOV DL, MAX_TIROS
    SUB DL, CL
    L_FIND_TIRO_POS_Y:    ; laco percorre o array de posicoes ate o tiro atual pra pegar o valor
        CMP DL, 00h
        JE L_FOUND_TIRO_POS_Y
        INC BX
        DEC DL
        JMP L_FIND_TIRO_POS_Y

    L_FOUND_TIRO_POS_Y: 
    MOV DL, [BX]       
    MOV TMP_TIRO_Y, DL
    
    POP DX
    POP BX
    RET
FIND_TIRO_Y ENDP

; PEGA A POSICAO X DO TIRO ATUAL
FIND_TIRO_X PROC
    PUSH BX
    PUSH DX
    
    MOV BX, OFFSET TIROS_X
    MOV DL, MAX_TIROS
    SUB DL, CL
    L_FIND_TIRO_POS_X:
        CMP DL, 00h
        JE L_FOUND_TIRO_POS_X
        INC BX
        DEC DL
        JMP L_FIND_TIRO_POS_X

    L_FOUND_TIRO_POS_X: 
    MOV DL, [BX]       
    MOV TMP_TIRO_X, DL
    
    POP DX
    POP BX
    RET
FIND_TIRO_X ENDP

ATIRAR PROC
    PUSH CX
    PUSH BX
    PUSH DX
    

    MOV DL, MAX_TIROS
    CMP DL, NUM_TIROS
    JE L_NAO_ATIRA
    
    MOV CL, NUM_TIROS
    MOV BX, OFFSET TIROS_X    ; posiciona o tiro no eixo x
    ADD BX, CX
    MOV DL, POS_NAVE_X
    ADD DL, 02d    ; normalizando posição tiro
    MOV [BX], DL
    
    MOV BX, OFFSET TIROS_Y   ; posiciona o tiro no eixo x
    ADD BX, CX
    MOV DL, 21d
    MOV [BX],DL    
    
    MOV BX, OFFSET TIROS
    ADD BX, CX
    MOV DL, 01h
    MOV [BX], DL
    INC NUM_TIROS
        
    L_NAO_ATIRA:
        POP DX
        POP BX
        POP CX
        RET
ATIRAR ENDP

MOVE_TIROS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CL, MAX_TIROS
    MOV BX, OFFSET TIROS
    MOV AX, 0000h
    
    L_MOVE_TIROS:
        MOV DL, [BX]        ; item do array para var auxiliar
        MOV AUX_MOV, DL
    
        CMP AUX_MOV, 00d           ; verifica se o tiro deve ser desenhado ou não
        JE L_NAO_MOVE_TIRO
        
        CALL FIND_TIRO_Y ; pega o y do tiro
        DEC TMP_TIRO_Y
        PUSH BX
        MOV BX, OFFSET TIROS_Y
        ADD BX, AX
        MOV DL, TMP_TIRO_Y
        MOV [BX], DL        
        POP BX
        
        ; se o tiro chegou na borda da tela
        CMP TMP_TIRO_Y, 00h
        JNE L_NAO_MOVE_TIRO
        
        MOV AUX_MOV, 00h
        MOV DL, AUX_MOV
        MOV [BX], DL
        DEC NUM_TIROS
        
        L_NAO_MOVE_TIRO:
            INC AX
            INC BX
            LOOP L_MOVE_TIROS
      
    POP DX  
    POP CX   
    POP BX
    POP AX
    RET
MOVE_TIROS ENDP

DEBUG_MSG PROC
    PUSH CX
    PUSH DX
    PUSH BX
    
    GOTOXY 30 10
    WRITE_STRING DEBUG_STRING
    
    CALL ESCONDE_CURSOR
    
    POP BX
    POP DX
    POP CX
    
    RET
DEBUG_MSG ENDP

END MAIN
