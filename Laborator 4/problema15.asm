bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 1100011011000110b
    b dw 0110100100011110b
    c1 dd 0

; our code starts here
segment code use32 class=code
    start:
        and word[c1], 00000000000000000000000000111000b
        ;make bits 0-2 0 and bits 3-5 1
        and word[a], 0000001111000000b
        ;isolate bits 6-9 from a
        shr word[a], 4
        ;bits 6-9 from
        xor eax, eax
        mov eax, [a]
        or dword[c1], eax
        xor eax, eax
        
        mov eax, [b]
        and eax, 00000000000000001111100000000000b
        or dword[c1], eax
        or dword[c1], 11111111111111110000000000000000b
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
