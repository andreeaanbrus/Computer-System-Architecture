bits 32 

global start        

extern exit, printf               
import exit msvcrt.dll
import printf msvcrt.dll    
                          

segment data use32 class=data
  a dw 23
  b db 10
  cat dd 0
  rest1 dd 0
  format1 db "cat = %d, rest = %d"
segment code use32 class=code
    start:
        
        
        mov ax, [a]
        div byte[b]
        mov [cat], ah
        mov [rest1], al
        
        push dword [rest1]
        push dword [cat]
        push dword format1
        call [printf]
        add esp, 4 * 3
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
