bits 32
global start

extern exit, printf, scanf
import scanf msvcrt.dll
import printf msvcrt.dll
import exit msvcrt.dll

segment data use32 class=data
    a dd 10
    b dd 0
    suma dd 0
    format db "%d + %d / %d = %d", 0
    format1 db "%d", 0
    message db "b=", 0

segment code use32 class=code
    start:
    ;citire b
    push dword message
    call [printf]
    add esp, 4*1
    
    push dword b
    push dword format1
    call[scanf]
    add esp, 4*2
    
    ;calcul suma
    mov eax, [a]
    mov [suma], eax
    mov ebx, dword[b]
    xor edx, edx
    div bx
    add [suma], ax
    
    ;printare suma
    push dword [suma]
    push dword [a]
    push dword [b]
    push dword [a]
   
    push dword format
    call [printf]
    add esp, 4*5
    
    ;exit(0)
    push dword 0
    call [exit]
