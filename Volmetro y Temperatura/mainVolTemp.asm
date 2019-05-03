PROCESSOR PIC16F877A
#INCLUDE <P16F877A.INC>


#DEFINE RS		PORTD,0
#DEFINE RW		PORTD,1
#DEFINE ENABLE	PORTD,2
;//////////////////////////variables///////////////////////////////
valor1 EQU H'21'		;
valor2 EQU H'22'		;
valor3 EQU H'23'		;
;---------------------------------------------------------------
guarda equ h'24'		;registro que almacena el dato de entradA
;--------------------------------------------------------------
temp equ h'25'			;
temp2 equ h'26'			;
;---------------------------------------------------------------
valCent equ h'27'		;
valDece	equ h'28'		;
valUni	equ h'29'		;
valDeci	equ h'2A'		;
;--------------------------------------------------------------------
valHexHigh equ h'2B'	;
valHexLow equ h'2C'		;
;-----------------------------------------------------------------
val64hex equ h'2D'		;
voltaje_h equ h'2E'
voltaje equ h'2F'
;---------------------------------------------------------------------
result_high equ h'30'		;variables usadas al multiplicar y dividir
result_low equ h'31'
resDiv_high equ h'32'
resDiv_low 	equ h'34'



CONTADOR EQU 25H

	ORG 0
	GOTO INICIO
	ORG 5
INICIO

	CLRF PORTA			;limpia puertos
	CLRF PORTB
	CLRF PORTE			;
	BSF STATUS,RP0 		;Cambia la banco 1
	BCF STATUS,RP1
	MOVLW 02H			;entradas analogicas en A, digitales en E
 	MOVWF ADCON1
	CLRF TRISB			;puerto B como salida
	CLRF TRISD			;PORTD como salida para LCD
	movlw 0x03			
	movwf TRISE			;Puerto E como entrada digital
 	BCF STATUS,RP0 		;Regresa al banco cero
;	MOVLW B'11000001'	;canal 000 de analógica
;	MOVWF ADCON0
	BCF RS
	BCF RW
	BCF ENABLE
	CLRF CONTADOR
	CALL LCD_INIT
	

SWITCH
	MOVF PORTE,W
	ANDLW 0X01
	ADDWF PCL,1
	GOTO TEMPERATURA
	GOTO VOLMETRO
	
	GOTO SWITCH


TEMPERATURA
	CALL LOADCARACTERTEMPERATURA
	MOVLW B'11000001'	;canal 000 de analógica
	MOVWF ADCON0
	
	CALL LEEDATO
	CALL CENT_DEC_UNI
	CALL A_HEXA
	CALL MUESTRA_TEMP
	CALL RETARDO
	GOTO SWITCH

VOLMETRO
	CALL LOADCARACTERVOLMETRO
	MOVLW B'11001001'	;canal 001 de analógica
	MOVWF ADCON0
	CALL LEEDATO
	CALL CONVIERTE_A_VOLTAJE
	CALL CENT_DEC_UNI_VOL
	CALL A_HEXA
	CALL MUESTRA_VOLT
	CALL RETARDO
	GOTO SWITCH

#INCLUDE "rutinasConvertidor.inc"
#INCLUDE "rutinasLcd.inc"
#include "caracterPer.inc"
END