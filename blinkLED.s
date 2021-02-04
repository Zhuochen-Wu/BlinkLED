;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Name: Zhuochen Wu;
; Student Number: 400271642 Put your student number here for labs
; Lab Section: L07
; Description of Code: This code allows User LED D3 To Turn On (Put a brief description of your code) 
; Last Modified: Feb 3nd 2021
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ADDRESS DEFINTIONS

;The EQU directive gives a symbolic name to a numeric constant, a register-relative value or a program-relative value


SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register (RCGCGPIO Register)
GPIO_PORTN_DIR_R             EQU 0x40064400  ;GPIO Port N Direction Register address 
GPIO_PORTN_DEN_R             EQU 0x4006451C  ;GPIO Port N Digital Enable Register address
GPIO_PORTN_DATA_R            EQU 0x400643FC  ;GPIO Port N Data Register address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Do not alter this section

        AREA    |.text|, CODE, READONLY, ALIGN=2 ;code in flash ROM
        THUMB                                    ;specifies using Thumb instructions
        EXPORT Start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Define Functions in your code here 
;The function Port F_Init to configures the GPIO Port F Pin 4 for Digital Output 

PortN_Init
    ; STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R          ;Loads the memory address of RCGCGPIO into register 1(R1); R1 = 0x400FE608
    LDR R0, [R1]                        ;Put the contents of the memory address of RCGCGPIO into register 0 (R0), R0 = 0x00000000
    ORR R0,R0, #0x1000                  ;Performs a bitwise OR operation with the contents of R0 and 0x20 and stores it back into R0, R0 = 0x1000,since 12th bit register is for port N
    STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1,RCGCGPIO now has Ox20 stored in it 
    NOP                                 ;Waiting for GPIO Port F to be enabled
    NOP                                 ;Waiting for GPIO Port F to be enabled
  
   ; STEP 5
    LDR R1, =GPIO_PORTN_DIR_R           ;Load the memory address of the GPIO Port F DIR Register into register 1 (R1), R1 = 0x4005D400
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DIR Register in R0, R0 = 0x00000000
    ORR R0,R0, #0x1                  	;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0 , R0 = 0x2, first pin on the GPIODIR register
    STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1; GPIO Port F Direction Register now has 0x10 stored in it 
    
	; STEP 7
    LDR R1, =GPIO_PORTN_DEN_R           ;Load the memory addess of the GPIO Port F DEN Register into register 1 (R1), R1 = 0x4005D51C
    LDR R0, [R1]                        ;Put the contents of the memory address of GPIO Port F DEN Register in register 0 (R0,), R0 = 0x00000000
    ORR R0, R0, #0x1                   ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x2, first pin on the GPIODIR register
    STR R0, [R1]	                    ;Stores R0 contents into contents of the address located in R1; GPIO Port F DEN Register now has 0x10 stored in it 
    BX  LR                              ;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Start
	     BL  PortN_Init                      ;The BL instruction is like a function call 
    ;STEP 8                              		
loop     LDR R1, =GPIO_PORTN_DATA_R          ;Load the memory addess of the GPIO Port F DATA Register into register 1 (R1), R1 = 0x4005D3FC
	 LDR R0,[R1]                         ;Put the contents of the memory address of GPIO Port F DATA Register 0 (R0), R0 = 0x00000000
         ORR R0,R0, #0x1                     ;Perform a bitwise OR operation with the contents of R0 with 0x10 and put the contents into R0, R0 = 0x1, change this value can change the bit enabled on board.
         STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1; GPIO Port F Data Register now has 0x10 stored in it
         LDR R2, =0x7FFFF                    ;Load the register r2 with binary 1101111111111111111 change this value will be able to change the speed of the loop. Make it higher then slower.
loop1    NOP
         NOP
	 SUBS R2,R2, #0x1                     ;infinitely looping through
	 BNE loop1
		
	 LDR R1, =GPIO_PORTN_DATA_R          ;Load the memory addess of the GPIO Port F DATA Register into register 1 (R1), R1 = 0x4005D3FC
	 LDR R0,[R1]                         ;Put the contents of the memory address of GPIO Port F DATA Register 0 (R0), R0 = 0x00000000
         AND R0,R0, #0x0                     ;Perform a bitwise AND operation with the contents of R0 with 0x0 and put the contents into R0, R0 = 0x10
         STR R0, [R1]                        ;Stores R0 contents into contents of the address located in R1; GPIO Port F Data Register now has 0x10 stored in it
         LDR R2, =0x7FFFF                    ;change this value will be able to change the speed of the loop. Make it higher then slower.
loop2    NOP                                 ;why it change the speed? because command above this loop execute, then come to this delayed loop, all numbers inside R2 must be SUBS to zero until goto next loop cycle.
                                             ;therefore the larger this number inside R2 is, the longer it needs to finish the delayed loop, therefore blink slower.
         NOP
		 SUBS R2,R2, #0x1
		 BNE loop2
	
	B loop
	
	ALIGN                               ;Do not touch this 
    END   
