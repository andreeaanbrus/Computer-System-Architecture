bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 db 1, 2, 3, 4
    l1 equ $-s1
    s2 db 5, 6, 7
    l2 equ $-s2
    d times l1+l2  db 1
    format db "%d ", 0
    
; our code starts here
segment code use32 class=code
    start:
        
        mov ecx, l1
        mov esi, 0
        start_loop:
            mov bl, BYTE[s1 + esi]
            mov BYTE[d + esi], bl
            inc esi
        loop start_loop
        mov edx, l2 - 1
        mov ecx, l2
        start_loop2:
            mov bl, byte[s2 + edx]
            mov byte[d + esi], bl
            inc esi
            sub edx, 1
            
        loop start_loop2
        ;print l1 and l2
        ;push dword l1
        ;push dword format
        ;call [printf]
        ;add esp, 4*2
        ;push dword l2
        ;push dword format
        ;call [printf]
        ;add esp, 4*2
        
        ;print d
        mov ecx, l1+l2
        mov edx, 0
        
        start_loop1:
            xor ebx, ebx
            mov bl, BYTE[d + edx]
            pushad
            push dword ebx
            push dword format
            call [printf] 
            add esp, 4 * 2 
            popad
            add edx, 1
        loop start_loop1
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
