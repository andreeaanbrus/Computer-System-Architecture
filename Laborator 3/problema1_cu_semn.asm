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
    b dw -3
    c dd 4
    d dq 5

; our code starts here
;(c+d)-(a+d)+b
;a - byte, b - word, c - double word, d - qword
segment code use32 class=code
    start:
        ;(c+d)
        mov ECX, DWORD[d]  
        mov EDX, DWORD[d+4] ;EBX:EDX - qword d, 5
        add ECX, DWORD[c]   ;ECX := EBX + c, 9
        adc EDX, 0          ;in caz de carry, se aduna la EDX
        ;a+d
        mov ESI, DWORD[d]
        mov EDI, DWORD[d+4]; ESI:EDI - qword data, 5
        mov AL, byte[a]    ; EBX -> 2
        cbw                ; converting byte a to word
        cwde               ; converting the word a to double word in EAX
        add ESI, EAX       ; ESI := ESI + EAX
        adc EDI, 0         ; in caz de carry, se aduna la EDI
                           ;ESI:EDI := 2
        ;(c+d) - (a+d)                   
        sub ECX, ESI       ; ECX := ECX - ESI
        sbb EDX, 0         ; daca exista imprumut, se scade din EDX
        sub EDX, EDI       ; EDX := EDX - EDI
                           ; EDX:ECX := (c+d) - (a+d)
        ;(c+d)-(a+d) + b
        mov AX, word [b]   ; AX -> b (-3)
        cwde               ; converting word to double word in EAX
        add ECX, EAX       ;ECX := ECX + EAX, ECX = 2-3 = -1 = FFFFFF(h)
        adc EDX, 0         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
