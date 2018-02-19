bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf                ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 1, 2, 3, 4, 5, 6, 7 ;declararea sirului   
    l equ $-s ;lungimea sirului
    d times l db 0 ; rezervare spatiu pentru retinere sir
    format db "%d ", 0
 

;Se da un sir de octeti S. Sa se construiasca sirul D astfel: sa se puna mai intai elementele de pe pozitiile pare din S iar apoi elementele de pe pozitiile impare din S. 

segment code use32 class=code
    start:
        mov ebx, 1
        mov ECX, l
        mov ESI, 0
        mov EAX, 0
        jecxz Sfarsit
        
        start_loop_p:
            test esi, ebx ;and fictiv (ebx = 1)
            jnz cont_p    ;pare
            
            mov dl, BYTE[s+esi] ;dl:=s[esi]
            mov BYTE[d+eax], dl ;d[eax] = dl
            add eax, 1
            
            cont_p:
            add esi, 1
        loop start_loop_p
        
        mov ecx, l
        mov esi, 0
        
        start_loop_i:
            test esi, ebx   ;and fictiv(ebx =1)
            jz cont_i       ;impare
            
            mov dl, BYTE[s+esi] ;dl := s[esi]
            mov BYTE[d+eax], dl ;d[eax] := dl
            add eax, 1
            
            cont_i:
            add esi, 1
        loop start_loop_i
        
        mov ecx, l
        mov edx, 0
        
        ;afisare sir
        start_loop:
            xor ebx, ebx
            mov bl, BYTE[d + edx]
            pushad
            push dword ebx
            push dword format
            call [printf] 
            add esp, 4 * 2 
            popad
            add edx, 1
        loop start_loop

        Sfarsit:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
