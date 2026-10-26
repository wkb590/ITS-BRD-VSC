;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke    
;* Version            : V1.0
;* Date               : 01.06.2021
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     : 
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe
    
;* We need some data to work on
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0xaffe

;* We need minimal memory setup of InRootSection placed in Code Section 
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
    ldr     R0,=VariableA   ; Anw01
    ldrb    R2,[R0]         ; Anw02
    ldrb    R3,[R0,#1]      ; Anw03
    lsl     R2, #8          ; Anw04
    orr     R2, R3          ; Anw05
    strh    R2,[R0]         ; Anw06 
    
;* const in var
    mov     R5,#ConstByteA  ; Anw07
    strh    R5,[R0]         ; Anw08

;* vertauschung für Affe
    ldr R0, =VariableC      ; Lädt die VariableC in R0
    ldrb R8, [R0]           ; Lädt das erste Byte von VariableC in R8
    ldrb R9, [R0,#1]        ; Lädt das zweite Byte von VariableC in R9
    lsl R8, #8              ; Schiebt das erste Byte um 8 Bit nach links
    orr R8, R9              ; Verknüpft das erste und zweite Byte
    strh R8, [R0]           ; Speichert den Wert von R8 in VariableC


;* Change value from x1234 to x4321
    ldr R1, =VariableB      ; Anw9
    mov R6, #0x4321         ; Lädt 0x4321 direkt in R6
    strh R6, [R1]           ; Speichert den Wert von R6 in VariableB

    b .                     ; Anw0E
    
    ALIGN
    END