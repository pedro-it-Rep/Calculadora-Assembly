; TO DO LIST
; ADD PRINT 2 Numbers
; PRINT NEGATIVE NUMBERS
; DEVELOP MUL FUNCTION
; DEVELOP DIV FUNCTION

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
    MOV DL, 10 
    MOV AH, 02h 
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
ENDM

CLICALL MACRO
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
    MOV AH, 09
    LEA DX, BOUNDUP
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, TITULO
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, COMPS
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, DIGITE
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDSOMA
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDSUB
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDMUL
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDDIV
    INT 21h

    NewLine

    MOV AH, 09
    LEA DX, CMDEND
    INT 21h

    NewLine

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

addFunction PROC

    NewLine

    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H
    MOV BL, AL

    NewLine

    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H
    MOV CL, AL

    NewLine

    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    MOV AH,2
	MOV DL, ' + '
	INT 21H
    
    OR CL, 30h
    MOV AH, 2
    MOV DL, CL
    INT 21H
    
    SUB BL, 30h
    SUB CL, 30h
    ADD BL, CL
    
    MOV AH,2
	MOV DL, ' = '
	INT 21H

    ADD BL, 30h

    MOV AH, 2
    MOV DL, BL
    INT 21H

    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint

addFunction ENDP

subFunction PROC

    NewLine

    MOV AH, 09
    LEA DX, SUBSELECT
    INT 21h
    
    NewLine

    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H
    MOV BL, AL

    NewLine

    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H
    MOV CL, AL

    NewLine

    MOV AH, 09
    LEA DX, OPT
    INT 21h

    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    MOV AH,2
	MOV DL, ' - '
	INT 21H
    
    OR CL, 30h
    MOV AH, 2
    MOV DL, CL
    INT 21H
    
    SUB BL, 30h
    SUB CL, 30h
    SUB BL, CL
    
    MOV AH,2
	MOV DL, ' = '
	INT 21H

    ADD BL, 30h

    MOV AH, 2
    MOV DL, BL
    INT 21H

    ; NEED to print Negative Values
    ; ADD Call to print always 2 numbers

    NewLine

    JMP introPrint
subFunction ENDP

mulFunction PROC
    MOV AH, 09
    LEA DX, MULSELECT
    INT 21h
    JMP receiveCheckOpt
mulFunction ENDP

divFunction PROC
    MOV AH, 09
    LEA DX, DIVSELECT
    INT 21h
    JMP receiveCheckOpt
divFunction ENDP

End MAIN