bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 1011001100111011b
    b dw 1110010110001010b
    c dd 0
    
; Se dau cuvintele A si B. Sa se obtina dublucuvantul C:
;bitii 0-2 ai lui C coincid cu bitii 12-14 ai lui A
;bitii 3-8 ai lui C coincid cu bitii 0-5 ai lui B
;bitii 9-15 ai lui C coincid cu bitii 3-9 ai lui A
;bitii 16-31 ai lui C coincid cu bitii lui A
segment code use32 class=code
    start:
        ;the bits 0-2 of C should be the bits 12-14 of A
        mov AX, [a] ; AX:= 1011 0011 0011 1011b (B33Bh)
        shl AX, 12  ; AX = 1011 0000 0000 0000b (B000h)
        and AX, 1110000000000000b ; AX := 1010 0000 0000 0000b 
        ;convert the word in AX into double word in EAX
        mov DX, 0
        push AX
        push DX
        pop EAX ; EAX := 1010 0000 0000 0000 0000 0000 0000 0000b (A0000000h)
        mov ECX , 0
        or ECX, EAX ; BCX := EAX = 1010 0000 0000 0000 0000 0000 0000 0000b (A0000000h)
        
        ;the bits 3-8 of C should be the bits 0-5 of B
        mov AX, [b] ; AX := 1110 0101 1000 1010b = E68Ah
        shr AX, 3   ; AX := 0001 1100 1011 0001b = 1CB1h
        and AX, 0001111110000000b ; AX := 0001 1100 1000 0000b = 1C80
        ; convert the word AX into dword EAX
        mov DX, 0   ; DX := 0
        push AX
        push DX
        pop EAX     ;EAX := 0001 1100 1000 0000 0000 0000 0000 0000
        or ECX, EAX ;BCX := 1011 1100 1000 0000 0000 0000 0000 0000 = BC800000h
        
        ; the bits 9-15 of c should be the bits 3-9 of a
        mov AX, [a] ; AX := 1011 0011 0011 1011 = B33Bh
        shr AX, 6   ; AX := 0000 0010 1100 1100 = 02CCh
        and AX, 000000001111111b ; AX := 0000 0000 0100 1100 = 004Ch
        ;convert the word Ax into dword EAX
        mov DX, 0   ; DX := 0
        push AX
        push DX
        pop EAX     ;EAX := 0000 0000 0100 1100 0000 0000 0000 0000
        or ECX, EAX ;ECX := 1011 1100 1100 1100 0000 0000 0000 0000 = BCCC0000h
        
        ;bits 16-31 of C should be all bits of ai
        xor EAX, EAX; EAX:= 0
        mov AX, [a] ; AX := 1011 0011 0011 1011 = B33Bh
        or ECX, EAX ; ECX := 1011 1100 1100 1100 1011 0011 0011 1011 BCCCB33Bh
        mov [c], ECX; c := ECX 
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
