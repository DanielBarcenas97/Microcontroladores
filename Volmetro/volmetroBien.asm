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
	;Vector de inicio
		org 0
		goto inicio
		org 5

inicio:
		;configurar puertos
        CLRF PORTA
		CLRF PORTB
 		BSF STATUS,RP0 	;Cambiar al banco 1
 		BCF STATUS,RP1
  		MOVLW h'0E' 	;Configura puertos A y E como analogicos
		MOVWF ADCON1 		
 		MOVLW 3FH 		;Configura el puerto A como entrada
 		MOVWF TRISA
		clrf TRISB		;configurar puertos B y D como salida
		clrf TRISD
		BCF STATUS,RP0	;regresar al banco 0	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Mostrar nombre1
		bcf PORTA,1
		call lcd_in
		call nameA
		call next
		call nameB
carlos:
		btfss PORTA,1
		goto carlos
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Mostrar nombre 2
		bcf PORTA,1
		call pausa
		call pausa
		call pausa
		call lcd_in
		call name1
		call next
		call name2
fer:
		btfss PORTA,1
		goto fer
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>muestro de entrada analógica
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

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>obtener el valor del voltaje
ceros:
		;en ceros el resultado
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

;>>>
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

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Imprimir en LCD voltaje
mostrar:
lcd_inicio:
		call lcd_in
		call txt1
		call next
		call txt2
		goto muestreo

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
		goto menorA2		;menor a A	
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
		decfsz aux,1
		goto addspace
		
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

		movlw ' '
		movwf PORTB
		call send
		movlw ' '
		movwf PORTB
		call send
		movlw ' '
		movwf PORTB
		call send
		movlw ' '
		movwf PORTB
		call send
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

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>nombre
name1:
		movlw 'G'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send
				
		movlw 'n'
		movwf PORTB
		call send

		movlw 'z'
		movwf PORTB
		call send

		movlw 'a'
		movwf PORTB
		call send
				
		movlw 'l'
		movwf PORTB
		call send		
	
		movlw 'e'
		movwf PORTB
		call send

		movlw 'z'
		movwf PORTB
		call send
				
		movlw ' '
		movwf PORTB
		call send

		movlw 'C'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send
				
		movlw 'l'
		movwf PORTB
		call send

		movlw 'i'
		movwf PORTB
		call send

		movlw 'n'
		movwf PORTB
		call send

		return

name2:	
		movlw 'F'
		movwf PORTB
		call send

		movlw 'e'
		movwf PORTB
		call send

		movlw 'r'
		movwf PORTB
		call send

		movlw 'n'
		movwf PORTB
		call send

		movlw 'a'
		movwf PORTB
		call send
		
		movlw 'n'
		movwf PORTB
		call send

		movlw 'd'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send
		return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Nombre 2
nameA:
		movlw 'G'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send
				
		movlw 'd'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send

		movlw 'y'
		movwf PORTB
		call send
				
		movlw ' '
		movwf PORTB
		call send		
	
		movlw 'J'
		movwf PORTB
		call send

		movlw 'u'
		movwf PORTB
		call send
				
		movlw 'a'
		movwf PORTB
		call send

		movlw 'r'
		movwf PORTB
		call send

		movlw 'e'
		movwf PORTB
		call send
				
		movlw 'z'
		movwf PORTB
		call send

		return

nameB:	
		movlw 'C'
		movwf PORTB
		call send

		movlw 'a'
		movwf PORTB
		call send

		movlw 'r'
		movwf PORTB
		call send

		movlw 'l'
		movwf PORTB
		call send

		movlw 'o'
		movwf PORTB
		call send
		
		movlw 's'
		movwf PORTB
		call send

		movlw ' '
		movwf PORTB
		call send

		movlw 'E'
		movwf PORTB
		call send

		movlw '.'
		movwf PORTB
		call send

		return
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> configuración LCD

lcd_in:
		bcf PORTD,6		;RS=0
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
		bsf PORTD,7		;enable = 1
		call delay
		call delay		
		bcf PORTD,7		;enable = 0
		call delay
		return

send:
		bsf PORTD,6		;RS = 1
		call ejecutar
		return

next:
		bcf PORTD,6		;RS = 0
		movlw h'C0'		;cursor en segunda linea
		movwf PORTB
		call ejecutar
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
		nop
		nop
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

fin:
		end
