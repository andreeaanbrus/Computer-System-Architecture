bits 32
global start

extern exit, fopen, fclose, printf, fwrite, fread
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fwrite msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data 
    file_name db "file_name", 0
    error_msg db "Error opening file", 0
    string db "adsadaNdsadsaNNNsad342543", 0
    modeW db "w", 0
    len equ 100
    handler dd -1

segment code use32 class=code
    start:
    ;open file
    ;eax = fopen(file_name, modeW)
    push dword modeW
    push dword string
    call [fopen]
    add ESP, 4*2
    
    mov [handler], eax
    cmp eax, 0
    je errormsg
    
    ;parcurgere 
    repeat:
        ;read one byte from the string
        ; for i = 0; i < len(string); i ++
        ;   if string(i) >= 65 or string(i) <= 90
        ;           string(i) += 32
        ;   if string(i) >= 97 or string(i) <= 122
        ;           string(i) -= 32
        mov esi, string
        repeat:
            lodsb
            cmp al, 65
                jae trySmallLetter
          
                trySmallLetter:
                    cmp al, 90
                        jbe convertSmallLetterToBigLetter
                        ja tryBigLetter
                            tryBigLetter:
                                cmp al, 97
                                    jae tryBigLetterRight
                                    tryBigLetterRight:
                                        cmp al, 122
                                        jbe convertBigLetterToSmallLetter:    
                                        ja repeat
    convertSmallLetterToBigLetter:
        add al, 32
    convertBigLetterToSmallLetter:
        sub al, 32
    ;add character to file
    
    
    
    ;check if there are no more letters
    cmp al, 0
    je final
    jmp repeat
        
    
    jmp final
    
    errormsg:
        push dword string
        call [printf]
        jmp final
    
    final :
        ;exit(0)
        push dword 0
        call [exit]