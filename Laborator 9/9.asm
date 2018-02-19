bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format1 db "%d ", 0
    format2 db "%c", 0
    nume_fisier db "fiser9.txt", 0
    buffer dd 0
    handler dd -1
    modeR db "r", 0
    maxap dd 0
    maxcar dd 0
    frecventa times 256 db 0

;Se da un fisier text. Sa se citeasca continutul fisierului, sa se determine caracterul special (diferit de litera) cu cea mai mare frecventa si sa se afiseze acel caracter, impreuna cu frecventa acestuia. 
;Numele fisierului text este definit in segmentul de date.

segment code use32 class=code
    start:
    ;fopen
    push dword modeR
    push dword nume_fisier
    call [fopen]
    add esp, 4 * 2
    mov [handler], eax
    
    ;caracter cu caracter citire
    repeta:
        ;eax = read(buffer, 1, 1, handler)
        push dword [handler]
        push dword 1
        push dword 1
        push dword buffer
        call [fread]
        add esp, 4 * 4
        
        mov edx, 0
        mov dl, byte[buffer]
        cmp dl, 'A'
        jb nulitera
        cmp dl, 'Z'
        jb skip
        cmp dl, 'a'
        jb nulitera
        cmp dl, 'z'
        jb skip
        jmp nulitera
        nulitera:
        add byte[frecventa + edx], 1
        jmp skip
        skip:
        cmp eax, 0
        jne repeta
     
     mov ecx, 256
     mov esi, frecventa
     repeta1:
        lodsb
        cmp al, [maxap]
        jb cont
        mov [maxap], al
        jmp cont
        cont:
            loop repeta1
     mov ecx, 255
     mov edx, 0
     mov esi, frecventa
     repeta2:
        lodsb
        cmp al, [maxap]
        jne cont2
        mov [maxcar], edx
        jmp cont2
      cont2:
      add edx, 1
      loop repeta2

     ;print maxap
     push dword [maxap]
     push dword format1
     call [printf]
     add esp, 4 * 2

    ;print maxcar
     push dword [maxcar]
     push dword format2
     call [printf]
     add esp, 4 * 2
     
     
     
    ;fclose
    push dword [handler]
    call [fclose]
    add esp, 4
    
    push dword 0
    call [exit]