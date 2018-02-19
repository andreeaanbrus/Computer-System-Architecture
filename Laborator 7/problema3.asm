bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dd 12AB5678h, 1256ABCDh, 12344344h 
    len equ ($-sir)/4
    aux dd 0
    format db "%x ", 0
    
; our code starts here
segment code use32 class=code
    start:
        mov esi, sir
        mov ecx, len - 1
        mov edx, esi
        add edx, len * 4
        jecxz final
        
        outerLoop:
            mov ebx, esi
            add ebx, 4
            innerLoop:
                xor eax, eax
                mov ax, word[ebx+2]
                    cmp ax, word[esi+2]
                    ja rotire
                        mov eax, dword[ebx]
                        push eax
                        mov eax, dword[esi]
                        mov dword[ebx], eax
                        pop eax
                        mov dword[esi], eax
                    rotire:
                add ebx, 4
                cmp ebx, edx
                jnz innerLoop
            add esi, 4
        loop outerLoop
        
        ;afisare
        mov ecx, len
        mov edx, 0
        start_loop:
            mov ebx, dword[sir+edx]
            pushad
            push dword ebx
            push dword format
            call [printf]
            add esp, 4*2
            popad
            add edx, 4
        loop start_loop
        final
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
