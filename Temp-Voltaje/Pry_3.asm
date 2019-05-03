processor 16f877
include <p16f877.inc>	
varB: 	equ h'20'
res0: 	equ h'21'
res1: 	equ h'22'
valor1:	equ h'23'
;variables para uso del LCD	
	N 	equ h'24'
	M 	equ h'25'
	Nx	equ h'26'
	Mx	equ h'27'
	p	equ h'28'
   aux: equ h'29'
;variables para valor decimal
dec0:	equ h'30'
dec1:	equ h'31'
;variable para el valor hexa
hex0: 	equ h'32'
;Variables para separar el resultado
Unidades equ 0x33     
Decenas equ 0x34 	
Centenas equ 0x35   
Resto equ 0x36
;Definicion de variables a utilizar para COMPARAR
v0 equ h'37'  
v1 equ h'38'
v2 equ h'39'
c0 equ 40h 
c1 equ 41h
c2 equ 42h
;Variable para el DELAY d
val equ h'43'
;Variables para el DELAY del ENABLE LCD
val2 equ 0x44
val1 equ 0x45
;>>>>>>>>>>>>Vector de inicio<<<<<<<<<<<<<<<<<
	org 0
	goto inicio
	org 5
;>>>>>>>>>>>>CONFIGURACION PUERTOS <<<<<<<<<<<<<<<
inicio:
    CLRF PORTA
	CLRF PORTB
	CLRF PORTC
	CLRF PORTD
 	BSF STATUS,RP0 	;Cambiar al banco 1
 	BCF STATUS,RP1
  	MOVLW h'0E' 	;Configura puertos A y E como analogicos
	MOVWF ADCON1 		
 	MOVLW 3FH 		;Configura el puerto A como entrada
 	MOVWF TRISA
	CLRF TRISB		;configurar puertos B y D como salida
	CLRF TRISD
	MOVLW 0x01		;CONFIGURA PUERTO C COMO ENTRADA
    MOVWF TRISC
	BCF STATUS,RP0	;regresar al banco 0	
;>>>>>>>>>>>>>>>>>>>>>>>INICIO PROGRAMA <<<<<<<<<<<<<<<<<<<<<<<<
CICLO:
 	call ESCRIBIR
    call ESCRIBIR2
    call ESCRIBIR3
    call ESCRIBIR4
	call ESCRIBIR5
	call ESCRIBIR6
	call ESCRIBIR7
	call ESCRIBIR8
	
	BTFSS PORTC,0
    goto START_LCD  ;volmetro
    goto START_LCD1	;termo

START_LCD:		;Volmetro
	call lcd_in    ;Configura el LCD
	call muestreo  ;VOLMETRO
	call pausa
    goto CICLO

START_LCD1:		;Termometro
    call lcd_in    ;Configura el LCD
	call temp         ;TEMP
	call pausa
    goto CICLO
M4:	
	call CENTRO
    movlw 0x00
	movwf PORTB
    call  ENVIA
	call  retardo
	return
M5:	
	call CENTRO1
    movlw   0x01
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M6:	
	call CENTRO1A
    movlw   0x02
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M7:	
	call CENTRO2A
    movlw   0x03
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M8:	
	call CENTRO
    movlw   0x04
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M9:	
	call CENTRO1
    movlw   0x05
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M10:	
	call CENTRO1A
    movlw   0x06
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
M11:	
	call CENTRO2A
    movlw   0x07
	movwf   PORTB
    call    ENVIA
	call    retardo
	return
;>>>>>>>>>>>>>>>>>>>muestreo de entrada analógica<<<<<<<<<<<<<<
muestreo:
		MOVLW b'11000101' ; Configurar frecuencia de muestreo
		MOVWF ADCON0
		CALL retardo
loop:	BTFSC ADCON0,2
		GOTO loop
		MOVF ADRESH,0
		MOVWF varB		;mover el resultado de la conversión a varB
		MOVWF hex0		;mover el resultado de la conversión a hex0
		GOTO ceros		;ir a ceros para obtener el valor del voltajes

retardo:	
		movlw h'30'
		movwf valor1
l1:    	decfsz valor1
		goto l1
		return
;>>>>>>>>>>>>>>>>>>>obtener el valor del voltaje
ceros:
		movlw h'00'
		movwf res0
		movwf res1
		movwf dec0
		movwf dec1
sumas:	
		btfsc varB,0
		goto bit0
		btfsc varB,1
		goto bit1
		btfsc varB,2
		goto bit2
		btfsc varB,3
		goto bit3
		btfsc varB,4
		goto bit4
		btfsc varB,5
		goto bit5
		btfsc varB,6
		goto bit6
		btfsc varB,7
		goto bit7
		goto mostrar

bit0:	;sumar 0.02; 001
	movf res1,0
	addlw h'02'
	movwf res1

	movf dec1,0
	addlw h'01'
	movwf dec1	

	call fix
	call fixD
	bcf varB,0
	goto sumas

bit1:	;sumar 0.04; 002
	movf res1,0
	addlw h'04'
	movwf res1

	movf dec1,0
	addlw h'02'
	movwf dec1

	call fix
	call fixD
	bcf varB,1
	goto sumas

bit2:	;sumar 0.08; 004
	movf res1,0
	addlw h'08'
	movwf res1

	movf dec1,0
	addlw h'04'
	movwf dec1

	call fix
	call fixD
	bcf varB,2
	goto sumas

bit3:	;sumar 0.16; 008
	movf res1,0
	addlw h'16'
	movwf res1

	movf dec1,0
	addlw h'08'
	movwf dec1

	call fix
	call fixD
	bcf varB,3
	goto sumas

bit4:	;sumar 0.32; 016
	movf res1,0
	addlw h'32'
	movwf res1

	movf dec1,0
	addlw h'16'
	movwf dec1

	call fix
	call fixD
	bcf varB,4
	goto sumas

bit5:	;sumar 0.63; 032
	movf res1,0
	addlw h'63'
	movwf res1

	movf dec1,0
	addlw h'32'
	movwf dec1

	call fix
	call fixD
	bcf varB,5
	goto sumas
bit6:	;sumar 1.25; 064
	movf res1,0
	addlw h'25'
	movwf res1
	movf res0,0
	addlw h'01'
	movwf res0

	movf dec1,0
	addlw h'64'
	movwf dec1

	call fix
	call fixD
	bcf varB,6
	goto sumas

bit7:	;sumar 2.50; 128
	movf res1,0
	addlw h'50'
	movwf res1
	movf res0,0
	addlw h'02'
	movwf res0

	movf dec1,0
	addlw h'28'
	movwf dec1
	movf dec0,0
	addlw h'01'
	movwf dec0

	call fix
	call fixD
	bcf varB,7
	goto sumas 		;mostrar resultado en pantalla LCD

fix:
	bcf STATUS,C
	movlw b'00001111'
	andwf res1,0
	sublw b'00001001'
	btfss STATUS,C
	goto add10
compdec:
	movlw b'11110000'
	andwf res1,0
	sublw b'10010000'
	btfss STATUS,C
	goto add100
	goto regresar
add10:
	movlw b'00001010'
	subwf res1,1	
	movlw b'00010000'
	addwf res1,1
	goto compdec
add100:
	movlw b'10100000'
	subwf res1,1	
	movlw b'00000001'
	addwf res0,1
regresar:
	return
fixD:
	bcf STATUS,C
	movlw b'00001111'
	andwf dec1,0
	sublw b'00001001'
	btfss STATUS,C
	goto add10D
compdecD:
	movlw b'11110000'
	andwf dec1,0
	sublw b'10010000'
	btfss STATUS,C
	goto add100D
	goto regresar
add10D:
	movlw b'00001010'
	subwf dec1,1	
	movlw b'00010000'
	addwf dec1,1
	goto compdecD
add100D:
	movlw b'10100000'
	subwf dec1,1	
	movlw b'00000001'
	addwf dec0,1
regresarD:
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>IMPRIME VOLTAJE LCD<<<<<<<<<<<<<<<<<<<<<<<<<
mostrar:
lcd_inicio:
		call lcd_in
		call txt1
		call M4
		call M5
		call pausa
		call next
		call txt2
		call M6
		call M7
		call pausa
		goto CICLO
txt1:	
		movlw 'H'
		movwf PORTB
		call send
		movlw b'11110000'
		andwf hex0,0	;xxxx0000
		movwf aux		;
		swapf aux,1		;0000xxxx
		movlw h'0A'
		subwf aux,0	 	; w=aux-h0A
		btfss STATUS,C
		goto menorA		;menor a A
		movlw h'09'
		subwf aux,0		; w=aux-h09
		addlw b'01000000'
		movwf PORTB
		call send
		goto seguir
menorA:
		movf aux,0
		addlw b'00110000'
		movwf PORTB
		call send
seguir:
		movlw b'00001111'
		andwf hex0,0
		movwf aux		
		movlw h'0A'
		subwf aux,0	 	; w=aux-h0A
		btfss STATUS,C
		goto menorA2	;menor a A	
		movlw h'09'
		subwf aux,0		; w=aux-h09
		addlw b'01000000'
		movwf PORTB
		call send
		goto seguir2
menorA2:
		movf aux,0
		addlw b'00110000'
		movwf PORTB
		call send
seguir2:
		movlw D'9'
		movwf aux
addspace:
		movlw ' '
		movwf PORTB
		call send	
		movlw 'D'
		movwf PORTB
		call send
		movlw b'00001111'
		andwf dec0,0
		addlw b'00110000'		
		movwf PORTB
		call send
		movlw b'11110000'
		andwf dec1,0
		movwf aux
		swapf aux,1
		movlw b'00110000'		
		addwf aux,0
		movwf PORTB
		call send
		movlw b'00001111'
		andwf dec1,0
		addlw b'00110000'		
		movwf PORTB
		call send
		return
txt2:
		movlw 'V'
		movwf PORTB
		call send
		movlw '='
		movwf PORTB
		call send
		movlw b'00001111'
		andwf res0,0
		addlw b'00110000'		
		movwf PORTB
		call send
		movlw '.'
		movwf PORTB
		call send
		movlw b'11110000'
		andwf res1,0
		movwf aux
		swapf aux,1
		movlw b'00110000'		
		addwf aux,0
		movwf PORTB
		call send
		movlw b'00001111'
		andwf res1,0
		addlw b'00110000'		
		movwf PORTB
		call send
		movlw 'v'
		movwf PORTB
		call send
		call pausa			
		return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>><<TEMP<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
temp:
	MOVLW b'11001001' ;ConfiguraciÃ³n ADCON0 
	bsf ADCON0,2 
	movwf ADCON0      ;ADCS1=1 ADCS0=1 CHS2=0 CHS1=0 CHS0=1 GO/DONE=0 - ADON=1
    call DELAY1       ;Espera que termine la conversión
	ESPERA: 
		BTFSC ADCON0,2    ;Pregunta por DONE=0?(Terminó conversión)
       	goto ESPERA       ;No, vuelve a preguntar
       	MOVF ADRESH,0     ;Si
		MOVWF PORTB      ;Muestra el resultado en PORTB
	
		movlw 'T'
       	movwf PORTB
       	call send
       	movlw '='
       	movwf PORTB
       	call send

		MOVF ADRESH,0     ;Si
		MOVWF PORTB      ;Muestra el resultado en PORTB
	
		call READ_TEMP  ;valor de la temperatura del resultado del Conv a/D
	    
		movf Centenas,W   ;Imprime el dígito de las centenas
    	movwf PORTB
       	call send
       	movf Decenas,W    ;Imprime el dígito de las decenas
       	movwf PORTB
       	call send
       	movf Unidades,W   ;Imprime el dígito de las unidades
       	movwf PORTB
       	call send
       	movlw ' '
       	movwf PORTB
       	call send
       	movlw h'DF'       ;Imprime el simbolo "°"
       	movwf PORTB
       	call send
       	movlw 'C'
       	movwf PORTB
       	call send
 	   	movlw ' '
       	movwf PORTB
       	call send
 	   	movlw ' '
       	movwf PORTB
       	call send
		;Despliegue de simbolos
		call M8
		call M9
	   	call next
	   	call txt1
		;Despliegue de simbolos
		call M10
		call M11
	   	call pausa
		GOTO CICLO
READ_TEMP:
    clrf Centenas
    clrf Decenas
    clrf Unidades 
    movf ADRESH,W   
    addwf ADRESH,W     ;Dupilca el valor de ADRESH para obtener un valor de temperatura real aprox
    movwf Resto        ;Guarda el valor de ADRESH en Resto  
	    
CENTENAS1
   	movlw d'100'      ;W=d'100'
   	subwf Resto,W     ;Resto - d'100' (W)
    btfss STATUS,C    ;Resto menor que d'100'?
    goto DECENAS1     ;SI
    movwf Resto       ;NO, Salva el resto
    incf Centenas,1   ;Incrementa el contador de centenas BCD
    goto CENTENAS1    ;Realiza otra resta
DECENAS1
    movlw d'10'       ;W=d'10'
    Subwf Resto,W     ;Resto - d'10' (W)
    btfss STATUS,C    ;Resto menor que d'10'?
    goto UNIDADES1    ;Si
    movwf Resto       ;No, Salva el resto
    incf Decenas,1    ;Incrementa el contador de centenas BCD
    goto DECENAS1     ;Realiza otra resta
UNIDADES1
    movf Resto,W      ;El resto son la Unidades BCD
    movwf Unidades  
;Rutina que obtiene el equivalente en ASCII	   
OBTEN_ASCII:
    movlw h'30' 
    iorwf Unidades,f      
    iorwf Decenas,f
    iorwf Centenas,f      
    return
;Rutina que genera un Delay de 20 microSeg aprox para el Conv. A/D
DELAY1:             
    movlw h'30'
    movwf val
Loop decfsz val,1
    goto Loop
    return
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ICONOS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ESCRIBIR:
	bcf PORTD,0
    movlw 0x40       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00000011'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
    movwf PORTB
	call COMANDO 
	movlw b'00000100'
    movwf PORTB
	call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00001000'
	movwf PORTB
    call COMANDO 
	movlw b'00001000'
	movwf PORTB
    call COMANDO  
	movlw b'00001000'
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR2:
	bcf PORTD,0
    movlw 0x48       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00011000'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
    movwf PORTB
	call COMANDO 
	movlw b'00000100'
    movwf PORTB
	call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00000010'
	movwf PORTB
    call COMANDO 
	movlw b'00000010'
	movwf PORTB
    call COMANDO  
	movlw b'00000011' ;error
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR3:
	bcf PORTD,0
    movlw 0x50       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO  
	movlw b'00011111'
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR4:
	bcf PORTD,0
    movlw 0x58       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO  
	movlw b'00011111'
	movwf PORTB
    call COMANDO 
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;


ESCRIBIR5:
	bcf PORTD,0
    movlw 0x60       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00001111'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO  
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR6:
	bcf PORTD,0
    movlw 0x68       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00011110'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO  
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR7:
	bcf PORTD,0
    movlw 0x70       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00010000'
    movwf PORTB
	call COMANDO 
	movlw b'00001000'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00000010'
	movwf PORTB
    call COMANDO  
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	return

ESCRIBIR8:
	bcf PORTD,0
    movlw 0x78       ; CGRAM
    movwf PORTB
    call COMANDO     ; Se da de alta el comando
	bsf PORTD,0
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
	movwf PORTB
    call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000001'
    movwf PORTB
	call COMANDO 
	movlw b'00000010'
	movwf PORTB
    call COMANDO 
	movlw b'00000100'
	movwf PORTB
    call COMANDO 
	movlw b'00001000'
	movwf PORTB
    call COMANDO  
	movlw b'00010000'
	movwf PORTB
    call COMANDO 
	return
;>>>>>>>>>>>>>>>>> configuración LCD<<<<<<<<<<<<<<<<<<<<<<<<<<<
lcd_in:
	bcf PORTD,0		;RS=0
	movlw h'01'		;limpiar pantalla
	movwf PORTB	
	call ejecutar
	movlw h'0C'		;primera linea
	movwf PORTB	
	call ejecutar
	movlw h'3C'		;configurar cursor
	movwf PORTB	
	call ejecutar
	bsf PORTD,0		;RS = 1
	return
ejecutar:
	bsf PORTD,1	;7	;enable = 1
	call delay
	call delay		
	bcf PORTD,1	;7	;enable = 0
	call delay
	return
COMANDO:
	bsf PORTD,1	;7	;enable = 1
	call delay
	call delay		
	bcf PORTD,1	;7	;enable = 0
	call delay
	return
send:
	bsf PORTD,0	 ;6	;RS = 1
	call ejecutar
	return
ENVIA:
    bsf PORTD,0     ; RS=1 MODO DATO
    call COMANDO    ; Se da de alta el comando
    return

next: ;segunda linea
	bcf PORTD,0	;6	;RS = 0
	movlw h'C0'		;cursor en segunda linea
	movwf PORTB
	call ejecutar
	return

ERASE_LCD
	bcf PORTD,0      ; RS=0 MODO INSTRUCCION
    movlw 0x01       ; 0x01 limpia la pantalla en el LCD
    movwf PORTB
    Call COMANDO     ; Se da de alta el comando
    bsf PORTD, 0     ; Rs=1 MODO DATO
   	return
	  
CENTRO:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
	movlw 0x8d
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

CENTRO1:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
	movlw 0x8e
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

CENTRO1A:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
   	movlw 0xcd
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

CENTRO2A:
    bcf PORTD, 0    ; RS=0 MODO INSTRUCCION
	movlw 0xce
    movwf PORTB
    call COMANDO    ; Se da de alta el comando
    return

pausa:
		movlw D'10'
		movwf p
tresP:
		movlw D'10'
		movwf Mx
dosP:
		movlw D'50'
		movwf Nx
unoP
		decfsz Nx,1
		goto unoP
		decfsz M,1
		goto dosP
		decfsz p,1
		goto tresP
		return
delay:
		movlw D'32'
		movwf M
dos:
		movlw D'32'
		movwf N
uno:
		decfsz N,1
		goto uno
		decfsz M,1
		goto dos
		return
		end