bits 32 


global start        

extern exit, fopen, fread, fclose, printf             
import exit msvcrt.dll    
import printf msvcrt.dll
import fopen msvcrt.dll    
import fclose msvcrt.dll    
import fread msvcrt.dll    
                          
segment data use32 class=data
    file_name db "vocale.txt", 0
    modeR db "r", 0
    handler1 dd -1
    len equ 100
    buffer resb len
    cnt dd 0
    format db "%d", 0
    vocale db "aeiouAEIOU", 0

    

segment code use32 class=code
    start:
        
        ;open file
        ;open(filename, moder)
        push dword modeR
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        ;eax -> val returnata de open(file_name, modeR)
        mov [handler1], eax
        ;daca eax e 0 -> eraore la deschidere
        mov ebx, buffer
        ;citire caracter cu caracter
        repeta:
            
            ;eax = fread(buffer, 1, len, descriptor fisier)
            push dword [handler1]
            push dword 1
            push dword 1
            push dword ebx
            call [fread]
            add ebx, 1
            mov edx, eax
            add esp, 4 * 4
            cmp eax, 0
  
            je donereading
            mov ah, [buffer]
            ;verifica daca e in sirul de vocale
            mov esi, vocale
            mov ecx, 10
           
           verifvoc:
                lodsb
                cmp al, ah
                je increment  
            loop verifvoc
            jmp skip
            increment:
                add dword[cnt], 1
                jmp repeta
            skip:
                jmp repeta
        
        donereading:
            ;close file
            ;fclose(file_name, handler1)
            ;print cnt
            push dword [cnt]
            push dword format
            call [printf]
            add esp, 4 * 2
            
            push dword [handler1]
            call [fclose]
            add esp, 4
            
        
        ; exit(0)
        push    dword 0      
        call    [exit]
