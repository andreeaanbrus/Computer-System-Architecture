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
    b dw 3
    c dd 4
    d dq 5

; our code starts here
;(c+d)-(a+d)+b
;a - byte, b - word, c - double word, d - qword
segment code use32 class=code
    start:
        mov EAX, DWORD[d]  
        mov EDX, DWORD[d+4] ;EAX:EDX - qword d, 5
        add EAX, DWORD[c] ; EAX := EAX + c, 9
        adc EDX, 0        ; in caz de carry, se aduna la EDX
        
        mov ESI, DWORD[d]
        mov EDI, DWORD[d+4]; ESI:EDI - qword data, 5
        xor EBX, EBX       ; EBX -> 0
        mov BL, byte[a]    ; EBX -> 2
        add ESI, EBX       ; ESI := ESI + EBI
        adc EDI, 0         ; in caz de carry, se aduna la EDI
                           ;ESI:EDI := 2
        sub EAX, ESI       ; EAX := EAX - ESI
        sbb EDX, 0         ; daca exista imprumut, se scade din EDX
        sub EDX, EDI       ; EDX := EDX - EDI
                           ; EDX:EAX := (c+d) - (a+d)
                           
        xor EBX, EBX       ; EBX -> 0
        mov BX, WORD[b]    ; BX -> b (EBX -> b)
        add EAX, EBX       ; EAX := EAX + EBX
        adc EDX, 0         ; daca exista carry, se aduna la EDX
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
