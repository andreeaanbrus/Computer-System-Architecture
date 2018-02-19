bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10110010b
    b db 10110001b
    c db 10010011b
    d db 01001010b

; Dandu-se 4 octeti, sa se obtina in AX suma numerelor intregi reprezentate de bitii 4-6 ai celor 4 octeti.
segment code use32 class=code
    start:
        ; AL := the bits 4-6 of a (to the right side)
        mov AL, [a]         ; AL := 1011 0010 = B2
        shr AL, 1           ; AL := 0101 1001 = 59
        and AL, 00000111b   ; AL := 0000 0001 = 01
        
        ; BL := the bits 4-6 of b (to the right side)
        mov BL, [b]         ;BL := 1011 0001 = B1h
        shr BL, 1           ;BL := 0101 1000 = 58h
        and BL, 00000111b   ;BL := 0000 0000 = 0h
        
        ; CL := the bits 4-6 of c (to the right side)
        mov CL, [c]         ;CL := 1001 0011 = 93h
        shr CL, 1           ;CL := 0100 1001 = 49h
        and CL, 00000111b   ;CL := 0000 0001 = 01h
        
        ; DL := the bits 4-6 of d (to the right side)
        mov DL, [d]         ;DL := 0100 1010 = 4A
        shr DL, 1           ;DL := 0010 0101 = 25h
        and DL, 00000111b   ;DL := 0000 0101 = 05h
        
        mov AH, 0 
        
        ;make the addition -> max number = 28
        add AL, BL
        add AL, CL
        add AL, DL
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
