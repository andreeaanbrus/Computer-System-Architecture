bits 32
global start

extern exit, fopen, fclose, fread, fwrite, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fwrite msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    file_name db "text.txt", 0
    error_msg db "Error opening file %s", 0
    modeR db "r", 0
    handler1 dd -1
    format db "%d"
    len equ 100
    buffer resb len
    cnt dd 0

;Se da un fisier text. Sa se citeasca continutul fisierului, sa se contorizeze numarul de cifre pare si sa se afiseze aceasta valoare. 
;Numele fisierului text este definit in segmentul de date.

segment close use32 class=code
    start:
    ;open the file for reading
    ;eax = fopen(file_name, modeR)
    push dword modeR
    push dword file_name
    call [fopen]
    add ESP, 4*2
    
    mov [handler1], EAX ;salvam valoarea returnata in handler1. daca handler1==0 -> eroare
    cmp EAX, 0
    je erroropen1
    mov ecx, 0
    ;citire caractere din fisier (peste 100)
    repeta:
        ;read one byte frmo handler1
        ;eax = fread(buffer, 1, len, descriptor_fis)
        push dword [handler1]
        push dword 1 ;citesc un string
        push dword 1 ;citesc un byte
        push dword buffer
        call[fread]
        add ESP, 4 * 4
        cmp EAX, 0
        je donereading
        mov AL, [buffer]
       
        cmp AL, 30h
        je incrementcnt
        cmp AL, 32h
        je incrementcnt
        cmp AL, 34h
        je incrementcnt
        cmp AL, 36h
        je incrementcnt
        cmp AL, 38h
        jne skip
        add dword[cnt], 1
        jmp repeta
        skip:
            jmp repeta
        
    
    erroropen1:
        push dword file_name
        push dword error_msg
        ;push dword handler1
        ;push dword format
        call[printf]
        add ESP, 4*2
        jmp final

        
    donereading:
        ;close the file
        ;fclose(file_name)
        
        push dword [cnt]
        push dword format
        call [printf]
        add ESP, 4*2
        push dword [handler1]
        call [fclose]
        add ESP, 4*1
        jmp final
    
        
   final:
    ;exit(0)
    push dword 0
    call [exit]