
/******************************************************************************
* File: max-weight-implementation.s
* Author: Pavan Kumar G
* Roll number: CS18M517
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************


  Assignment 3 - Hamming weight
  Reference: https://en.wikipedia.org/wiki/Hamming_weight
  
  
  int hammingWt_32bit(uint32_t x){
		x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
		x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
		x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
		x += x >>  8;  //put count of each 16 bits into their lowest 8 bits
		x += x >> 16;  //put count of each 32 bits into their lowest 8 bits
		return x & 0x7f;
	}
  */

@ BSS section
    .bss
z: .word

@ DATA SECTION
    .data
data_items: .word 0x205a15e3, 0x2000a123, 0x256c8700, 0x295468f2

data_start: .word 0x205A15E3
            .word 0x256C8700
			.word 0x295468F2
data_end:   .word 0
length: 	.word (data_end - data_start)/4

w1: .word 0x55555555;
w2: .word 0x33333333;
w3: .word 0xf0f0f0f;
w4: .word 0x0000007f;

num: .word 0
weight: .word 0

@ TEXT section
    .text

.global _main

                
_main:
    LDR r5, =data_items       	;@Initialize the address of data item
    LDR r8, =weight
    EOR r1, r1, r1           	;@r1 max weight
    EOR r2, r2, r2           	;@r2 Max element
	
	LDR r4, =length				;@load length, if length is 0, stop execution
	LDR r0, [r4]				;@using r0 as a counter
	
	CMP r0, #0				
	BEQ END					;@End if length is 0
	
	
	   
	LDR r4, =w1				; @ load predefined values 
	LDR r7, [r4]           ;@ w1
   
	LDR r4, =w2            ;@  w2
	LDR r8, [r4]
   
	LDR r4, =w3            ;@ w3
	LDR r9, [r4]
   
	LDR r4, =w4           ;@ w4
	LDR r10, [r4]
	   
	LDR r4, =data_start;    ;@ load data_start starting address into register r4
	   
	   
loop:  LDR r3, [r4], #4		;       @ Looping through all the elements in the list, register r3 holds the number read
	   EOR r5, r5, r5		;  @wt of current element
	   	   	  
	   AND r5, r7, r3, LSR #1	; @ x -= (x >> 1) & m1 ount of each 2 bits into those 2 bits
	   SUB r5, r3, r5			
	   	  
	   EOR r6, r6, r6			;  @ x = (x & m2) + ((x >> 2) & m2)	
	   AND r6, r8, r5, LSR #2
	   AND r5, r5, r8
	   ADD r5, r5, r6			; @ ount of each 4 bits into those 4 bits 
	   
	   ADD r5, r5, r5, LSR #4		  	  
	   AND r5, r5, r9;        
	   
	   ADD r5, r5, r5, LSR #8	; @ x += x >>  8, put count of each 16 bits into their lowest 8 bits
	   ADD r5, r5, r5, LSR #16	;@ x += x >> 16, put count of each 32 bits into their lowest 8 bits
	   	   	 
	   AND r5, r5, r10;        @ Lower order 8 bits has the count
	   
	   CMP r5, r1;             @ Compare with previous max weight
	   
	   
	   MOVGT r1, r5;             @ Max weight
	   MOVGT r2, r3;	           @ Set current element as the element with the max weight
	   
		SUBS r0, r0, #1;	   @ Decrement counter
		BNE loop;	           @ Repeat till counter comes to 0
	   
END:
	LDR r4, =num			;@ Store results in specified memory
	STR r2, [r4]
	LDR r4, =weight
	STR r1, [r4]	   	   
	   