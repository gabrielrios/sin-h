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
;records
CR 						EQU		0Dh
LF						EQU		0Ah
ARQUIVO 				DB	"records.txt", 00h
BUFFER			    	DB  60 dup ('0')
BUFFER_AUX				DB  30 dup ('0')
HANDLE					DW	?
STR_GET_NAME			DB CR, CR, CR, CR, CR, LF, "DIGITE AS 3 PRIMEIRAS INICIALS DO SEU NOME: $"

; JOGADOR
NAVE_JOGADOR_FREN		DB		' ',' ',220,"$"	
NAVE_JOGADOR_TRAS		DB		219,219,219,219,219, "$" 

POS_NAVE_X				DB		10d		;Posição Inicial do carro na tela
NUMERO_VIDAS			DB		31h
D_SCORE					DB		00h
C_SCORE					DB		00h
M_SCORE					DB		00h
DM_SCORE				DB		00h
PONTOS_VIDA             DW      00h	

;TIROS
TIRO                    DB      0BAh, "$"
TIROS                   DB      00d
TIRO_X  	            DB      00d
TIRO_Y	                DB      20d

;INIMIGO
OCTOPUS					DB		47,219,219,92,"$"
CRAB_UPPER              DB      192,219,219,217, "$"
SQUID_LOWER             DB      ' ',201,202,187, "$"
DIR_NAVE_INIMIGA		DB		'D'
SPACESHIP				DB		220,219,219,219,220, "$" 
SPACESHIP_X				DB		60d
SPACESHIP_Y				DB		01d
SPACESHIP_DIR			DB		'D'
SPACESHIP_VISIBLE		DB		00d

; 'matriz' do tipo dos inimigos
TIPO_NAVE_INIMIGA       DB      'S','S','S','S','S','S','S','S','S','S','S'
						DB		'C','C','C','C','C','C','C','C','C','C','C'
						DB		'C','C','C','C','C','C','C','C','C','C','C'
						DB		'O','O','O','O','O','O','O','O','O','O','O'
						DB		'O','O','O','O','O','O','O','O','O','O','O'

; 'matriz' da posição x dos inimibos
POS_NAVES_INIMIGAS_X    DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d
						DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d
						DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d
						DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d
						DB      00d, 05d, 10d, 15d, 20d, 25d, 30d, 35d, 40d, 45d, 50d


POS_NAVES_INIMIGAS_Y    DB      02d, 04d, 06d, 8d, 10d
MAX_INIMIGO				DB		55d
NUM_INIMIGO             DB      55d
INIMIGO_LINHA			DB		11d
AUX_MOV                 DB      ?
LINHA                   DB      00h
MAX_LINHA               DB      05d
LEFTMOST_ENEMY_X        DB      ?
RIGHTMOST_ENEMY_X       DB      ?
BOTTOMOST_ENEMY_Y       DB      ?    
TIRO_INIMIGO_X          DB      0,?,?,?,?
TIRO_INIMIGO_Y          DB      ?,?,?,?,?
MAX_TIROS               DB      5d
NUM_TIROS               DB      00h
PTR_TIROS               DB      00h
TIRO_INIMIGO_ASCII      DB      25d, "$"
DELAY_INIMIGO           DB      15d

; Flags
PAUSED                  DB      'J'

; Debug
DEBUG_STRING            DB      'WTF$'


;SYSTEM :D
LEFTMOST                DB      0d
TOPMOST                 DB      0d
LINHA_VAZIA				DB		"                                                                               $"
LAST_MIN				DB		?
LAST_SEC				DB		?
LAST_MS					DB		?
LAST_HOUR				DB		?
LEVEL					DB		00
SEED					DW		?

LAST_TICKS              DW      ?
LAST_TICKS_HOUR         DB      ?

; hud
STR_SCORE				DB	"PONT: $"
STR_LIVES				DB  "VIDAS: $"

BARRIERS                DB " "," "," "," "," "," "," "," "," "," "," ",219,219,219,219,219,219,219," "," "," "," "," "," "," "," "," "," ",219,219,219,219,219,219,219," "," "," "," "," "," "," "," "," "," ",219,219,219,219,219,219,219," "," "," "," "," "," "," "," "," "," ",219,219,219,219,219,219,219,"$"


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
                        DB LF,LF, "             ", CR, LF, "$"

STR_INICIAR             DB CR, LF,LF, "        [1] INICIAR JOGO$"
STR_RECORDS             DB CR, LF, "        [2] RECORDS$"
STR_CREDITO             DB CR, LF, "        [3] CREDITOS$"
STR_HELP                DB CR, LF, "        [4] AJUDA$"
STR_SAIR                DB CR, LF, "        [5] SAIR$"


TXT_GAME_OVER           DB " ____    ______           ____        _____   __  __  ____    ____       ", CR,LF
                        DB "     /\  _`\ /\  _  \  /'\_/`\/\  _`\     /\  __`\/\ \/\ \/\  _`\ /\  _`\     ", CR,LF
                        DB "     \ \ \L\_\ \ \L\ \/\      \ \ \L\_\   \ \ \/\ \ \ \ \ \ \ \L\_\ \ \L\ \   ", CR,LF
                        DB "      \ \ \L_L\ \  __ \ \ \__\ \ \  _\L    \ \ \ \ \ \ \ \ \ \  _\L\ \ ,  /   ", CR,LF
                        DB "       \ \ \/, \ \ \/\ \ \ \_/\ \ \ \L\ \   \ \ \_\ \ \ \_/ \ \ \L\ \ \ \\ \  ", CR,LF
                        DB "        \ \____/\ \_\ \_\ \_\\ \_\ \____/    \ \_____\ `\___/\ \____/\ \_\ \_\", CR,LF
                        DB "         \/___/  \/_/\/_/\/_/ \/_/\/___/      \/_____/`\/__/  \/___/  \/_/\/ /", CR, LF, LF, "$"
.CODE

MAIN PROC 
	MOV	AX,	@DATA
	MOV	DS,	AX
		
	MOV AH, 2ch	
	INT 21h
	MOV SEED, DX	

    ;looping da tela inicial    
    CALL TELA_INICIAL	
    
    INICIO_JOGO:
	
    CALL GET_TICKS
	MOV LAST_TICKS, AX
	MOV LAST_TICKS_HOUR, CH
	
	CALL DESENHA_FUNDO_PADRAO
	GAME_LOOP:
	    ; condições de parada
	    CMP NUMERO_VIDAS, 30h
	    JE FIM_JOGO
	    
        CALL ACHA_INIMIGO_EMBAIXO
        CMP BOTTOMOST_ENEMY_Y, 21d
	    JE FIM_JOGO
	    
	    CMP NUM_INIMIGO, 00d
	    JE FIM_JOGO_VITORIA
	    
	    ; entrada de dados
	    CALL KBHIT
        CMP PAUSED, 'P' ;VERIFICA SE ESTÁ PAUSADO, SE ESTIVER FAZ NADA
        JE PAUSA
        
        ;lógica	
        CALL RANDOM_TIRO
        CALL VERIFICA_MOVE_NAVES_INIMIGAS
        CALL MOVE_TIROS
    	
    	
    	CMP SPACESHIP_VISIBLE, 01d
        JE SPACESHIP_JA_VISIVEL
		CALL RANDOM_SPACESHIP
		SPACESHIP_JA_VISIVEL:
    	
    	CMP SPACESHIP_VISIBLE, 00d
      	JE NAO_MOVE_SPACESHIP
    	CALL MOVE_SPACESHIP
    	NAO_MOVE_SPACESHIP:
        
    	CALL VERIFICA_TIRO_ATINGIU_INIMIGO
    	call VERIFICA_TIRO_ATINGIU_PLAYER
    	
        PAUSA:
        ; Desenho
        CALL DESENHA
        
		;DELAY :D
		PUSH BX
		MOV BX, 05d
		CALL DELAY
		POP BX
		
	JMP GAME_LOOP
	
	FIM_JOGO:
		call check_record
	    CALL LIMPA_TUDO
    	MOV AH,2
	    MOV DL,5d
	    MOV DH,5d
	    MOV BH,0
	    INT 10h

	    mov ah, 09
	    lea dx, TXT_GAME_OVER
        int 21h
        mov bx, 50
        call delay
		CALL TELA_INICIAL
		JMP INICIO_JOGO
		
	FIM_JOGO_VITORIA:
		push dx
		mov dl, level
		add dl, 08d
		cmp dl, 16d
		jge	DESCEU_MAXIMO
		INC LEVEL
		DESCEU_MAXIMO:
		CALL INICIA_JOGO
		pop dx
		JMP INICIO_JOGO
	

MAIN ENDP

show_score proc
	push ax
	push bx
	push cx
	push dx
	
	call load_score
	
	xor cx, cx
	mov cl, 5d
	mov bx, offset buffer
	mov ah, 02h
	imprime:
		push cx
		mov cl, 03d
		mov ah, 02h
		imprime_nome:
			mov dl, [bx]
			int 21h
			inc bx
		loop imprime_nome
		mov dl, ' '
		int 21h
		mov cl, 03d
		imprime_score:
			mov dl, [bx]
			int 21h
			inc bx
		loop imprime_score
		mov dl, '0'
		int 21h
		pop cx
		mov dl, cr
		int 21h
		mov dl, lf
		int 21h
	loop imprime
	
	mov ah, 01h
	int 21h
	
	FIM_SHOW_SCORE:
	pop dx
	pop cx
	pop bx
	pop ax
	RET
show_score endp

check_record proc
	add m_score, 30h
	add d_score, 30h
	add c_score, 30h
	call load_score
	call write_record
	sub m_score, 30h
	sub d_score, 30h
	sub c_score, 30h
	
	CALL LIMPA_TUDO
	PUSH AX
			PUSH BX
			PUSH DX

			MOV AH,2d
			MOV DL,0d
			MOV DH,3d
			MOV BH,0d
			INT 10h
	
			POP DX
			POP BX
			POP AX
	call show_score
	
check_record endp

write_record proc
	PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
	
	XOR CX, CX
	
	CALL SET_PROFILE
	CALL IS_BIGGER
	CMP DL, 1h
	JE INSERE

	mov cl, 1d
	CALL SET_PROFILE
	CALL IS_BIGGER
	CMP DL, 1h
	JE INSERE
	
	mov cl,  2d
	CALL SET_PROFILE
	CALL IS_BIGGER
	CMP DL, 1h
	JE INSERE
	
	mov cl,  3d
	CALL SET_PROFILE
	CALL IS_BIGGER
	CMP DL, 1h
	JE INSERE
	
	mov cl,  4d
	CALL SET_PROFILE
	CALL IS_BIGGER
	CMP DL, 1h
	JE INSERE
	
	jmp fim_write_record
	
	INSERE:
		PUSH CX
		
			PUSH AX
			PUSH BX
			PUSH DX

			MOV AH,2d
			MOV DL,0d
			MOV DH,0d
			MOV BH,0d
			INT 10h
	
			POP DX
			POP BX
			POP AX
		MOV AH, 09H
		LEA DX, STR_GET_NAME
		INT 21H
		CALL SET_PROFILE
		MOV AH, 01H
		mov cx, 03d
		ENTRADA_INSERE:
			INT 21H
			MOV [BX], AL
			INC BX
		LOOP ENTRADA_INSERE
		mov AL, M_SCORE
		MOV [BX], AL
		INC BX
		mov AL, C_SCORE
		MOV [BX], AL
		INC BX
		MOV AL, D_SCORE
		MOV [BX], AL
		POP CX
		INC CX
		CALL SET_PROFILE
		xor ax, ax
		mov al, cl
		xor si, si
		MOV SI, 6d
		mul si
		mov si, ax
		MOV CX, 30D
		sub si, 6d
		COPIA_RESTO:
			PUSH BX
			MOV BX, OFFSET BUFFER_AUX
			MOV AL, [BX+SI]
			POP BX
			MOV [BX], AL
			INC BX
			INC SI
		LOOP COPIA_RESTO
		
		call del_file
		call make_file
		call open_file
		call write_file
		call close_file
	fim_write_record:	
		pop dx
		pop cx
		pop bx
		pop ax
		ret
write_record endp

del_file proc
	push ax
	push bx
	push cx
	push dx
	
	mov AH,41h 
	mov dx, offset arquivo
	
	int 21h
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
del_file endp

SET_PROFILE PROC
	push cx
	MOV BX, OFFSET BUFFER
	CMP CX, 0D
	JE FIM_SET_PROFILE
	
	INDEXA_PROFILE:
		ADD BX, 6D
	LOOP INDEXA_PROFILE
	
	FIM_SET_PROFILE:
	pop cx
	RET
SET_PROFILE ENDP

LOAD_SCORE PROC
	PUSH DX
    
	CALL OPEN_FILE
	MOV   DX, OFFSET BUFFER      ; de onde os dados estão vindo
	CALL READ_FILE
	CALL CLOSE_FILE
	
	
	CALL OPEN_FILE
	MOV   DX, OFFSET BUFFER_AUX      ; de onde os dados estão vindo
	CALL READ_FILE
	CALL CLOSE_FILE
	
    POP DX
	ret
LOAD_SCORE ENDP

IS_BIGGER PROC
	push ax

	add bx, 3d
	mov dl, [bx]
	
	cmp m_score, dl
	je centena_is_bigger
	jg maior_is_bigger
	jl menor_is_bigger
	
	centena_is_bigger:
		inc bx
		mov dl, [bx]
		cmp c_score, dl
		je dezena_is_bigger
		jg maior_is_bigger
		jl menor_is_bigger
	
	dezena_is_bigger:
		inc bx
		mov dl, [bx]
		cmp d_score, dl
		jge maior_is_bigger
		jl menor_is_bigger

	menor_is_bigger:
		MOV DL, 0D
		JMP FIM_is_bigger
	
	maior_is_bigger:
		MOV DL, 1D
		jmp fim_is_bigger

	fim_is_bigger:
		pop ax
		ret
IS_BIGGER ENDP


OPEN_FILE PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	INICIO_OPEN_FILE:
	mov dx, OFFSET ARQUIVO	;address of filename 
	mov cx,3Fh 		;file mask 3Fh - any file
	mov ah,4Eh 		;function 4Eh - find first file 
	int 21h 		;call DOS service 
	jc NO_FILE
	
	LEA   DX,ARQUIVO	; Põe o offset do arquivo a abrir em DX
	MOV   AH,3Dh            ; Abre
	MOV   AL,02h            ; para leitura/escrita
	INT   21h
	MOV   HANDLE,AX
	JMP END_OPEN_FILE
		
	NO_FILE: 
		CALL MAKE_FILE
		CALL WRITE_FILE
		CALL CLOSE_FILE
		JMP INICIO_OPEN_FILE

	END_OPEN_FILE:
		POP DX
		POP CX
		POP BX
		POP AX
		RET
OPEN_FILE ENDP

;DESTINO DOS DADOS FICA ARMAZENADO EM DX, 	MOV   DX, OFFSET BUFFER      ; de onde os dados estão vindo
READ_FILE PROC
	push ax
	push bx
	push cx
	MOV   BX, HANDLE             ; arquivo para se escrever nele
	MOV   CX, 30d                 ; quanto a ler
	MOV   AH, 3Fh                ; LER byte(s)
	INT   21h
	pop cx
	pop bx
	pop ax
	RET
READ_FILE ENDP

CLOSE_FILE PROC
	push ax
	push bx
	push cx
	push dx
	;fecha o arquivo
	MOV AH,3Eh
	MOV BX,HANDLE
	pop dx
	pop cx
	pop bx
	pop ax
	RET
	
CLOSE_FILE ENDP

WRITE_FILE PROC
	push ax
	push bx
	push cx
	push dx
	MOV   DX, offset BUFFER    ; de onde os dados estão vindo
	MOV   BX, HANDLE           ; arquivo para se escrever nele
	MOV   CX, 30d               ; quanto a ler
	MOV   AH, 40H              ; LER byte(s)
    INT   21H
	pop dx
	pop cx
	pop bx
	pop ax
	RET
	
WRITE_FILE ENDP

MAKE_FILE PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV	AH, 3Ch              ;Função 3Ch (int 21h)
	MOV CX, 20h              ;Atributo (arquvio = 1)
	MOV DX, OFFSET ARQUIVO
	INT 21h 
	MOV HANDLE, AX
	pOP DX
	POP CX
	POP BX
	POP AX
	RET
MAKE_FILE ENDP

LIMPA_TUDO PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH BX
    	
    mov ah, 6 ; Use function 6 - clear screen
    mov al, 0 ; clear whole screen
    mov bh, 0fh ; use black spaces for clearing
    mov cx, 0 ; set upper corner value
    mov dl, 79 ; coord of right of screen
    mov dh, 24 ; coord of bottom of screen
    int 10h ; go!

    mov bh, 0ah
    mov cx, 0000h
    mov dx, 004Fh
    int 10h
    mov cx, 1500h
    mov dx, 184fh
    int 10h
	mov bh, 0ch
	mov cx, 0100h
	mov dx, 014fh
	int 10H
		
	POP BX
	POP DX
	POP CX
	POP AX
	RET
LIMPA_TUDO ENDP

DESENHA PROC
    CALL LIMPA_TUDO
    CALL DESENHA_HUD
    CALL DESENHA_TIROS
    CALL DESENHA_NAVE
	CALL DESENHA_NAVE_INIMIGA
	CMP SPACESHIP_VISIBLE, 00d
	JE NAO_DESENHA_SPACESHIP
	CALL DESENHA_SPACESHIP
	NAO_DESENHA_SPACESHIP:
	RET
DESENHA ENDP

DESENHA_HUD PROC
	push ax
	push bx
	push cx
	push dx

	MOV AH,2
	MOV DL,0
	MOV DH,0
	MOV BH,0
	INT 10h

	mov ah, 09
	lea dx, STR_SCORE
	int 21h
		
	mov ah, 02
	mov dl, m_score
	add dl, 30h
	int 21h
	mov dl, c_score
	add dl, 30h
	int 21h
	mov dl, d_score
	add dl, 30h
	int 21h
	mov dl, 30h
	int 21h
	
	MOV AH,2
	MOV DL,60
	MOV DH,0
	MOV BH,0
	INT 10h

	mov ah, 09
	lea dx, STR_LIVES
	int 21h
	
	mov ah, 02
	mov dl, numero_vidas
	int 21h
	
	MOV AH,2
	MOV DL,0
	MOV DH,20
	MOV BH,0
	INT 10h
	
	mov ah, 09
	lea dx, barriers
	int 21h
	
	pop dx
	pop cx
	pop dx
	pop ax
	RET
	
DESENHA_HUD ENDP

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
		JE TMP_FIM_JOGO
		
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
		    MOV POS_NAVE_X, 10d
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
	    
		TMP_FIM_JOGO:
			JMP FIM_JOGO
		
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
	DESENHA_RETANGULO 00Ah 0000h 004Fh
	DESENHA_RETANGULO 00ch 0100h 014fh
	DESENHA_RETANGULO 00fh 0200h 154fh
	DESENHA_RETANGULO 00Ah 1600h 184Fh
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

; retorna horas em CH e restante do horario no ax como CS
GET_TICKS PROC
    PUSH BX
    PUSH DX
	; Pegando o horario do sistema. [ENTRE PARENTESES SÃO OS VALROES ANTIGOS]
	; CH = hour				
	; CL = minute			
	; DH = second			
	; DL = 1/100 seconds(ms)
	MOV AH, 2ch	
	INT 21h
	
	MOV AX, 0000
	MOV BX, CX
	mov CX, 0000
	MOV CL, BL
	LOOP__:                 ;converte minutos em segundos
	    ADD AX, 60d
	    LOOP LOOP__
    
    MOV CX, 0000
    MOV CL, DH              ;soma os segundos ao total
    ADD AX, CX

    mov ch, bh
    MOV CL, 10d
    MOV BX, AX
    MOV AX, 0000
    LOOP__2:                ;converte os segundo em cs
        ADD AX, BX
        dec cl
        jnz loop__2
        ;LOOP LOOP__2
	
    mov dh, 00h
	ADD AX, DX             ; adicionando os ms
	
	
	POP DX
	POP BX
    RET
GET_TICKS ENDP

DELAY PROC
	PUSH AX
	;PUSH BX
	PUSH CX
	PUSH DX
	
	; Pegando o horario do sistema. [ENTRE PARENTESES SÃO OS VALROES ANTIGOS]
	; CH = hour				(AH)
	; CL = minute			(AL)
	; DH = second			(BH)
	; DL = 1/100 seconds(ms)(BL)
	MOV AH, 2ch	
	INT 21h
	
	ADD DL, BL			;faça esperar 10ms
	MOV LAST_MS, DL
	MOV LAST_SEC, DH
	MOV LAST_MIN, CL
	MOV LAST_HOUR, CH
	
	CMP LAST_MS, 100d
	JGE PASS_SEC

	_DELAY:				; enquanto não passou o tempo necessario
		MOV AH, 2ch
		INT 21h
		CMP LAST_HOUR, CH
		JG _DELAY
		CMP LAST_MIN, CL
		JG _DELAY
		CMP LAST_SEC, DH
		JG _DELAY
		CMP LAST_MS, DL
		JG _DELAY

	POP DX
	POP AX
	POP CX
;	POP BX
	
	RET
	
	PASS_SEC:
		INC LAST_SEC
		SUB LAST_MS, 100d
		CMP LAST_SEC, 60d
		JGE PASS_MIN
		JMP _DELAY
	
	PASS_MIN:
		INC LAST_MIN
		SUB LAST_SEC, 60d
		CMP LAST_MIN, 60d
		JGE PASS_HOUR
		JMP _DELAY
		
	PASS_HOUR:
		INC LAST_HOUR
		SUB LAST_MIN, 60d
		JMP _DELAY
		
DELAY ENDP

RANDOM_TIRO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    mov dl, max_tiros
    CMP NUM_TIROS, dl
    JE NAO_ATIRA_1
    
    CALL RANDOM
    
    CMP AL, 30d
    JGE INTERVALO_1
    ;CMP AL, 90d
    ;JGE INTERVALO_2
        
    JMP NAO_ATIRA
    
    INTERVALO_1:
        CMP AL, 60d
        JLE iNIMIGO_ATIRA
        JMP NAO_ATIRA
    
    INTERVALO_2:
        CMP AL, 120d
        JLE INIMIGO_ATIRA
        JMP NAO_ATIRA

        
    NAO_ATIRA_1:
        JMP NAO_ATIRA
        
    INIMIGO_ATIRA:
    
    MOV DH, 00h
    MOV DL, AL
    CMP DL, 100d
    JGE NORMALIZA_RANDOM_1
    BACK_NORMALIZA_1:
    CMP DL, 55d
    JGE NORMALIZA_RANDOM_2
    BACK_NORMALIZA_2:
        
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    ADD BX, DX
    MOV AL, [BX]
    ADD AL, 10d
    CMP POS_NAVE_X, AL
    JLE TIRO_OK1
    JMP NAO_ATIRA
    VOLTA_TIRO:
    ADD AL, 10d
    
    MOV BX, OFFSET TIRO_INIMIGO_X
    MOV CL, PTR_TIROS
    ADD BX, CX
    MOV [BX], AL
    
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    MOV AX, 0000h
    CMP DL, 11d
    JLE TIRO_LINHA_0    
    TIRO_DIV:
        SUB DL, 11d
        INC AL
        CMP DL, 11d
        JGE TIRO_DIV
    TIRO_LINHA_0:
    ADD BX, AX
    MOV DL, [BX]
    
    MOV BX, OFFSET TIRO_INIMIGO_Y
    MOV CL, PTR_TIROS
    ADD BX, CX
    INC DL
    MOV [BX], DL

    INC NUM_TIROS
    INC PTR_TIROS
    CMP PTR_TIROS, 05d
    JE CIRCLE_QUEUE
        
    NAO_ATIRA:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    
    CIRCLE_QUEUE:
        MOV PTR_TIROS, 00d
        JMP NAO_ATIRA
    
    TIRO_OK1:
        SUB AL, 20d
        CMP POS_NAVE_X, AL
        JGE VOLTA_TIRO
        JMP NAO_ATIRA
    
    NORMALIZA_RANDOM_1:
        SUB DL, 100d
        CMP DL, 100d
        JGE NORMALIZA_RANDOM_2
        JMP BACK_NORMALIZA_1
    
    NORMALIZA_RANDOM_2:
        SUB DL, 55d
        CMP DL,55d
        JGE NORMALIZA_RANDOM_2
        JMP BACK_NORMALIZA_2  
    
RANDOM_TIRO ENDP

RANDOM_SPACESHIP PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	CALL RANDOM
	
	CMP AL, 2Dh
	Je	OK1
	JMP L_NOT_OK
	
	OK1:
    	MOV SPACESHIP_VISIBLE, 01h
		
	L_NOT_OK:
	POP DX
	POP CX
	POP BX
	POP AX
	RET
RANDOM_SPACESHIP ENDP

MOVE_SPACESHIP PROC
    PUSH DX
    
    CMP SPACESHIP_X, 0D					;VERIFICA SE CHEGOU NO LADRO ESQUERDO
    JE MUDA_SPACESHIP_DIR
    
    CMP SPACESHIP_X, 74D					;VERIFICA SE CHEGOU NO LADO DIREITO
    JE MUDA_SPACESHIP_ESQ

    JMP L_MOVE_SPACESHIP    	

	MUDA_SPACESHIP_DIR:
    	MOV SPACESHIP_DIR, 'D'
    	INC SPACESHIP_X
    	MOV SPACESHIP_VISIBLE, 00d
    	JMP L_MOVE_SPACESHIP
	
    MUDA_SPACESHIP_ESQ:
    	MOV SPACESHIP_DIR, 'E'
    	DEC SPACESHIP_X
    	MOV SPACESHIP_VISIBLE, 00d
    	
    L_MOVE_SPACESHIP:
    	CMP SPACESHIP_DIR, 'D'
		JE MOV_SPACESHIP_DIR
	
		CMP SPACESHIP_DIR, 'E'
		JE MOV_SPACESHIP_ESQ
		
		MOV_SPACESHIP_DIR: 
			INC SPACESHIP_X
			JMP FIM_MOVE_SPACESHIP
			
		MOV_SPACESHIP_ESQ:
			DEC SPACESHIP_X

    FIM_MOVE_SPACESHIP:  
    
    POP DX
    
    RET
MOVE_SPACESHIP ENDP

VERIFICA_MOVE_NAVES_INIMIGAS PROC
    PUSH AX
    PUSH CX
    push dx
    
    CALL GET_TICKS
    SUB CH, LAST_TICKS_HOUR
    CMP CH, 1h
    JE ADD_TO_TICKS
    BACK_TO_TICKS:
    
    SUB AX, LAST_TICKS
    mov dx, 0000h
    mov dl, delay_inimigo
    CMP AX, dx
    JL FIM_VERIFICA_MOVE
    
    CALL MOVE_NAVES_INIMIGAS
    CALL GET_TICKS
    MOV LAST_TICKS, AX
    MOV LAST_TICKS_HOUR, CH
    
    jmp fim_verifica_move
    
    ADD_TO_TICKS:
        mov dl, ch
        add dl, 30H
        mov ah, 02H
        int 21h
        mov ah, 4ch
        int 21h
        ADD AX, 0E10h
        JMP BACK_TO_TICKS
        
    FIM_VERIFICA_MOVE:
    pop dx
    POP CX
    POP AX
    RET
VERIFICA_MOVE_NAVES_INIMIGAS ENDP

MOVE_NAVES_INIMIGAS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV CL, MAX_INIMIGO ;NUM_INIMIGO
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    
    CALL ACHA_INIMIGO_ESQUERDA
    CMP LEFTMOST_ENEMY_X, 0D					;VERIFICA SE CHEGOU NO LADRO ESQUERDO
    JE NAVE_INIMIGA_DIR
    
    CALL ACHA_INIMIGO_DIREITA
    CMP RIGHTMOST_ENEMY_X, 74D					;VERIFICA SE CHEGOU NO LADO DIREITO
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
        CALL ACHA_INIMIGO_EMBAIXO
        CMP BOTTOMOST_ENEMY_Y, 21d
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
		dec dl
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

    MOV CL, INIMIGO_LINHA;NUM_INIMIGO por linha
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    MOV AL, 00h
    MOV LINHA, 00h
    
    OUTTER_LOOP:
        MOV CL, INIMIGO_LINHA;NUM_INIMIGO por linha
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
            CMP DL, 'S'          ;DESENHA CRAB
            JNE DESENHADO
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
    WRITE_STRING OCTOPUS
    
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
    WRITE_STRING SQUID_LOWER
    
    POP BX
    POP DX
    
    RET
DESENHA_SQUID ENDP

DESENHA_SPACESHIP PROC
	GOTOXY SPACESHIP_X SPACESHIP_Y
	WRITE_STRING SPACESHIP
	
	RET
DESENHA_SPACESHIP ENDP

DESENHA_TIROS_INIMIGOS PROC
    PUSH AX    
    PUSH BX
    PUSH CX
    PUSH DX

    GOTOXY [TIRO_INIMIGO_X] [TIRO_INIMIGO_Y]
    WRITE_STRING TIRO_INIMIGO_ASCII
        
    GOTOXY [TIRO_INIMIGO_X+1] [TIRO_INIMIGO_Y+1]
    WRITE_STRING TIRO_INIMIGO_ASCII
    
    GOTOXY [TIRO_INIMIGO_X+2] [TIRO_INIMIGO_Y+2]
    WRITE_STRING TIRO_INIMIGO_ASCII
    
    GOTOXY [TIRO_INIMIGO_X+3] [TIRO_INIMIGO_Y+3]
    WRITE_STRING TIRO_INIMIGO_ASCII
    
    GOTOXY [TIRO_INIMIGO_X+4] [TIRO_INIMIGO_Y+4]
    WRITE_STRING TIRO_INIMIGO_ASCII
    
    CALL ESCONDE_CURSOR
        
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DESENHA_TIROS_INIMIGOS ENDP

DESENHA_TIROS PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    CALL DESENHA_TIROS_INIMIGOS
    
    MOV DL, TIROS        ; item do array para var auxiliar
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 00d           ; verifica se o tiro deve ser desenhado ou não
    JE L_NAO_DESENHA_TIRO
        
    GOTOXY TIRO_X TIRO_Y
    WRITE_STRING TIRO
        
    L_NAO_DESENHA_TIRO:
       
    POP DX
    POP CX
    POP BX     
    RET
DESENHA_TIROS ENDP

ATIRAR PROC
    PUSH CX
    PUSH BX
    PUSH DX
    
    MOV DL, TIROS
    CMP DL, 01h
    JE L_NAO_ATIRA
    
    MOV DL, POS_NAVE_X
    ADD DL, 02d    ; normalizando posição tiro
    MOV TIRO_X, DL
    
    MOV DL, 21d
    MOV TIRO_Y,DL    
    
    MOV DL, 01h
    MOV TIROS, DL
            
    L_NAO_ATIRA:
        POP DX
        POP BX
        POP CX
        RET
ATIRAR ENDP

MOVE_TIROS_INIMIGOS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CL, MAX_TIROS
    MOV BX, OFFSET TIRO_INIMIGO_Y
    
    LOOP_MOVE_TIRO_INIMIGO:
        MOV DL, [BX]
        ADD DL, 1
        CMP DL, 25d
        JE MORRE_TIRO_INIMIGO
        BACK_MOVE_TIRO:
        MOV [BX], DL
        INC BX
        LOOP LOOP_MOVE_TIRO_INIMIGO        
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    MORRE_TIRO_INIMIGO:
        DEC NUM_TIROS
        MOV DL, 30d
        JMP BACK_MOVE_TIRO
MOVE_TIROS_INIMIGOS ENDP

MOVE_TIROS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    CALL MOVE_TIROS_INIMIGOS
    
    MOV DL, TIROS        ; item do array para var auxiliar
    MOV AUX_MOV, DL
    
    CMP AUX_MOV, 00d           ; verifica se o tiro deve ser desenhado ou não
    JE L_NAO_MOVE_TIRO
        
    DEC TIRO_Y
    
    ; se o tiro chegou na borda da tela
    CMP TIRO_Y, 00h
    JNE L_NAO_MOVE_TIRO
    MOV TIROS, 00h
        
    L_NAO_MOVE_TIRO:
      
    POP DX  
    POP CX   
    POP BX
    POP AX
    RET
MOVE_TIROS ENDP

VERIFICA_INIMIGO_ATINGIU_BARREIRA PROC
    PUSH BX
    PUSH DX
    PUSH AX
    
    mov al, max_tiros
    sub ax, cx
    MOV BX, OFFSET TIRO_INIMIGO_X
    ADD BX, AX
    MOV DL, [BX]
        
    MOV BX, OFFSET BARRIERS
    ADD BX, DX
    MOV DL, [BX]
    CMP DL, 219d
    JE DESTROI_BARREIRA_1
    CMP DL, 178d
    JE DESTROI_BARREIRA_2
    CMP DL, 177d
    JE DESTROI_BARREIRA_3
    CMP DL, 176d
    JE DESTROI_BARREIRA_4
    
    JMP NAO_BARREIRA

    DESTROI_BARREIRA_1:
        MOV DL, 178d
        MOV [BX], DL
        JMP FIM_ATINGIU_BARREIRA
    
    DESTROI_BARREIRA_2:
        MOV DL, 177d
        MOV [BX], DL
        JMP FIM_ATINGIU_BARREIRA
        
    DESTROI_BARREIRA_3:
        MOV DL, 176d
        MOV [BX], DL
        JMP FIM_ATINGIU_BARREIRA
        
    DESTROI_BARREIRA_4:
        MOV DL, " "
        MOV [BX], DL
    
    FIM_ATINGIU_BARREIRA:
    POP AX
    POP DX
    POP BX
    mov dl, 24h
    mov [bx], dl
    
    JMP FIM_BARREIRA

    NAO_BARREIRA:
        POP AX
        POP DX
        POP BX
        
    FIM_BARREIRA:
    RET
VERIFICA_INIMIGO_ATINGIU_BARREIRA ENDP


VERIFICA_TIRO_ATINGIU_PLAYER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, OFFSET TIRO_INIMIGO_Y
    MOV CL, MAX_TIROS
    
    LOOP_VERIFICA_PLAYER_Y:
        MOV DL, [BX]
        CMP DL, 23d
        JE VERIFICA_PLAYER_X
        CMP DL, 20d
        JE VERIFICA_BARREIRA
        BACK_TO_LOOP:
        INC BX
        LOOP LOOP_VERIFICA_PLAYER_Y
        
    JMP NAO_ATINGIU_PLAYER
    
    VERIFICA_BARREIRA:
        CALL VERIFICA_INIMIGO_ATINGIU_BARREIRA
        JMP BACK_TO_LOOP
    
    VERIFICA_PLAYER_X:
        PUSH BX
        mov al, max_tiros
        sub ax, cx
        MOV BX, OFFSET TIRO_INIMIGO_X
        add bx, ax
        mov dl, [bx]
        pop bx
        cmp dl, pos_nave_x
        jge atingiu_player_x_1
        jmp NAO_ATINGIU_PLAYER

    atingiu_player_x_1:
        mov al, pos_nave_x
        add al, 04
        cmp dl, al
        jle atingiu_player
        jmp nao_atingiu_player
        
    atingiu_player:
        dec numero_vidas
        mov pos_nave_x, 10d
        mov dl, 24h
        mov [bx], dl
        
    NAO_ATINGIU_PLAYER:
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VERIFICA_TIRO_ATINGIU_PLAYER ENDP

VERIFICA_PLAYER_ATINGIU_BARREIRA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, OFFSET BARRIERS
    MOV AL, TIRO_X
    ADD BX, AX
    
    MOV DL, [BX]
    CMP DL, 219d
    JE P_DESTROI_BARREIRA_1
    CMP DL, 178d
    JE P_DESTROI_BARREIRA_2
    CMP DL, 177d
    JE P_DESTROI_BARREIRA_3
    CMP DL, 176d
    JE P_DESTROI_BARREIRA_4
    
    JMP P_NAO_BARREIRA

    P_DESTROI_BARREIRA_1:
        MOV DL, 178d
        MOV [BX], DL
        JMP P_FIM_ATINGIU_BARREIRA
    
    P_DESTROI_BARREIRA_2:
        MOV DL, 177d
        MOV [BX], DL
        JMP P_FIM_ATINGIU_BARREIRA
        
    P_DESTROI_BARREIRA_3:
        MOV DL, 176d
        MOV [BX], DL
        JMP P_FIM_ATINGIU_BARREIRA
        
    P_DESTROI_BARREIRA_4:
        MOV DL, " "
        MOV [BX], DL
        
    P_FIM_ATINGIU_BARREIRA:
        MOV TIROS, 00h
    
    P_NAO_BARREIRA:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VERIFICA_PLAYER_ATINGIU_BARREIRA ENDP

TRATA_ATINGIU_SPACE PROC
    PUSH DX

    CMP SPACESHIP_VISIBLE, 01h
    JNE FIM_TRATA_ATINGIU_SPACE
    
    MOV DL, SPACESHIP_X
    CMP TIRO_X, DL
    JGE ATINGIU_1
    JMP FIM_TRATA_ATINGIU_SPACE
    
    ATINGIU_1:
        ADD DL, 04d
        CMP TIRO_X, DL
        JLE ATINGIU_2
        JMP FIM_TRATA_ATINGIU_SPACE
    
    ATINGIU_2:
        MOV AH, 2Ch
        INT 21h
        
        CMP DH, 10d
        JLE PONTUA_50
        CMP DH, 20d
        JLE PONTUA_100
        CMP DH, 30d
        JLE PONTUA_150
        CMP DH, 40d
        JLE PONTUA_200
        CMP DH, 50d
        JLE PONTUA_250
        
        ADD C_SCORE, 3d
        JMP FIM_PONTUA
        
        PONTUA_50:
            ADD D_SCORE, 5d
            JMP FIM_PONTUA
            
        PONTUA_100:
            ADD C_SCORE, 1d
            JMP FIM_PONTUA
            
        PONTUA_150:
            ADD D_SCORE, 5d
            ADD C_SCORE, 1d
            JMP FIM_PONTUA
            
        PONTUA_200:
            ADD C_SCORE, 2d
            JMP FIM_PONTUA
            
        PONTUA_250:
            ADD D_SCORE, 5d
            ADD C_SCORE, 2d
            
        FIM_PONTUA:
            MOV TIROS, 00h
            MOV SPACESHIP_VISIBLE, 00h
    
    FIM_TRATA_ATINGIU_SPACE:
    POP DX
    RET
TRATA_ATINGIU_SPACE ENDP

VERIFICA_TIRO_ATINGIU_INIMIGO PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
	MOV CL, MAX_LINHA
	MOV LINHA, 00d

	CMP TIROS, 00d
	JNE L_INICIO_VERIFICA_Y
	JMP L_FIM_VERIFICA

    L_INICIO_VERIFICA_Y:
        CMP TIRO_Y, 20d
        JE L_ATINGIU_BARREIRA_Y
        CMP TIRO_Y, 01d
        JE ATINGIU_SPACE
        JMP L_VERIFICA_Y
        
    L_ATINGIU_BARREIRA_Y:
        CALL VERIFICA_PLAYER_ATINGIU_BARREIRA
        JMP L_VERIFICA_AUX

	L_VERIFICA_Y:				; verifica se o y do tiro coincide com o y das naves
		MOV DL, [BX]
		CMP TIRO_Y, DL
		JE L_ATINGIU_Y			; se é igual atingiu no eixo Y
		INC BX
		INC LINHA				; vai pra proxima linha, usado pra posicionar o vetor x
		LOOP L_VERIFICA_Y	

    JMP L_FIM_VERIFICA	    

    ATINGIU_SPACE:  
        CALL TRATA_ATINGIU_SPACE
		JMP L_FIM_VERIFICA
	
	L_ATINGIU_Y:
		PUSH BX
		PUSH CX
		
		MOV BX, OFFSET POS_NAVES_INIMIGAS_X
		MOV AX, 0000h
		MOV CL, LINHA
		MULT:
			ADD AL, 11d
			LOOP MULT
		ADD BX, AX
		MOV CL, 11d
				
		L_VERIFICA_X:
			MOV DL, [BX]
			CMP DL, TIRO_X
			JLE L_ATINGIU_P1
			L_BACK_VERIFICA_X:
			INC AX
			INC BX
			LOOP L_VERIFICA_X
		
		L_BACK_TO_CLOSE:	
		POP BX
		POP CX	
	
		JMP L_FIM_VERIFICA
		
		L_ATINGIU_P1:
			ADD DL, 03d
			CMP DL, TIRO_X
			JGE L_ATINGIU
			JMP L_BACK_VERIFICA_X

	L_ATINGIU:
		PUSH BX
		PUSH CX
		
		MOV BX, OFFSET TIPO_NAVE_INIMIGA
		ADD BX, AX
		
		MOV DL, "O"
		CMP [BX], DL
		JNE L_PT_CRAB
		ADD D_SCORE, 1d
		ADD PONTOS_VIDA, 10d
		JMP PONTUADO
		
		L_PT_CRAB:
		MOV DL, "C"
		CMP [BX], DL
		JNE L_PT_SQUID
		ADD D_SCORE, 2d
		ADD PONTOS_VIDA, 20d
		JMP PONTUADO
		
		L_PT_SQUID:
		MOV DL, "S"
		CMP [BX], DL
		JNE PONTUADO
		ADD D_SCORE, 3d
		ADD PONTOS_VIDA, 30d
		JMP PONTUADO		
		
		PONTUADO:
		CMP D_SCORE, 10d
		jge inc_c_score
		back_pontuado:
		
		MOV DL, " "
		CMP [BX], DL
		JE L_FAZ_NADA
		
		MOV [BX], DL
		MOV TIROS, 00h
		DEC NUM_INIMIGO
				
		L_FAZ_NADA:						
		POP BX
		POP CX
		

		JMP L_BACK_TO_CLOSE
		
		inc_c_score:
			inc c_score
			sub d_score, 10d
			cmp c_score, 10d
			jge inc_m_score
			jmp back_pontuado
			
		inc_m_score:
			inc m_score
			sub c_score, 10d
			jmp back_pontuado

	L_FIM_VERIFICA:
	CMP PONTOS_VIDA, 1500d
    JGE ADD_VIDA
    JL L_VERIFICA_AUX
    ADD_VIDA:
        INC NUMERO_VIDAS
        SUB PONTOS_VIDA, 1500d
    L_VERIFICA_AUX:
	POP DX
	POP CX
	POP BX
	POP AX
	RET
VERIFICA_TIRO_ATINGIU_INIMIGO ENDP

;gera numero aleatorio em ax
random proc
	mov ax, seed
	mov dx, 8403h
	mul dx
	inc ax
	mov seed,ax
	ret
random endp

ACHA_INIMIGO_EMBAIXO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, OFFSET TIPO_NAVE_INIMIGA
    MOV AX, 0000h
    MOV AL, MAX_INIMIGO
    SUB AX, 01d
    ADD BX, AX
    MOV CL, MAX_INIMIGO
    
    BAIXO_ACHA_INIMIGO_LOOP:
        MOV DL, [BX]
        CMP DL, " "
        JNE BAIXO_ACHOU
        DEC BX
        DEC AX
        LOOP BAIXO_ACHA_INIMIGO_LOOP
    
    BAIXO_ACHOU:
    MOV BX, OFFSET POS_NAVES_INIMIGAS_Y
    MOV CX, 00h
    CMP AL, 11d
    JLE SEM_DIV
    DIV_LOOP:
        SUB AL, 11d
        INC CX
        CMP AL, 11d
        JGE DIV_LOOP
    SEM_DIV:
    ADD BX, CX
    MOV DL, [BX]
    MOV BOTTOMOST_ENEMY_Y, DL
    
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ACHA_INIMIGO_EMBAIXO ENDP


ACHA_INIMIGO_DIREITA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
        
    MOV LINHA, 10d
    OUTER_ACHA_LOOP:
        MOV BX, OFFSET TIPO_NAVE_INIMIGA
        MOV AX, 0000h
        MOV AL, LINHA
        ADD BX, AX
        MOV CL, MAX_LINHA
        INNER_ACHA_LOOP:
            MOV DL, [BX]
            CMP DL, " "
            JNE ACHOU
            MOV DL, 11d
            MOV_BX:
                INC BX
                DEC DL
                CMP DL, 00h
                JNE MOV_BX
            LOOP INNER_ACHA_LOOP
        
        DEC LINHA
        CMP LINHA, 00d
        JE ACHOU
        JMP OUTER_ACHA_LOOP
    
    ACHOU:
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    MOV AX, 0000h
    MOV AL, LINHA
    ADD BX, AX
    MOV DL, [BX]
    MOV RIGHTMOST_ENEMY_X, DL

    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
ACHA_INIMIGO_DIREITA ENDP

ACHA_INIMIGO_ESQUERDA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
        
    MOV LINHA, 00d
    D_OUTER_ACHA_LOOP:
        MOV BX, OFFSET TIPO_NAVE_INIMIGA
        MOV AX, 0000h
        MOV AL, LINHA
        ADD BX, AX
        MOV CL, MAX_LINHA
        D_INNER_ACHA_LOOP:
            MOV DL, [BX]
            CMP DL, " "
            JNE D_ACHOU
            MOV DL, 11d
            D_MOV_BX:
                INC BX
                DEC DL
                CMP DL, 00h
                JNE D_MOV_BX
            LOOP D_INNER_ACHA_LOOP
        
        INC LINHA
        CMP LINHA, 11d
        JE D_ACHOU
        JMP D_OUTER_ACHA_LOOP
    
    D_ACHOU:
    MOV BX, OFFSET POS_NAVES_INIMIGAS_X
    MOV AX, 0000h
    MOV AL, LINHA
    ADD BX, AX
    MOV DL, [BX]
    MOV LEFTMOST_ENEMY_X, DL

    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
ACHA_INIMIGO_ESQUERDA ENDP

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
		call show_score
		CALL ESCONDE_CURSOR
        ;MOV AH, 07H
        ;INT 21H
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
    	CALL INICIA_JOGO
    
        POP AX
        POP DX
    RET
TELA_INICIAL ENDP

INICIA_JOGO PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	mov num_inimigo, 55
	mov DIR_NAVE_INIMIGA, 'D'

    mov tiros, 00
    mov numero_vidas, 33h

	mov POS_NAVE_X, 10d
	
	mov bx, offset tiro_inimigo_y
	mov cx, 5
	l_add_tiro:
	    mov dl, 25d
	    mov [bx], dl
	    inc bx
	    loop l_add_tiro
	
	mov bx, offset tipo_nave_inimiga
	mov cx, 11
	l_add_squids:
		mov dl, 'S'
		mov [bx], dl
		inc bx
		loop l_add_squids
		
	mov cx, 22
	l_add_crabs:
		mov dl, 'C'
		mov [bx], dl
		inc bx
		loop l_add_crabs
		
	mov cx, 22
	l_add_octopus:
		mov dl, 'O'
		mov [bx], dl
		inc bx
		loop l_add_octopus

	mov bx, offset pos_naves_inimigas_y
	mov cl, max_linha
	mov dl, 01
	ADD DL, LEVEL
	
	l_set_y_position:
		mov [bx], dl
		add dl, 02
		inc bx
		loop l_set_y_position
		
	mov bx, offset pos_naves_inimigas_x
	mov ax, 05h
	
	l_outter_set_x_position:
		mov cl, 11d
		mov dl, 00d
		
		l_inner_set_x_position:
			mov [bx], dl
			add dl, 05
			inc bx
			loop l_inner_set_x_position
		
		dec ax
		jnz l_outter_set_x_position
	
	POP DX
	POP CX
	POP BX
	POP AX
	ret
INICIA_JOGO ENDP

END MAIN
