bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 1
    b db 2
    c db 3
    d db 4

; our code starts here
; (c + d) - (a + d) + b
segment code use32 class=code
    start:
        mov AX, [c] ; AX = 3
        add AX, [d] ; AX = c + d = 3 + 4 = 7
        mov BX, [a] ; BX = 1 
        add BX, [d] ; BX = a + d = 5
        sub AX, BX  ; AX = AX - BX = 7 - 5 = 2
        add AX, [b] ; AX = AX + b = 2 + 2 = 4
       ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
