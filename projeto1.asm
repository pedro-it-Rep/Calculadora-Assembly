; TO DO LIST
; Print Negativo na Subtração
; MUL -> Necessario Terminar
; DIV

TITLE Alcides_19060987_PedroTrevisan_18016568
.MODEL SMALL
.STACK 100H

.DATA

    ; Apresentation Prints
    BOUNDUP	    DB "=======================================================$"
	TITULO 	    DB "|                Calculadora - Projeto 1              |$"
    COMPS 	    DB "|                Alcides && Pedro Trevisan            |$"
	DIGITE 	    DB "|  Operadores: (selecione um)                         |$"
	CMDSOMA	    DB "|  A - Soma                                           |$"
	CMDSUB	    DB "|  B - Subtracao                                      |$"
	CMDMUL	    DB "|  C - Multiplicacao                                  |$"
	CMDDIV	    DB "|  D - Divisao                                        |$"
	CMDEND	    DB "|  X - Encerrar calculadora                           |$"
    BOUNDDOWN	DB "|=====================================================|$"

    ; General Usage Prints
    CLIARROW    DB "> $"
    ADDSELECT   DB "Funcao de Soma Selecionada $"
    SUBSELECT   DB "Funcao de Subtracao Selecionada $"
    MULSELECT   DB "Funcao de Multiplicacao Selecionada $"
    DIVSELECT   DB "Funcao de Divisao Selecionada $"
    N1SELECT    DB "Selecione o primeiro numero (0 - 9) $"
    N2SELECT    DB "Selecione o segundo numero (0 - 9) $"
    BACKINTRO   DB "Pressione ENTER para Contiuar $"

    OPT         DB "Operacao -> $"

    ;Errors Messages
    INVOPT      DB "Opcao Invalida. Tente Novamente $"
    INVINPT     DB "Entrada Invalida. Tente Novamente $"

.CODE

; -------------------------------------------------------------------- MACROS -----------------------------------------------------

NewLine MACRO
    ; to start beginning next line
    MOV DL, 10 
    MOV AH, 02h 
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
ENDM

CLICALL MACRO
    ;display caracter
    MOV AH, 09
    LEA DX, CLIARROW
    INT 21h
ENDM

; -------------------------------------------------------------------- MACROS -----------------------------------------------------

; ----------------------------------------------------------------- MAIN PROC -----------------------------------------------------

MAIN PROC

    MOV AX, @DATA
    MOV DS,AX

    call introPrint

    call receiveCheckOpt

; End of program
FIM:
    MOV AH, 4CH ;retorna ao programa
    INT 21H
MAIN ENDP

; ----------------------------------------------------------------- Functions -----------------------------------------------------

;Function Name: introPrint
;Description: Funtion used only to print the program intro header
;Register used: None
introPrint PROC

    ; Clear the screen
    MOV AX,3H			
	INT 10H	

    ;display message
    MOV AH, 09
    LEA DX, BOUNDUP
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, TITULO
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, COMPS
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, DIGITE
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, CMDSOMA
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, CMDSUB
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, CMDMUL
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, CMDDIV
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, CMDEND
    INT 21h

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, BOUNDDOWN
    INT 21h

    NewLine

    RET
introPrint ENDP

;Function Name: receiveCheckOpt
;Description: Funtion used to get what operation user wants to do
;Register used: None
receiveCheckOpt PROC
    
    CLICALL

    MOV AH,1
    INT 21H
    MOV BL, AL ; Get answer and save it in BL to compare to our options

    ; CMP A or a -> in program we accept both
    CMP BL, 41h
    JE extADD

    CMP BL, 61h
    JE extADD

    ; CMP B or b -> in program we accept both
    CMP BL, 42h
    JE extSUB

    CMP BL, 62h
    JE extSUB

    ; CMP C or c -> in program we accept both
    CMP BL, 43h
    JE extMUL

    CMP BL, 63h
    JE extMUL

    ; CMP D or d -> in program we accept both
    CMP BL, 44h
    JE extDIV

    CMP BL, 64h
    JE extDIV

    ; CMP X or x -> in program we accept both
    CMP BL, 58h
    JE extEnd

    CMP BL, 78h
    JE extEnd

    ; Invalid Option Insert -> Print error and ask for it again
    MOV AH, 09
    LEA DX, INVOPT
    INT 21h

    NewLine

    JMP receiveCheckOpt
receiveCheckOpt ENDP

; ----------------------------------------------------------------- Extend Functions -----------------------------------------------------
;Just Extend the JMP for the end Statement
extEnd PROC
    JMP FIM
extEnd ENDP

extADD PROC
    JMP addFunction
extADD ENDP

extSUB PROC
    JMP subFunction
extSUB ENDP

extMUL PROC
    JMP mulFunction
extMUL ENDP

extDIV PROC
    JMP divFunction
extDIV ENDP

extcheckNumber PROC
    ;CMP AL, 0
    ;JA checkNumberFuncion
extcheckNumber ENDP

; ----------------------------------------------------------------- Extend Functions -----------------------------------------------------

; ----------------------------------------------------------------- Commom Functions -----------------------------------------------------
;Function Name: readN1
;Description: Funtion used read the first number that we gonna used on the operation
;Register used: BL used for store the number read
readN1 PROC

    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H

    CMP AL, 30h
    JB ErrorN1

    CMP AL, 39h
    JA ErrorN1

    MOV BL, AL

    RET

ErrorN1:
    NewLine
    MOV AH, 09
    LEA DX, INVINPT
    INT 21h
    NewLine
    JMP readN1

readN1 ENDP

;Function Name: readN2
;Description: Funtion used read the second number that we gonna used on the operation
;Register used: CL used for store the number read
readN2 PROC

    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H

    CMP AL, 30h
    JB ErrorN2

    CMP AL, 39h
    JA ErrorN2

    MOV CL, AL

    RET

ErrorN2:
    NewLine
    MOV AH, 09
    LEA DX, INVINPT
    INT 21h
    NewLine
    JMP readN2

readN2 ENDP

;Function Name: printNum
;Description: Funtion used to print two digits as result
;Register used: 
printNum PROC
    MOV AX, BX
    XOR BH, BH
    MOV BL, 10
    DIV BL
    MOV BX, AX
    MOV DL, BL
    OR DL, 30h
    MOV AH,2
    INT 21H
    MOV DL, BH
    OR DL, 30h
    MOV AH, 2
    INT 21h

    RET
printNum ENDP
; ----------------------------------------------------------------- Commom Functions -----------------------------------------------------

; ----------------------------------------------------------------- Math Functions -----------------------------------------------------
;Function Name: addFunction
;Description: Funtion used to do the sum
;Register used: BL as First Input and CL as Second Input
addFunction PROC

    NewLine

    ; Print Msg for the operation selected
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    call readN1

    NewLine

    call readN2

    NewLine

    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    MOV AH,2
	MOV DL, "+"
	INT 21H
    
    MOV AH, 2
    MOV DL, CL
    INT 21H
    
    SUB BL, 30h
    SUB CL, 30h

    ADD BL, CL
    
    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    NewLine

    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    MOV AH, 1
    INT 21H

    call introPrint

addFunction ENDP

;Function Name: subFunction
;Description: Funtion used to do the subtraction
;Register used: BL as First Input and CL as Second Input
subFunction PROC

    NewLine

    ; display message
    MOV AH, 09
    LEA DX, SUBSELECT
    INT 21h
    
    NewLine

    call readN1

    NewLine

    call readN2

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    MOV AH,2
	MOV DL, "-"
	INT 21H
    
    MOV AH, 2
    MOV DL, CL
    INT 21H
    
    SUB BL, 30h
    SUB CL, 30h
    SUB BL, CL
    
    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    ; NEED to print Negative Values

    NewLine

    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    MOV AH, 1
    INT 21H

    call introPrint

subFunction ENDP

;Function Name: mulFunction
;Description: Funtion used to do the mul operation
;Register used: BX = A, CX = B, DX = A*B
mulFunction PROC

    NewLine

    ; display message
    MOV AH, 09
    LEA DX, MULSELECT
    INT 21h
    
    NewLine

    call readN1

    NewLine

    call readN2

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H

    MOV AH,2
	MOV DL, "*"
	INT 21H
    
    MOV AH, 2
    MOV DL, CL
    INT 21H

    SUB BL, 30h
    SUB CL, 30h

    ; Necessario trocar para o AL e BL, pois CX é um contador
    MOV AL, BL
    MOV BL, CL

    ; Necessario zerar a parte alta, já que só estamos usando a parte baixa e pode conter algum lixo
    XOR AH, AH
    XOR BH, BH
    AND DX,0    ;inicializa DX em 0

MUL_ADD:   
    TEST BX,1 ;LSB de BX = 1?
    JZ DESLOC_MUL       ;nao, (LSB = 0)
    ;then
    ADD DX,AX   ;sim, entao
    ;produto = produto + A
    ;end_if
DESLOC_MUL:    
    SHL AX,1        ;desloca A para a esquerda 1 bit
    SHR BX,1       ;desloca B para a direita 1 bit
    ;until
    JNZ MUL_ADD      ;fecha o loop repeat

    MOV BX, DX

    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    NewLine

    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    MOV AH, 1
    INT 21H

    call introPrint


mulFunction ENDP

divFunction PROC

    NewLine

    ; display message
    MOV AH, 09
    LEA DX, DIVSELECT
    INT 21h
    
    NewLine

    call readN1

    NewLine

    call readN2

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H

    MOV AH,2
	MOV DL, "/"
	INT 21H
    
    MOV AH, 2
    MOV DL, CL
    INT 21H

    SUB BL, 30h
    SUB CL, 30h

    ; Necessario trocar para o AL e BL, pois CX é um contador
    MOV AL, BL
    MOV BL, CL

    ; Necessario zerar a parte alta, já que só estamos usando a parte baixa e pode conter algum lixo
    XOR AH, AH
    XOR BH, BH
    AND DX,0    ;inicializa DX em 0

DIV_SUB:   
    TEST BX,1 
    JZ DESLOC_DIV 
    ;then
    SUB DX,AX 
    ;end_if
DESLOC_DIV:    
    SHR AX,1        
    SHL BX,1       
    ;until
    JNZ DIV_SUB      ;fecha o loop repeat

    MOV BX, DX

    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    NewLine

    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    MOV AH, 1
    INT 21H

    call introPrint

divFunction ENDP

End MAIN