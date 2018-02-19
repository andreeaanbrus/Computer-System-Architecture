bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 4
    b dw 2
    rezultat dd 0
    format db "%d", 0
; %lf -specificator de format
;Sa se citeasca de la tastatura doua numere a si b (in baza 10) si sa se calculeze: (a+b) * (a-b). Rezultatul inmultirii se va salva in memorie in variabila "rezultat" (definita in segmentul de date).
segment code use32 class=code
    start:
        ;read a
        push dword a
        push dword format
        call [scanf]
        add ESP, 4 * 2
        
        ;read b
        push dword b
        push dword format
        call [scanf]
        add ESP, 4 * 2
        
        ;print a
       ; push dword [a]
       ; push dword format
       ; call [printf]
       ; add ESP, 4 * 2
        
        
        ;AX := a+b
        mov AX, [a]
        add AX, [b]
        
        ;BX := a-b
        mov BX, [a]
        sub BX, [b]
        
        ;DX:AX = AX * BX
        
        imul BX
        
        push DX
        push AX
        pop EAX
        mov [rezultat], EAX
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
