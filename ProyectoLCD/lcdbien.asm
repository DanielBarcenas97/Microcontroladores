   processor 16F877a
   include <P16F877a.INC>

;Variables para DELAY
val1 equ 0x30
val2 equ 0x31
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 100h 
cte2 equ 500h
cte3 equ 600h	


;Definicion de variables a utilizar para
;comparar las entradas a traves del puerto A
v0 equ h'24'  
v1 equ h'25'
v2 equ h'26'
v3 equ h'27'
c0 equ 0h 
c1 equ 1h
c2 equ 2h
c3 equ 3h 

    org 0              ;Vector de RESET
    goto INICIO			
    org 5              ;Inicio del Programa
		
    ;Configuración de puertos
INICIO:
    clrf PORTB         ;Limpia PORTB	
    clrf PORTD         ;Limpia PORTD
	clrf PORTA
    bsf STATUS, RP0  
    bcf STATUS, RP1    ;Selecciona el banco 1
    clrf TRISB         ;Configura PORTB como salida
    clrf TRISD         ;Configura PORTD como salida
	movlw 06h       ;Configura puertos A y E como digitales
    movwf ADCON1 
    movlw 3fh       ;Configura el Puerto A como entrada
    movwf TRISA
    bcf STATUS,RP0     ;Regresa al banco 0
	call ESCRIBIR

CICLO:
	   movlw c0
       movwf v0
       movfw PORTA     ;Mueve lo que hay en PORTA a W
       xorwf v0,w      ;Verifica si la entrada es $00
       btfsc STATUS,Z  ;z=0?
       goto START_LCD        ;NO, entonces v0=W
                       ;SI, entonves v0!=W
       movlw c1
       movwf v1
       movfw PORTA
       xorwf v1,w      ;Verifica si la entrada es $01
       btfsc STATUS,Z
       goto START_LCD1
       
       movlw c2
       movwf v2
       movfw PORTA
       xorwf v2,w      ;Verifica si la entrada es $02
       btfsc STATUS,Z
       goto START_LCD2

       movlw c3
       movwf v3
       movfw PORTA
       xorwf v3,w      ;Verifica si la entrada es $03
       btfsc STATUS,Z
       goto  START_LCD3
;;;;;;;;;;
START_LCD:		
    call INICIA_LCD    ;Configura el LCD
    call M1            ;Muestra Mensaje  "EDGAR DANIEL"
    call LINEA2        ;Configura linea 2
    call M2            ;Muestra Mensaje  "BARCENAS MARTINEZ"
	call RETARDO
    goto CICLO
START_LCD1:		
    call INICIA_LCD    ;Configura el LCD
    call M3            ;Muestra Mensaje "EDGAR BARCENAS"
    goto CICLO
START_LCD2:		
    call INICIA_LCD    ;Configura el LCD
    call LINEA2        ;Configura linea 2 
    call M4            ;Muestra Mensaje  "EDGAR BARCENAS"
    goto CICLO
START_LCD3:		
    call INICIA_LCD    ;Configura el LCD
    call M5           ;Muestra Mensaje "NAVE"
    goto CICLO

M5:	
	call CENTRO
    movlw   0x00
	movwf   PORTB
    call    ENVIA
	call    RETARDO
	return

ESCRIBIR:
	bcf PORTD,0
    movlw 0x40       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00001110'
    movwf PORTB
	call COMANDO 
	movlw b'00001110'
    movwf PORTB
	call COMANDO 
	movlw b'00011111'
	movwf PORTB
    call COMANDO 
	movlw b'00010001'
	movwf PORTB
    call COMANDO 
	movlw b'00010001'
	movwf PORTB
    call COMANDO  
	movlw b'00010001'
	movwf PORTB
    call COMANDO 
	return

;Mensaje a enviar
M3: 
    ;Edgar 
    movlw 'E'          ;Mueve 'E' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'D'          ;Mueve 'D' a W
    movwf PORTB        ;Mueve loque hay en W a PORTB
    call ENVIA 
	movlw 'G'          ;Mueve 'G' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'A'          ;Mueve 'A' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA
	movlw 'R'          ;Mueve 'R' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw ' '          ;Mueve ' ' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA  
     
    movlw 'B'          ;Mueve 'B' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'A'          ;Mueve 'A' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	movlw 'R'          ;Mueve 'R' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'C'          ;Mueve 'C' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA
	movlw 'E'          ;Mueve 'E' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'N'          ;Mueve 'N' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	movlw 'A'          ;Mueve 'A' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'S'          ;Mueve 'S' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 

	bcf PORTD,0			;DEZPLAZAMIENTO a la derecha
	movlw 0x1C     	
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO 
	movlw 0x1C     
    movwf PORTB
    call COMANDO 
	movlw 0x1C     
    movwf PORTB
    call COMANDO  
	bsf PORTD,0
    return

M4:
	;DEZPLAZAMIENTO a la izquierda. Aqui solo recorro 16 veces.
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
 	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
  	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C     
    movwf PORTB
    call COMANDO
	movlw 0x1C      
    movwf PORTB
    call COMANDO
  	movlw 0x1C     
    movwf PORTB
    call COMANDO
   	movlw 0x1C     
    movwf PORTB
    call COMANDO
    movlw 0x1C     
    movwf PORTB
    call COMANDO

    movlw 'E'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'D'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	movlw 'G'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'A'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA
	movlw 'R'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
    movlw ' '          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA  
     
    movlw 'B'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'A'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	movlw 'R'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'C'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA
	movlw 'E'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'N'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	movlw 'A'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
     movlw 'S'          ;Mueve 'H' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA 
	
	;DEZPLAZAMIENTO a la derecha.Corrimiento.
	bcf PORTD,0
    movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO 
	movlw 0x18     
    movwf PORTB
    call COMANDO 
	movlw 0x18     
    movwf PORTB
    call COMANDO   
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO
	movlw 0x18     
    movwf PORTB
    call COMANDO 
	movlw 0x18     
    movwf PORTB
    call COMANDO 
	movlw 0x18     
    movwf PORTB
    call COMANDO  
	bsf PORTD,0
    return


M7:
    movlw 'V'          ;Mueve 'V' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA         ;Imprime en LCD
    movlw 'A'
    movwf PORTB
    call ENVIA
    movlw 'L'
    movwf PORTB
    call ENVIA
    movlw 'E'
    movwf PORTB
    call ENVIA
    movlw 'R'
    movwf PORTB
    call ENVIA
    movlw 'I'
    movwf PORTB
    call ENVIA
	movlw 'A'
    movwf PORTB
    call ENVIA
    return

M1:
    movlw 'E'          ;Mueve 'E' a W
    movwf PORTB        ;Mueve lo que hay en W a PORTB
    call ENVIA         ;Imprime en LCD
    movlw 'D'
    movwf PORTB
    call ENVIA
    movlw 'G'
    movwf PORTB
    call ENVIA
    movlw 'A'
    movwf PORTB
    call ENVIA
    movlw 'R'
    movwf PORTB
    call ENVIA
    movlw ' '
    movwf PORTB
    call ENVIA
	movlw 'D'
    movwf PORTB
    call ENVIA
	movlw 'A'
    movwf PORTB
    call ENVIA
    movlw 'N'
    movwf PORTB
    call ENVIA
	movlw 'I'
    movwf PORTB
    call ENVIA
	movlw 'E'
    movwf PORTB
    call ENVIA
    movlw 'L'
    movwf PORTB
    call ENVIA
    return      
M2:
    movlw 'B'         ;Mueve 'I' a W
    movwf PORTB       ;Mueve lo que hay en W a PORTB
    call ENVIA        ;Imprime en LCD
    movlw 'A'
    movwf PORTB
    call ENVIA
    movlw 'R'
    movwf PORTB
    call ENVIA
    movlw 'C'
    movwf PORTB
    call ENVIA
    movlw 'E'
    movwf PORTB
    call ENVIA
    movlw 'N'
    movwf PORTB
    call ENVIA
    movlw 'A'
    movwf PORTB
    call ENVIA
	movlw 'S'
    movwf PORTB
    call ENVIA
    movlw ' '
    movwf PORTB
    call ENVIA
    movlw 'M'
    movwf PORTB
    call ENVIA
    movlw 'A'
    movwf PORTB
    call ENVIA
    movlw 'R'
    movwf PORTB
    call ENVIA
    movlw 'T'
    movwf PORTB
    call ENVIA
	movlw 'I'
    movwf PORTB
    call ENVIA
    movlw 'N'
    movwf PORTB
    call ENVIA
    movlw 'E'
    movwf PORTB
    call ENVIA
	movlw 'Z'
    movwf PORTB
    call ENVIA
    return   
	
    ;Subrutina para inicializar el lcd
INICIA_LCD:
    bcf PORTD,0      ; RS=0 MODO INSTRUCCION
    movlw 0x01       ; El comando 0x01 limpia la pantalla en el LCD
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
    movlw 0x0C       ; Selecciona la primera línea
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
    movlw 0x3C       ; Se configura el cursor
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
    bsf PORTD, 0     ; Rs=1 MODO DATO
    return

    ;Subrutina para enviar comandos
COMANDO:
    bsf PORTD,1     ; Pone ENABLE en 1
    call DELAY      ; Tiempo de espera
    call DELAY
    bcf PORTD, 1    ; ENABLE=0	
    call DELAY
    return     

    ;Subrutina para enviar un dato
ENVIA:
    bsf PORTD,0     ; RS=1 MODO DATO
    call COMANDO    ; Se da de alta el comando
    return
    ;Configuración Líneal 2 LCD
LINEA2:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
    movlw 0xc0      ; Selecciona línea 2 en el LCD
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

CENTRO:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
    movlw 0xc7      ; Selecciona línea 2 en el LCD
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

RETARDO:
     movlw cte1    
     movwf valor1
tres movwf cte2
     movwf valor2
dos  movlw cte3
     movwf valor3
uno  decfsz valor3 
     goto uno 
     decfsz valor2
     goto dos
     decfsz valor1   
     goto tres
     return

    ; Subrutina de retardo
DELAY:        	
    movlw 0xFF
    movwf val2 
ciclo:
    movlw 0xFF
    movwf val1
ciclo2:
    decfsz val1,1
    goto ciclo2
    decfsz val2,1
    goto ciclo
    return
 END