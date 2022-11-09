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
    BACKINTRO   DB "Pressione ENTER para Continuar $"

    OPT         DB "Operacao -> $"
    QUODIV      DB "Quociente -> $"
    REMDIV      DB "Resto -> $"

    ;Errors Messages
    INVOPT      DB "Opcao Invalida. Tente Novamente $"
    INVINPT     DB "Entrada Invalida. Tente Novamente $"
    DIV_0       DB "Operacao Invalida. Nao eh possivel dividir por 0 $"

.CODE

; ----------------------------------------------------- MACROS ---------------------------------------------------------------
;Function Name: NewLine (MACRO)
;Description: Funtion used only to jump to next line
;Register used: None
NewLine MACRO
    ; to jump to next line
    MOV DL, 10 
    MOV AH, 02h 
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
ENDM

;Function Name: CLICALL (MACRO)
;Description: Funtion used only to print ">" char just to make the program fancy
;Register used: None
CLICALL MACRO
    ;display caracter
    MOV AH, 09
    LEA DX, CLIARROW
    INT 21h
ENDM

; ----------------------------------------------------- MACROS ---------------------------------------------------------------

; ----------------------------------------------------- MAIN PROC ------------------------------------------------------------

MAIN PROC

    MOV AX, @DATA
    MOV DS,AX

    call introPrint

; End of program
FIM:
    MOV AH, 4CH ;retorna ao programa
    INT 21H
MAIN ENDP

; ----------------------------------------------------- Functions ------------------------------------------------------------

;Function Name: introPrint
;Description: Funtion used only to print the program intro header
;Register used: None
introPrint PROC

    ; Clear the screen
    MOV AX,3H			
	INT 10H	

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

    call receiveCheckOpt
    
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

; ----------------------------------------------------- Extend Functions -----------------------------------------------------
;Function Name: extEnd
;Description: Just Extend the JMP for the end Procediment
;Register used: None
extEnd PROC
    JMP FIM
extEnd ENDP

;Function Name: extADD
;Description: Just Extend the JMP for the ADD Procediment
;Register used: None
extADD PROC
    JMP addFunction
extADD ENDP

;Function Name: extSUB
;Description: Just Extend the JMP for the SUB Procediment
;Register used: None
extSUB PROC
    JMP subFunction
extSUB ENDP

;Function Name: extMUL
;Description: Just Extend the JMP for the MUL Procediment
;Register used: None
extMUL PROC
    JMP mulFunction
extMUL ENDP

;Function Name: extDIV
;Description: Just Extend the JMP for the DIV Procediment
;Register used: None
extDIV PROC
    JMP divFunction
extDIV ENDP

; ----------------------------------------------------------------- Extend Functions -----------------------------------------------------

; ----------------------------------------------------------------- Commom Functions -----------------------------------------------------
;Function Name: readN1
;Description: Funtion used to read the first number that we gonna used on the operation
;Register used: BL used for store the number read
readN1 PROC

    ; Print message to indicate to user what he/she needs to do
    MOV AH, 09
    LEA DX, N1SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H

    ; If the char read it's < 0, print error because we don't support it
    CMP AL, 30h
    JB ErrorN1

    ; If the char read it's > 9, print error because we don't support it
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

    ; Print message to indicate to user what he/she needs to do
    MOV AH, 09
    LEA DX, N2SELECT
    INT 21h

    NewLine

    CLICALL
    
    MOV AH, 1
    INT 21H

    ; If the char read it's < 0, print error because we don't support it
    CMP AL, 30h
    JB ErrorN2

    ; If the char read it's > 9, print error because we don't support it
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
;Register used: None
printNum PROC
    MOV AX, BX ; The result of most of our Maths are in BX, and because se gonna use it, save the result in AX
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

;Function Name: printNumDIV
;Description: Funtion used to print the result of the Division
;Register used: None
printNumDIV PROC
    ; Necessary to use the Stack because our Quotient is in CX and the Remainder is in AX
    POP SI ; Save the return END, so we can back to the function that call it
    POP CX ; Get Quotient Value from Stack

    ; Print message only for indicate what is this number
    MOV AH, 09
    LEA DX, QUODIV
    INT 21h

    ; Print quotient with two digits
    MOV AX, CX
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

    NewLine

    ; Print message only for indicate what is this number
    MOV AH, 09
    LEA DX, REMDIV
    INT 21h

    POP AX ; Get the Remainder value from Stack

    ; Print Remainder with two digits
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

    ; Restore the Caller END in Stack for go back to the function that call it
    PUSH SI

    RET
printNumDIV ENDP
; ----------------------------------------------------------------- Commom Functions -----------------------------------------------------

; ----------------------------------------------------------------- Math Functions -----------------------------------------------------
;Function Name: addFunction
;Description: Funtion used to do the sum
;Register used: BL as First Input (obtained from readN1) and CL as Second Input (obtained from readN2)
addFunction PROC

    NewLine

    ; Print Msg for the operation selected
    MOV AH, 09
    LEA DX, ADDSELECT
    INT 21h
    
    NewLine

    ; Call functions to read the values that we gonna use to do the operation
    call readN1

    NewLine

    call readN2

    NewLine

    ; Print the operation that user whats to do
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
    
    ; Get the real value, and not the char value
    SUB BL, 30h
    SUB CL, 30h

    ADD BL, CL
    
    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    ; Waits for a ENTER
    MOV AH, 1
    INT 21H

    ; Back to Menu
    call introPrint

addFunction ENDP

;Function Name: subFunction
;Description: Funtion used to do the subtraction
;Register used: BL as First Input (obtained from readN1) and CL as Second Input (obtained from readN2)
subFunction PROC

    NewLine

    ; Print Msg for the operation selected
    MOV AH, 09
    LEA DX, SUBSELECT
    INT 21h
    
    NewLine

    ; Call functions to read the values that we gonna use to do the operation
    call readN1

    NewLine

    call readN2

    NewLine

    ; Print the operation that user whats to do
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
    
    ; Get the real value, and not the char value
    SUB BL, 30h
    SUB CL, 30h

    SUB BL, CL
    
    MOV AH,2
	MOV DL, "="
	INT 21H

;   IF BL < 0
    ; Check if the result it's negative, if it's we need to print the "-" char before print the number
    TEST BL, 80h
    JNZ Negative_Print
;   ELSE
    ; If we call the function here, so the number it's not negative
    call printNum

Back_Menu:
    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    ; Waits for a ENTER
    MOV AH, 1
    INT 21H

    ; Back to Menu
    call introPrint

Negative_Print:
    ; Result of the operation is negative, print the "-" char
    MOV AH, 02
    MOV DL, "-"
    INT 21h

    ; Necessary to get the C2 number
    NEG BL

    call printNum

    call Back_Menu

subFunction ENDP

;Function Name: mulFunction
;Description: Funtion used to do the MUL operation
;Register used: BL as First Input (obtained from readN1), CL as Second Input (obtained from readN2) and DX for the result of the operation (DX = BL * CL)
mulFunction PROC

    NewLine

    ; Print Msg for the operation selected
    MOV AH, 09
    LEA DX, MULSELECT
    INT 21h
    
    NewLine

    ; Call functions to read the values that we gonna use to do the operation
    call readN1

    NewLine

    call readN2

    NewLine

    ; Print the operation that user whats to do
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

    ; Get the real value, and not the char value
    SUB BL, 30h
    SUB CL, 30h

    ; Change to AL and BL just to make sure that any counter gonna cause some trouble
    MOV AL, BL
    MOV BL, CL

    ; Because we are only using the LOW Register, we need to clean the HIGH Register to make sure that we don't have any trash
    XOR AH, AH
    XOR BH, BH
    AND DX,0    ; Initialize DX with 0

MUL_ADD:
;   IF LSB = 1
    TEST BX,1 ; LSB BX = 1? (LSB = Less Significant Byte)
    JZ DESLOC_MUL       ; No, LSB = 0
;   THEN
    ADD DX,AX ; DX = DX + AX (PROD = PROD + AX)
;   END IF
DESLOC_MUL:    
    SHL AX,1        ;Shift left 1 bit
    SHR BX,1        ;Shift right 1 bit

    JNZ MUL_ADD

    ; Save the result in BX to print
    MOV BX, DX

    MOV AH,2
	MOV DL, "="
	INT 21H

    ; Function used to print always 2 digits
    call printNum

    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    ; Waits for a ENTER
    MOV AH, 1
    INT 21H

    ; Back to Menu
    call introPrint

mulFunction ENDP

;Function Name: divFunction
;Description: Funtion used to do the DIV operation
;Register used: CX divided by DX and the result is Quotient saves in CX and Reminder saves in AX
divFunction PROC

    NewLine

    ; Print Msg for the operation selected
    MOV AH, 09
    LEA DX, DIVSELECT
    INT 21h
    
    NewLine

    ; Call functions to read the values that we gonna use to do the operation
    call readN1

    NewLine

    call readN2

    NewLine

    ; Print the operation that user whats to do
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

    CMP CL, 30h
    JE DIV0_ERROR

    ; Get the real value, and not the char value
    SUB BL, 30h
    SUB CL, 30h

    ; Because we are only using the LOW Register, we need to clean the HIGH Register to make sure that we don't have any trash
    XOR BH, BH
    XOR CH, CH

    ; Save the value BX value in CX and the CX value in DX for do the operation later
    MOV DX, CX
    MOV CX, BX

    ; Clean make sure that we don't have any trash
    MOV AX, 0
    MOV BP, 10H

DIV_SUB:  
    SAL CX, 1
    RCL AX, 1
    CMP AX, DX
    JB  CHECK_QUO_REM
    SUB AX, DX
    INC CX

CHECK_QUO_REM: 
    DEC BP
    JNZ DIV_SUB

    PUSH AX
    PUSH CX

    NewLine

    ; Function used to print the Quotiente and the Reminder with two digits
    call printNumDIV

    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    ; Waits for a ENTER
    MOV AH, 1
    INT 21H

    ; Back to Menu
    call introPrint

DIV0_ERROR:
    NewLine

    MOV AH, 09
    LEA DX, DIV_0
    INT 21h

    NewLine

    ; Message to indicate how to turn back to the menu
    MOV AH, 09
    LEA DX, BACKINTRO
    INT 21h

    ; Waits for a ENTER
    MOV AH, 1
    INT 21H

    ; Back to Menu
    call introPrint

divFunction ENDP

End MAIN