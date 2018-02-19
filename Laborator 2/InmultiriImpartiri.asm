bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2
    b db 2
    d dw 3

; [-1+d-2*(b+1)]/a
;a,b,c - byte, d - word
segment code use32 class=code
    start:
        mov AL, [b] ; AL = 2 = 02(h)
        add AL, 1   ; AL = 2 + 1 = 3 = 03(h)
        mov AH, 2   ; AH = 2 = 02(h)
        mul AH      ; AX = AL * AH = 3 * 2 = 6 = 06(h)
        mov BX, [d]      ; BX = 3 = 03(h)
        neg AX      ; AX = -AX = -6 = FFFA
        add AX, BX  ; AX = AX + BX = -6 + 3 = -3 = FFFD
        add AX, -1  ; AX = AX - 1 = -3 - 1 = -4 = FFFC
        mov CL, [a] ; CL = 1
        idiv CL      ; AL = AX/CL, AH = AX % CL ; AL = FE, AH = 00 
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
