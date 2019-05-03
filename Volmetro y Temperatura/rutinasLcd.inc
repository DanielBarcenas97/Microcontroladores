LCD_INIT:
	BCF RS
	CALL RETARDO_5MS
	MOVLW 01H						;LIMPIA EL DISPLAY
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

	BCF RS
	CALL RETARDO_5MS
	MOVLW 0CH						;AJUSTA EL FUNCIONAMIENTO
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

	BCF RS
	CALL RETARDO_5MS
	MOVLW 3CH						;HABILITA EL DISPLAY
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

	BCF RS
	CALL RETARDO_5MS
	MOVLW B'00001100'				;AJUSTA EL MODO DE ENTRADA
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	
	RETURN
;///////////////////////////////////////////////////////////////////////
LCD_E:
	BSF ENABLE
	NOP
	NOP
	NOP
	NOP
	NOP
	BCF ENABLE
	RETURN

;//////////////////////////////////////////////////////////////////
RETARDO_5MS:					;SUBRUTINA DE RETARDO
	movlw .2
	movwf valor1
tres 
	movlw .200
	movwf valor2
dos movlw .82
	movwf valor3
uno decfsz valor3
	goto uno
	decfsz valor2
	goto dos
	decfsz valor1
	goto tres
	return

;----------------------------------------------------------
RETARDO					;SUBRUTINAS DE RETARDO
	movlw 0X60
	movwf valor1
tres2 
	movlw 0X50
	movwf valor2
dos2 movlw 0X80
	movwf valor3
uno2 decfsz valor3
	goto uno2
	decfsz valor2
	goto dos2
	decfsz valor1
	goto tres2
	return
;/////////////////////////////////////////////////////////////////////


MUESTRA_TEMP

	BCF RS
	MOVLW B'00000001'
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL LINEA1						;imprime en el lcd el texto
	RETURN
;///////////////////////////////////////////////////////////////////

MUESTRA_VOLT

	BCF RS
	MOVLW B'00000001'
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL LINEAVOLT					;imprime en el lcd el texto
	RETURN

;//////////////////////////////////////////////////////////////////////////

LINEA1:
	BCF RS							;limpia display
	MOVLW B'00000010'
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL RETARDO_5MS
 
	MOVLW 'T' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'e' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'm' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'p' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS


	MOVLW b'00111010' 				; Print character ":"
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS


	MOVF valDece,W 					;temperatura parte de las decenas
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

	MOVF valUni,W 					;temperatura parte de las unidades
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS


	MOVLW b'11011111' 				; Print character "°"
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'C' 						; Print character "C" para centigrados
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character "°"
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character "°"
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	CALL ELIJE_FIGURA_TEMP			;imprime la figura para la temperatura dependiendo del valor

	MOVLW ' ' 						; Print character "°"
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	BCF RS
	MOVLW 0xC0						;salto de linea
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL RETARDO_5MS

	MOVLW 'H' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW 'E' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW 'X' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW ':' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
;------------------------------PARA VER EL VALOR SI ES NUMERO O LETRA-----------

	movf valHexHigh,W				;compara si es letra o numero
	sublw 0x9
	BTFSC STATUS,C
	GOTO menorHigh					;si fue letra salta a menorHigh

	movf valHexHigh,W				;valor parte alta del resultado en hex, si fue letra
	addlw 0x37
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

contImprimiendo						;ahora con la parte baja, compara si es numero o letra
	movf valHexLow,W
	sublw 0x9
	BTFSC STATUS,C
	GOTO menorLow					;si fue numero salta a menorLow

	movf valHexLow,W				;si fue letra
	addlw 0x37
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
continua							;para regresar al main
	RETURN

menorHigh
	movf valHexHigh,W				;valor parte alta del resultado en hex, si fue numero
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	goto contImprimiendo	
menorLow							;valor parte baja del resultado en hex, si fue numero
	movf valHexLow,W
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	goto continua





;/////////////////////////////////////////////////////////////////

LINEAVOLT
	BCF RS
	MOVLW B'00000010'				;limpia display
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL RETARDO_5MS
 
	MOVLW 'V' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'o' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'l' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS


	MOVLW ':' 						; Print character ""
 	MOVWF PORTB			
 	CALL LCD_E
 	CALL RETARDO_5MS


	MOVF valCent,W 					;temperatura en volts
	addlw 0x30
	MOVWF PORTB
 	CALL LCD_E
	CALL RETARDO_5MS
	
	MOVLW '.' 						; Print character ""
 	MOVWF PORTB		
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVF valDece,W 					;temperatura, parte decimal
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

	MOVF valUni,W 					;temperatura, parte decimal
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS


	MOVLW '[' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW 'V' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ']' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

;-------------------------------IMPRIME PARTE SUPERIOR DE LA PILA-----------------------------------
	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS


	CALL ELIJE_FIGURA_VOLMETRO_ALTA	
;----------------------------------------------------------------------------

	BCF RS			
	MOVLW 0xC0						;SALTO DE LINEA
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	BSF RS
	CALL RETARDO_5MS

	MOVLW 'H' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW 'E' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW 'X' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW ':' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

;------------------------valor voltaje en hexa de la entrada, NO del equivalente a decimal
	movf valHexHigh,W				
	sublw 0x9
	BTFSC STATUS,C
	GOTO menorHighVOL				;si la parte alta fue numero salta a menorHighVOL

	movf valHexHigh,W				;si la parte alta fue letra
	addlw 0x37
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS

contImprimiendoVOL					;continua con la parte baja
	movf valHexLow,W
	sublw 0x9
	BTFSC STATUS,C
	GOTO menorLowVOL				;si fue numero salta a menorLowVOL

	movf valHexLow,W				;si fue letra
	addlw 0x37
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	GOTO continuaVOL

menorHighVOL						;si fue numero la parte alta
	movf valHexHigh,W
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	goto contImprimiendoVOL			;regresa para comparar la parte baja

menorLowVOL							;si la parte baja fue numero
	movf valHexLow,W
	addlw 0x30
	MOVWF PORTB
	CALL LCD_E
	CALL RETARDO_5MS
	goto continuaVOL				;acabó con la parte baja, finaliza regresando 


;-----------------CONTINUA IMPRIMIENDO PARTE BAJA DE LA PILA-------------------------------
continuaVOL
	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS
	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	MOVLW ' ' 						; Print character ""
 	MOVWF PORTB
 	CALL LCD_E
 	CALL RETARDO_5MS

	CALL ELIJE_FIGURA_VOLMETRO_BAJO		;para imprimir la parte baja de la pila

	RETURN
;///////////////////////////////////////////////////////////////////
