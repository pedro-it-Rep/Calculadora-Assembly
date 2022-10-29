; TO DO LIST
; verificar operacao de Multiplicacao e divisao, olhar comentarios
; copiei a ft que enviou no whats pra imprimir os numeros, mas so o primeiro esta imprimindo certo
; verificação de numeros esta sendo estando dando errado quando verifica se é maior que 9

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

    OPT         DB "Operacao -> $"

    ;Errors Messages
    INVOPT      DB "Opcao Invalida. Tente Novamente $"

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
introPrint PROC
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

;description
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

addFunction PROC
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    ; read first number
    MOV AH, 01
    INT 21H

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    NewLine
    ;if number is correct, store in BL
    MOV BL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL

    ; read second number
    MOV AH, 01
    INT 21H
    MOV CL, AL

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    ;if number is correct, store in BL
    MOV CL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AX, 10
    MOV BL, 10
    DIV BL

    MOV BX, AX
    MOV DL, BL
    
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H

    ;display caracter
    MOV AH,2
	MOV DL, 43 ; '+'
    INT 21H

    MOV DL, BH
    OR DL, 30h

    ; write second number
    MOV AH, 02
    INT 21H   
    
    SUB BL, 30h
    SUB CL, 30h

    ; operation
    ADD BL, CL
    
    ;display caracter
    MOV AH, 02
	MOV DL, 61 ; ' = '
	INT 21H

    ADD BL, 30h
    
    ;write second number
    MOV AH, 02
    MOV DL, BL
    INT 21H

    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint

addFunction ENDP

subFunction PROC

    NewLine

    ; display message
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    ; read first number
    MOV AH, 01
    INT 21H

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    NewLine
    ;if number is correct, store in BL
    MOV BL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL

    ; read second number
    MOV AH, 01
    INT 21H
    MOV CL, AL

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    ;if number is correct, store in BL
    MOV CL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AX, 10
    MOV BL, 10
    DIV BL

    MOV BX, AX
    MOV DL, BL
    
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H

    ;display caracter
    MOV AH, 02
	MOV DL, 43 ; '+'
    INT 21H

    MOV DL, BH
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H   
    
    SUB BL, 30h
    SUB CL, 30h

    ; operation
    SUB BL, CL
    
    ;display caracter
    MOV AH, 02
	MOV DL, 61 ; ' = '
	INT 21H

    ADD BL, 30h
    
    ;write second number
    MOV AH, 02
    MOV DL, BL
    INT 21H

    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint
subFunction ENDP

mulFunction PROC
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    ; read first number
    MOV AH, 01
    INT 21H

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    NewLine
    ;if number is correct, store in BL
    MOV BL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL

    ; read second number
    MOV AH, 01
    INT 21H
    MOV CL, AL

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    ;if number is correct, store in BL
    MOV CL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AX, 10
    MOV BL, 10
    DIV BL

    MOV BX, AX
    MOV DL, BL
    
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H

    ;display caracter
    MOV AH, 02
	MOV DL, 43 ; '+'
    INT 21H

    MOV DL, BH
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H   
    
    SUB BL, 30h
    SUB CL, 30h

    ; operation

    ;store BL content in DL
    MOV DL, CL

    ; verify how much times mul BL
    ;DIV DX, 2
    ;erro: extra chacarters on line

    ;shift to left is same MUL per 2
    ;SHL BL, DL
    ; erro: rotate count must be constant or CL, pq so CL?

    ;verificar como colocar o resto, apenas multi por ele mesmo, porque seria no maximo mais 1 vezes que multiplicaria que o SHL nao abrange
    
    ;display caracter
    MOV AH, 02
	MOV DL, 61 ; ' = '
	INT 21H

    ADD BL, 30h
    
    ;write second number
    MOV AH, 02
    MOV DL, BL
    INT 21H

    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint
mulFunction ENDP

divFunction PROC
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    ; display message
    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    ; read first number
    MOV AH, 01
    INT 21H

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    NewLine
    ;if number is correct, store in BL
    MOV BL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL

    ; read second number
    MOV AH, 01
    INT 21H
    MOV CL, AL

    ;verify number is larger than 0
;    CMP AL, 0
;    JL extcheckNumber

    ;verify number is smaller than 9
;    CMP AL, 9
;    JG extcheckNumber
    ; esta sendo entrando aqui sempre, nao sei pq

    ;if number is correct, store in BL
    MOV CL, AL

    NewLine

    ;display message
    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AX, 10
    MOV BL, 10
    DIV BL

    MOV BX, AX
    MOV DL, BL
    
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H

    ;display caracter
    MOV AH, 02
	MOV DL, 43 ; '+'
    INT 21H

    MOV DL, BH
    OR DL, 30h
    
    ; write second number
    MOV AH, 02
    INT 21H   
    
    SUB BL, 30h
    SUB CL, 30h

    ; operation
    ;store CL content in DL
    MOV DL, CL

    ; verify how much times mul BL
    ;DIV DL, 2
        ;erro: extra chacarters on line


    ;shift to right is same DIV per 2
    ;SHR BL, DL
        ; erro: rotate count must be constant or CL, pq so CL?

    ;verificar como colocar o resto, apenas multi por ele mesmo, porque seria no maximo mais 1 vezes que multiplicaria que o SHL nao abrange
    
    ;display caracter
    MOV AH, 02
	MOV DL, 61 ; ' = '
	INT 21H

    ADD BL, 30h
    
    ;write second number
    MOV AH, 02
    MOV DL, BL
    INT 21H

    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint
divFunction ENDP

checkNumberFuncion PROC
    MOV AH, 02
	MOV DL, 81 ; 'Q '
	INT 21H

    ; apenas para teste
    ;JMP introPrint
checkNumberFuncion ENDP
End MAIN