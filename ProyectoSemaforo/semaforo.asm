processor 16f877      ;Tipo de Procesador utilizar
include <p16f877.inc> ;Libreria

;Definición de variables en memoria
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h 
cte2 equ h'05'
cte3 equ h'ff'
cte4 equ 10h          

   org 0               ;Vector de RESET, origen de programa
   goto inicio 
   org 5
   
inicio bsf STATUS, 5   ;Hace cambio al Banco 1
       bcf STATUS, 6   
       movlw h'0'       
       movwf TRISB     ;Configura el puerto B como salida
       bcf STATUS,5    ;Cambio al Banco 0
       clrf PORTB      ;Limpia los bits del PUERTO B

loop2  bsf PORTB,0     ;Prende el bit 0 del PUERTO B
	   bsf PORTB,5     ;Prende el bit 5 del PUERTO B
       call retardo    ;Llamada a rutina, genera un Delay
       bcf PORTB, 0    ;Apaga el bit 0 del PUERTO B
       bcf PORTB, 5    ;Apaga el bit 5 del PUERTO B


	   bsf PORTB,5     ;Prende el bit 5 del PUERTO B 
	   bsf PORTB,1     ;Prende el bit 1 del PUERTO B
	   call retardo2
	   bcf PORTB, 1    ;Apaga el bit 1 del PUERTO B
       bcf PORTB, 5    ;Apaga el bit 5 del PUERTO B


	   bsf PORTB,3     ;Prende el bit 3 del PUERTO B
	   bsf PORTB,2     ;Prende el bit 2 del PUERTO B
	   call retardo    ;Llamada a rutina, genera un Delay
       bcf PORTB, 3    ;Apaga el bit 3 del PUERTO B
       bcf PORTB, 5    ;Apaga el bit 5 del PUERTO B


       bsf PORTB,2     ;Prende el bit 2 del PUERTO B    
	   bsf PORTB,4     ;Prende el bit 4 del PUERTO B
	   call retardo2
	   bcf PORTB, 4    ;Apaga el bit 4 del PUERTO B
       bcf PORTB, 2    ;Apaga el bit 2 del PUERTO B

	  

       goto loop2 





	
retardo 
     movlw cte1        ;Rutina que genera un DELAY de un segundo
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

retardo2 
      movlw cte4        ;Rutina que genera un DELAY de 1/2 segundo
      movwf valor1
tres2 movwf cte2
      movwf valor2
dos2  movlw cte3
      movwf valor3
uno2  decfsz valor3 
      goto uno2 
      decfsz valor2
      goto dos2
      decfsz valor1   
      goto tres2
      return
      end 