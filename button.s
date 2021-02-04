; Name: Zhuochen Wu;
; Student Number: 400271642 Put your student number here for labs
; Lab Section: L07
; Description of Code: This code allows User LED D3 To Turn On (Put a brief description of your code) 
; Last Modified: Feb 3nd 2021
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ADDRESS SETUP
;Define your I/O Port Addresses Here

SYSCTL_RCGCGPIO_R             EQU     0x400FE608         ;General-Purpose Input/Output Run Mode Clock Gating Control Register
GPIO_PORTF_DIR_R              EQU     0x4005D400         ;GPIO Port N DIR Register
GPIO_PORTF_DEN_R              EQU     0x4005D51C         ;GPIO Port N DEN Register
GPIO_PORTF_DATA_R             EQU     0x4005D3FC         ;GPIO Port N DATA Register 
GPIO_PORTM_DIR_R              EQU     0x40063400         ;GPIO Port N DIR Register
GPIO_PORTM_DEN_R              EQU     0x4006351C         ;GPIO Port N DEN Register
GPIO_PORTM_DATA_R             EQU     0x400633FC         ;GPIO Port N DATA Register 

                              
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start

;Function PortN_Init
PortFM_Init 
		;STEP 1
		 LDR R1, =SYSCTL_RCGCGPIO_R    		; Load the memory address of RCGCGPIO into R1
		 LDR R0, [R1]						; Load the contents of the memory address of RCGCGPIO into R0
		 ORR R0,R0, #0x820					; Perform a bitwise OR operation with contents of R0 and 0x1800 and stores it in R0
		 STR R0, [R1]						; Store what is in R0 into R1
		 NOP
		 NOP
		
		;STEP 5
		 LDR R1, =GPIO_PORTF_DIR_R			; Load the memory address of the GPIO Port N DIR Register into R1
		 LDR R0, [R1]						; Load the contents of the memory address of GPIO Port N DIR Register in R0
		 ORR R0,R0, #0x10					; Perform a bitwise OR operation with the contents of R0 with 0x2 and store it back into R0
		 STR R0, [R1]						; Store what is in R0 into R1
		 
		 LDR R1, =GPIO_PORTM_DIR_R			; Load the memory address of the GPIO Port N DIR Register into R1
		 LDR R0, [R1]						; Load the contents of the memory address of GPIO Port N DIR Register in R0
		 BIC R0,R0, #0x1					; Perform a bitwise OR operation with the contents of R0 with 0x2 and store it back into R0
		 STR R0, [R1]						; Store what is in R0 into R1
		 
		;STEP 7
		 LDR R1, =GPIO_PORTF_DEN_R			; Load the memory address of the GPIO Port N DEN Register into R1
		 LDR R0, [R1]						; Load the contents of the memory address of GPIO Port N DEN Register in R0
		 ORR R0,R0, #0x10					; Perform a bitwise OR operation with the contents of R0 with 0x2 and store it back into R0
		 STR R0, [R1]						; Store what is in R0 into R1
		 
		 LDR R1, =GPIO_PORTM_DEN_R			; Load the memory address of the GPIO Port N DEN Register into R1
		 LDR R0, [R1]						; Load the contents of the memory address of GPIO Port N DEN Register in R0
		 ORR R0,R0, #0x1					; Perform a bitwise OR operation with the contents of R0 with 0x2 and store it back into R0
		 STR R0, [R1]						; Store what is in R0 into R1
		
        BX LR               ; return from function 
       
Start 
	    BL PortFM_Init       ; calls and execute your PortN_Init function
		;STEP 8    
		
		 LDR R1, =GPIO_PORTF_DATA_R			; Load the memory address of the GPIO Port N DATA Register into R1
		 LDR R0, [R1]						; Load the contents of the memory address of GPIO Port N DATA Register in R0

loop	 LDR R2, =GPIO_PORTM_DATA_R			; Load the memory address of the GPIO Port N DATA Register into R2
		 LDR R3, [R2]						; Load the contents of R2 into R3
		 
		 CMP R3, #0x0						; Compare R3 with 0
		 ITE EQ								; if R3 is 0, then it means that LED is on, otherwisw on
		 ORREQ R0,R0, #0x10
		 ANDNE R0,R0, #0x0
		 
		 STR R0, [R1]
		B loop
		
		ALIGN               ; directive for assembly			
        END                 ; End of function 
