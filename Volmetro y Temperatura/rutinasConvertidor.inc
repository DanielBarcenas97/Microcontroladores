;//////RUTINAS RELACIONADAS AL CONVERTIDOR ANALOGICO DIGITAL//////////////////////////////////

LEEDATO							;RUTINA QUE RECIBE EL DATO DE ENTRADA DEL CONVERTIDOR
	BSF ADCON0,2				;inicia la conversion leyendo la entrada
	CALL RETARDO20uS

ESPERA							;espera a que acabe de convertir la entrada
	BTFSC ADCON0,2
	GOTO ESPERA
	
	MOVF ADRESH,W				;lo que arroja como dato lo guarda a W
	MOVWF guarda				;para moverlo al puerto B como salida
RETURN

;/////////////////////////////////////////////////////////////////////////
CENT_DEC_UNI					;RUTINA USADA EN LA TEMPERATURA
								;PARA CONVERTIR HEX A DECIMAL

	CLRF valCent				;limpia registros
	clrf valDece
	clrf valUni
	bcf STATUS,C				;limpia carry
	movf guarda,W				;el resultado de la conversion la guarda en temp
	movwf temp

resta_centenas					
	movf temp,W					;temp2 <- temp , para guardar el valor anterior
	movwf temp2	
	movlw 0x64	
	subwf temp,F				;le resta 64h 
	BTFSC STATUS,C				;checa si fue negativa la resta
	goto inc_centenas			;si no, se va a esta rutina
	movf temp2,W				;si sí, regresa el valor anterior a temp
	movwf temp					

resta_decenas					;ahora con el valor de decenas
	movf temp,W					;guarda el valor (anterior) en temp2
	movwf temp2
	movlw 0xA					;resta
	subwf temp,F				;
	BTFSC STATUS,C				;checa si fue negativa la resta
	goto inc_decenas			;si no, va a inc_decenas
	movf temp2,W				;si sí, regresa el valor anterior a temp
	movwf temp

resta_unidades					;ahora con las unidades
	movf temp,W
	movwf temp2
	movlw 01					;resta 1
	subwf temp,F
	BTFSC STATUS,C				;checa si fue negativa la resta
	goto inc_unidades			;si no, se va a inc_unidades
	RETURN						;si sí, acaba la conversion y retorna


inc_centenas					;ya que la resta no fue negativa, incrementa registro de centenas
	incf valCent
	goto resta_centenas			;regresa a seguir restando

inc_decenas						
	incf valDece				;como la resta no fue negativa, incrementa
	goto resta_decenas			;y regresa

inc_unidades	
	incf valUni					;como la resta no fue negativa, incrementa
	goto resta_unidades			;y regresa



;-----------------------------------------------------------------
CENT_DEC_UNI_VOL				;rutina similar a la anterior pero esta considera una entrada de mas de 8 bits
								;por la conversion anterior (multiplicacion y division)
	CLRF valCent
	clrf valDece
	clrf valUni
	bcf STATUS,C
	movf resDiv_low,W			;mueve la parte baja del resultado
	movwf temp					;a temp

resta_centenasV
	movf temp,W
	movwf temp2					;temp2 <- temp , para guardar el valor anterior
	movlw 0x64	
	subwf temp,F				;le resta 64h 
	BTFSC STATUS,C				;checa si la resta fue negativa
	goto resta_highV			;si no
	goto inc_centenasV			;no
	movf temp2,W
	movwf temp

resta_decenasV
	movf temp,W
	movwf temp2
	movlw 0xA
	subwf temp,F
	BTFSC STATUS,C
	goto inc_decenasV
	movf temp2,W
	movwf temp

resta_unidadesV
	movf temp,W
	movwf temp2
	movlw 01
	subwf temp,F
	BTFSC STATUS,C
	goto inc_unidadesV
	RETURN


inc_centenasV
	incf valCent
	goto resta_centenasV

inc_decenasV
	incf valDece
	goto resta_decenasV

inc_unidadesV
	incf valUni
	goto resta_unidadesV

;-----------------------------
resta_highV
	movf resDiv_high
	btfss STATUS,Z
	goto resta_highCentenaV
	movf temp2,W
	movwf temp
	goto resta_decenasV

resta_highCentenaV
	decf resDiv_high
	incf valCent
	goto resta_centenasV	

;//////////////////////////////////////////////////////////////////////////
A_HEXA								;RUTINA QUE SEPARA LA PARTE ALTA Y BAJA DEL RESULTADO
									;HEX PARA SU IMPRESION POSTERIOR EN EL LCD
	movf guarda,W
	andlw h'F0'
	movwf valHexHigh
	swapf valHexHigh

	movf guarda,W
	andlw h'0F'
	movwf valHexLow
	
	RETURN

;//////////////////////////////////////////////////////////////////////////

RETARDO20uS				;SUBRUTINA DE RETARDO DE 20 uS
	MOVLW .48
	MOVWF valor1
uno20u	
	DECFSZ valor1
	GOTO uno20u
	RETURN

;//////////////////////////////////////////////////////////////////////////



CONVIERTE_A_VOLTAJE
							;salida=entrada*500/255 = entrada*100/51		decimal
							;salida=entrada*1F4/FF	= entrada*64*33		hexa
	clrf result_high		;result_high=resultado de la * parte alta
	clrf result_low				;result_low=resultado de la * parte baja
	movlw 0x64
	movwf val64hex			;val64hex para el conteo de la suma
	
multiplica 
	movf result_low,W		;w <- result_low
	addwf guarda,W			;w <- w + guarda
	movwf result_low		;temp2 <- w
	btfsc STATUS,C			;se desbordó?
	incf result_high		;si
	bcf STATUS,C			;no	
	decfsz val64hex,1		;val64hex <- val64hex - 1
	goto multiplica			;no es cero 

divide						;si es cero, salta
	movlw 0x33
	subwf result_low,F		;temp2 <- temp2-33h
	btfss STATUS,C			;la resta fue negativa?
	decf result_high		;si
	bcf STATUS,C			;NO, C=0
	goto incrementaDiv		;y despues salta
sigue
	movf result_high,w		;w <- temp
	btfss STATUS,Z			;la parte alta es cero? (temp == 0 ?)
	goto divide				;no
	bcf STATUS,C			;si

divideLow					;ya que la parte alta es cero, continua con la parte baja
	movlw 0x33
	subwf result_low,F		;temp2 <- temp2-33h
	btfss STATUS,C			;la resta fue negativa?
	RETURN					;si => acabó de dividir y da el resultado en voltaje
	incf resDiv_low			;no, incrementa y
	goto divideLow			;vuelve a restar



incrementaDiv
	incf resDiv_low			;incrementa
	btfss STATUS,Z			;si la suma fue cero, es decir FF+1=00
	goto sigue				;no, regresa
	incf resDiv_high		;si, incrementa la parte alta del resultado
	goto sigue				;y regresa