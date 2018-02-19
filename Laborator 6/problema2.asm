bits 32

global start
extern exit, printf
import printf msvcrt.dll
import exit msvcrt.dll

segment data use32 class=data
    s1 db  1, 2, 3, 4
    len equ $-s1
    s2 db 5, 6, 7, 8
    dest times len db 0
    format db "%d ", 0
    x db 3

segment code use32 class=code

    start:
        mov ecx, len
        mov ebx, 1
        mov esi, 0
        
        start_loop_p:
            test esi, ebx 
            jz pare
            
            mov al, [s1+ esi]
            mov ah, [s2+ esi]
            sub al, ah
            mov dl, al
            mov [dest + esi], dl
            add esi, 1
            jmp fin
            pare:
            mov al, [s1+ esi]
            mov ah, [s2+ esi]
            add al, ah
            mov dl, al
            mov [dest + esi], dl
            add esi, 1
            fin :
        loop start_loop_p
        
        mov ecx, len
        mov edx, 0
        
        ;print:     ;varianta mea
         ;   xor ebx, ebx
         ;   mov bl, byte[dest + edx]
         ;   pushad
         ;   push dword ebx
         ;   push dword format
         ;   call [printf]
         ;   add esp, 4 * 2
         ;   popad
         ;   add edx, 1
        ;loop print
        
        start_loop: ; varianta din pb3
            xor ebx, ebx
            mov bl, BYTE[dest + edx] ;trebuia sa fie dest aici dar am pus s1 sa vad daca merge 
            pushad
            push dword ebx
            push dword format
            call [printf] 
            add esp, 4 * 2 
            popad
            add edx, 1
        loop start_loop
        
        ;exit(0)
        push dword 0
        call[exit]