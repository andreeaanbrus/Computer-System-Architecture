bits 32

global start
extern exit, printf
import printf msvcrt.dll
import exit msvcrt.dll

segment data use32 class=data
       s1 db 1, 2, 4, 6, 10, 20, 25
       len equ ($-s1-1)
       s2 times len db 0
       format db "%d ", 0

segment code use32 class=code
    start:
    ;pun primul numar
    mov al, [s1+0]
    mov [s2+0], al
    
    mov ecx, len
    mov esi, 1
    jecxz Sfarsit
    loops:
        mov al, [s1+esi]
        mov ah, [s1+esi+1]
        sub ah, al
        mov [s2+esi], ah
        add esi, 1
    loop loops
        
    Sfarsit:
    ;exit(0)
    push dword 0
    call [exit]