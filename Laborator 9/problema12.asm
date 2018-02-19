bits 32 ; assembling for the 32 bits architecture


global start        


extern exit, fopen, fclose, scanf, fprintf            
import exit msvcrt.dll 
import fprintf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll   
import scanf msvcrt.dll   
                     
segment data use32 class=data
    file_name db "fisier12.txt", 0
    modeW db "w", 0
    handler dd -1
    buffer dd -1
    x dd -1
    formatc db "%d", 0
    formata db "%d ",0
    
    
    
;Se da un nume de fisier (definit in segmentul de date). Sa se creeze un fisier cu numele dat, apoi sa se citeasca de la tastatura numere si sa se scrie valorile citite in fisier pana cand se citeste de la tastatura valoarea 0.
   
segment code use32 class=code
    start:
            ;deschid fisier
            ;fopen(file_name, modeW)
            push dword modeW
            push dword file_name
            call [fopen]
            add esp, 4 * 2
            
            mov [handler], eax
            
            repeta:
                push dword x
                push dword formatc
                call [scanf]
                add esp, 4 * 2
            
                pushad
                push dword [x]
                push dword formata
                push dword [handler]
                call [fprintf]
                
                add esp, 4 * 3
                popad
                
                cmp dword[x], 0
                jne repeta
            
            
            ;inchid fisier
            ;fclose(handler)
            push dword [handler]
            call [fclose]
            add esp, 4 
        ; exit(0)
        push    dword 0      
        call    [exit]   
