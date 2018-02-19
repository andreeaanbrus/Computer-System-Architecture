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
    b db 1
    c dw 202
    d db 2
    x dq 5

; our code starts here
;(8 - a*b*100 + c)/d + x
;a,b,d-byte; c-doubleword; x-qword
segment code use32 class=code
    start:
        ;a * b * 100
        mov AL, byte [a]; AL -> a, AL -> 2
        mul byte [b]; AX : AL * b, AX -> 2 * 1 = 2
        xor BX, BX  ; BX -> 0000
        mov BL,100  ;BL -> 100; BL->64
        mul BX      ; DX:AX -> AX * BX; AX:DX -> C8:00
        neg AX
        neg DX
        add AX, [c]
        adc DX, 0
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
