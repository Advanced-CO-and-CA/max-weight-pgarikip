
/******************************************************************************
* File: max-weight-implementation.s
* Author: Pavan Kumar G
* Roll number: CS18M517
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 3 - To find the number with the max weight
  Algorithm used :
  Basic solution 
  while(n != 0) {
      n &= (n-1);
      count++;
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
	BEQ END					;@break if there are no elements i.e. length is 0
	
	LDR r4, =data_start		;@ load data_start starting address into register r4

LOOP:                                                                 
	LDR r3, [r4], #4		;@Looping through all the elements in the list, register r3 holds the number read
	EOR r7, r7, r7			;@re-set count for 1's
	
LOOP1:		
	   MOV r5,r3			;@ loop to find count of 1's
	   SUB r6, r5,#1
	   EOR r6,r5,r6
	   CMP r6,#0
	   ADDNE r7, #1
	   
	   CMP r5,#0
	   BNE LOOP1
	   
	   CMP r7, r1
	   MOVGT r1, r7			;@Set current element as the element with the max weight
	   MOVGT r2, r3			;@ Set current element as the max value if it is greater than the existing max element
	   
	  SUBS r0, r0, #1		;@Decrement counter
	  BNE LOOP				;@Repeat till counter comes to 0
END:
	LDR r4, =num			;@ Store results in specified memory
	STR r2, [r4]
	LDR r4, =weight
	STR r1, [r4]	   	   
	   
