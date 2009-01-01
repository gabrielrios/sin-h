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
NAVE_JOGADOR_FREN		DB		' ',' ',220,"$"	
NAVE_JOGADOR_TRAS		DB		219,219,219,219,219, "$" 

POS_NAVE_X				DB		42		;Posição Inicial do carro na tela

NUMERO_VIDAS            DB      03d

;TIROS
TIRO                    DB      0BAh, "$"
MAX_TIROS               DB      1d
NUM_TIROS               DB      0d
TIROS                   DB      00d, 00d, 00d, 00d, 00d	
TIROS_X                 DB      00d, 10d, 20d, 30d, 40d
TIROS_Y                 DB      20d, 20d, 20d, 20d, 20d
TMP_TIRO_X              DB      ?
TMP_TIRO_y              DB      ?

Z                       DB      20d

;INIMIGO
OCTOPUS_UPPER           DB      220,219,219,220, "$"
OCTOPUS_LOWER           DB      95,47,92,95, "$"
CRAB_UPPER              DB      192,219,219,217, "$"
CRAB_LOWER              DB      " ",39,96, "$"
SQUID_UPPER             DB      ' ',220,219,220, "$"
SQUID_LOWER             DB      ' ',201,202,187, "$"
DIR_NAVE_INIMIGA		DB		'D'
TIPO_NAVE_INIMIGA       DB      'S','S','S','S','S','S','S','S','S','S','S', 'C','C','C','C','C','C','C','C','C','C','C', 'C','C','C','C','C','C','C','C','C','C','C', 'O','O','O','O','O','O','O','O','O','O','O', 'O','O','O','O','O','O','O','O','O','O','O'
TMP_TIPO                DB      'O'
POS_NAVES_INIMIGAS_X    DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d, 00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d, 00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d, 00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d, 00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d
POS_NAVES_INIMIGAS_Y    DB      01d, 04d, 07d, 10d, 13d
POS_NAVES_INIMIGAS_Y1   DB      02d, 05d, 08d, 11d, 14d
NUM_INIMIGO             DB      55d
AUX_MOV                 DB      ?
LINHA                   DB      00h
MAX_LINHA               DB      05d

; Flags
PAUSED                  DB      'J'

; Debug
DEBUG_STRING            DB      'WTF$'


;SYSTEM :D
LEFTMOST                DB      0d
TOPMOST                 DB      0d
LINHA_VAZIA				DB		"                                                                              $"

;Tela inicial
TXT_JOGO                DB "         ____    ____    ______  ____     ____      ", CR, LF
                        DB "        /\  _`\ /\  _`\ /\  _  \/\  _`\  /\  _`\    ", CR, LF
                        DB "        \ \,\L\_\ \ \L\ \ \ \L\ \ \ \/\_\\ \ \L\_\  ", CR, LF
                        DB "         \/_\__ \\ \ ,__/\ \  __ \ \ \/_/_\ \  _\L  ", CR, LF
                        DB "           /\ \L\ \ \ \/  \ \ \/\ \ \ \L\ \\ \ \L\ \", CR, LF
                        DB "           \ `\____\ \_\   \ \_\ \_\ \____/ \ \____/", CR, LF
                        DB "            \/_____/\/_/    \/_/\/_/\/___/   \/___/ ", CR, LF
                        DB "     ______   __  __  __  __  ______  ____    ____    ____    ____       ", CR, LF
                        DB "    /\__  _\ /\ \/\ \/\ \/\ \/\  _  \/\  _`\ /\  _`\ /\  _`\ /\  _`\     ", CR, LF
                        DB "    \/_/\ \/ \ \ `\\ \ \ \ \ \ \ \L\ \ \ \/\ \ \ \L\_\ \ \L\ \ \,\L\_\   ", CR, LF
                        DB "       \ \ \  \ \ , ` \ \ \ \ \ \  __ \ \ \ \ \ \  _\L\ \ ,  /\/_\__ \   ", CR, LF
                        DB "        \_\ \__\ \ \`\ \ \ \_/ \ \ \/\ \ \ \_\ \ \ \L\ \ \ \\ \ /\ \L\ \ ", CR, LF
                        DB "        /\_____\\ \_\ \_\ `\___/\ \_\ \_\ \____/\ \____/\ \_\ \_\ `\____\", CR, LF
                        DB "        \/_____/ \/_/\/_/`\/__/  \/_/\/_/\/___/  \/___/  \/_/\/ /\/_____/", CR,LF,LF,"$"

TXT_CREDITOS            DB "       __ .__ .___.__ ._..___..__. __.", CR,LF
                        DB "      /  `[__)[__ |  \ |   |  |  |(__ ", CR,LF
                        DB "      \__.|  \[___|__/_|_  |  |__|.__)", CR,LF
                        DB LF,LF,"  Space Invaders eh um projeto da disciplina Software Basico", CR,LF
                        DB "  ministrada pelo professor Pericles Sobreira.", CR,LF,LF
                        DB "  Universidade Estadual de Santa Cruz (UESC)", CR,LF,LF
                        DB "Creditos:", CR,LF
                        DB "          Alexandre Gonzaga", CR,LF
                        DB "          Gabriel Rios", CR,LF
                        DB "          Helder Conceicao", CR,LF
                        DB "          Marlesson Santana", CR,LF
                        DB "          Pablo Rangel", CR, LF, LF, LF, "$"

TXT_HELP                DB "      .__.   ..  ..__ .__.",CR,LF
                        DB "      [__]   ||  ||  \[__]",CR,LF
                        DB "      |  |\__||__||__/|  |",CR,LF
                        DB LF,LF, "    Voce deve defender o planeta destruindo todas as naves inimigas.",CR,LF
                        DB " Entre sua nave e as naves invasoras existem quatro barreiras que sao",CR,LF
                        DB " destruidas a medida que sao atingidas por tiros ou por naves invasoras",CR,LF
                        DB "    Voce comeca o jogo com tres vidas e ganha mais vidas a cada 1500 pts.", CR,LF
                        DB " O jogo termina quando o numero de vidas for igual a zero ou quando os invasores", CR,LF
                        DB " alcancarem a linha da nave defensora.", CR,LF
                        DB " Existem quatro tipo de invasores:",CR,LF
                        DB "       Octopus: 10 pontos;",CR,LF
                        DB "          Crab: 20 pontos",CR,LF
                        DB "         Squid: 30 pontos",CR,LF
                        DB " Nave Espacial: 50 a 300 pontos",CR,LF
                        DB LF, "           TECLAS DE MOVIMENTO",CR,LF,LF
                        DB "ESQUERDA: seta esquerda",CR,LF
                        DB "DIREITA:  seta direita",CR,LF
                        DB "TIRO:     espaco",CR,LF
                        DB "PAUSE:    enter", CR, LF,"$"

TXT_RECORDS             DB "      .__ .___ __ .__..__ .__  __.", CR, LF
                        DB "      [__)[__ /  `|  |[__)|  \(__ ", CR, LF
                        DB "      |  \[___\__.|__||  \|__/.__)", CR, LF
                        DB LF,LF, "             EM BREVE!", CR, LF, "$"

STR_INICIAR             DB CR, LF,LF, "        [1] INICIAR JOGO$"
STR_RECORDS             DB CR, LF, "        [2] RECORDS$"
STR_CREDITO             DB CR, LF, "        [3] CREDITOS$"
STR_HELP                DB CR, LF, "        [4] AJUDA$"
STR_SAIR                DB CR, LF, "        [5] SAIR$"

.CODE

MAIN PROC 
	MOV	AX,	@DATA
	MOV	DS,	AX

    ;looping da tela inicial
    CALL TELA_INICIAL	
    
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
	PUSH DX
	
	
	MOV AH, 2ch
	INT 21h
	
	ADD DL, 20d
	MOV BX, DX
	
	CMP DL, 100d
	JGE PASS_MIN

	_DELAY:
		MOV AH, 2ch
		INT 21h
		CMP BH, DH
		JA _DELAY
		CMP BL, DL
		JA _DELAY

	POP DX
	POP CX
	POP AX

	RET
	
	PASS_MIN:
		INC BH
		SUB BL, 100d
		JMP _DELAY
	
DELAY ENDP

MOVE_NAVES_INIMIGAS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV CL, NUM_INIMIGO
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    MOV DL, [POS_NAVES_INIMIGAS_X] ;inimigo mais a esquerda
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 0D
    JE NAVE_INIMIGA_DIR
    
    MOV DL, [POS_NAVES_INIMIGAS_X+10] ;inimigo mais a direita
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 73D
    JE NAVE_INIMIGA_ESQ

    JMP MOVE_ALL    	

	NAVE_INIMIGA_DIR:
    	MOV DL, 'D'
    	MOV DIR_NAVE_INIMIGA, DL        ;desce
    	JMP DESCE
	
    NAVE_INIMIGA_ESQ:
    	MOV DL, 'E'
    	MOV DIR_NAVE_INIMIGA, DL        ;desce
    	
    DESCE:
        CMP [POS_NAVES_INIMIGAS_Y1+4], 20d
        JE MOVE_ALL
        CALL DESCE_INIMIGOS
    	
    MOVE_ALL:
        CALL MOVE_NAVE_INIMIGA
            
        INC BX
        LOOP MOVE_ALL
        
    
    POP CX
    POP BX
    POP AX
    
    RET
MOVE_NAVES_INIMIGAS ENDP

DESCE_INIMIGOS PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    MOV CL, MAX_LINHA
    
    DESCE_Y:
        MOV DL, [BX]
        INC DL
        MOV [BX], DL
        INC BX
        LOOP DESCE_Y
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y1
    MOV CL, MAX_LINHA
    
    DESCE_Y1:
        MOV DL, [BX]
        INC DL
        MOV [BX], DL
        INC BX
        LOOP DESCE_Y1
       
    POP DX 
    POP CX
    POP BX
    RET
DESCE_INIMIGOS ENDP

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
	PUSH AX

    MOV CL, 11h ;NUM_INIMIGO
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    MOV AL, 00h
    MOV LINHA, 00h
    
    OUTTER_LOOP:
        MOV CL, 11d ;NUM_INIMIGO
        DRAW_ENEMY:    
            MOV DL, [BX]
            MOV AUX_MOV, DL
    
            PUSH BX
            MOV BX, OFFSET TIPO_NAVE_INIMIGA
            ADD BX, AX
            MOV DL, [BX]
            CMP DL, 'O'          ;DESENHA OCTOPUS
            JNE CRAB
            CALL DESENHA_OCTOPUS
    	    JMP DESENHADO
            
            CRAB:
            CMP DL, 'C'          ;DESENHA CRAB
            JNE SQUID
            CALL DESENHA_CRAB
            JMP DESENHADO
            
            SQUID:
            CALL DESENHA_SQUID  ;DESENHA SQUID
            
            DESENHADO:
            POP BX
            INC BX
            INC AX
    
            LOOP DRAW_ENEMY
        
        INC LINHA
        PUSH AX
        MOV AL, MAX_LINHA
        CMP LINHA, AL
        POP AX
        JNE OUTTER_LOOP

    CALL ESCONDE_CURSOR

    POP AX
    POP BX
	POP DX
	POP CX
	
	RET
DESENHA_NAVE_INIMIGA ENDP

DESENHA_OCTOPUS PROC
    PUSH DX
    PUSH BX
    
    MOV DX, 0000h
    MOV DL, LINHA
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING OCTOPUS_UPPER
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y1
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING OCTOPUS_LOWER
    
    POP BX
    POP DX
    RET
DESENHA_OCTOPUS ENDP

DESENHA_CRAB PROC
    PUSH DX
    PUSH BX
    
    MOV DX, 0000h
    MOV DL, LINHA
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING CRAB_UPPER
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y1
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING CRAB_LOWER
    
    POP BX
    POP DX
    
    RET
DESENHA_CRAB ENDP

DESENHA_SQUID PROC
    PUSH DX
    PUSH BX
    
    MOV DX, 0000h
    MOV DL, LINHA
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING SQUID_UPPER
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y1
    ADD BX, DX
    
    GOTOXY AUX_MOV [BX]
    WRITE_STRING SQUID_LOWER
    
    POP BX
    POP DX
    
    RET
DESENHA_SQUID ENDP

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


TELA_INICIAL PROC
    PUSH DX
    PUSH AX
    
    MAIN_TELA:
        LIMPA_TELA
        MOV AH,09H
        LEA DX, TXT_JOGO    ;banner do jogo
        INT 21H
        
        ;menu
        LEA DX, STR_INICIAR
        INT 21H
        LEA DX, STR_RECORDS
        INT 21H
        LEA DX, STR_CREDITO
        INT 21H
        LEA DX, STR_HELP
        INT 21H
        LEA DX, STR_SAIR
        INT 21H
        
        CALL ESCONDE_CURSOR
        
        MOV AH, 07H
        INT 21H
        
        CMP AL, '1'
        JE FIM_TELA        
        CMP AL, '2'
        JE RECORDS    
        CMP AL, '3'
        JE  CREDITOS    
        CMP AL, '4'
        JE AJUDA        
        CMP AL, '5'
        JE SAIR        
    JMP MAIN_TELA
    
    RECORDS:
        LIMPA_TELA
        MOV AH, 09H
        LEA DX, TXT_RECORDS
        INT 21H
        CALL ESCONDE_CURSOR
        MOV AH, 07H
        INT 21H
        JMP MAIN_TELA
        
    AJUDA:
        LIMPA_TELA
        MOV AH, 09H
        LEA DX, TXT_HELP
        INT 21H
        CALL ESCONDE_CURSOR
        MOV AH, 07H
        INT 21H
        JMP MAIN_TELA
    
    CREDITOS:
        LIMPA_TELA
        MOV AH, 09H
        LEA DX, TXT_CREDITOS
        INT 21H
        CALL ESCONDE_CURSOR
        MOV AH, 07H
        INT 21H
        JMP MAIN_TELA
        
    SAIR:
        MOV AH, 4Ch
        INT 21h
    
    FIM_TELA:
        POP AX
        POP DX
    RET
TELA_INICIAL ENDP

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
