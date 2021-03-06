bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2
    b db 1
    c dd 4
    d db 2
    x dq 5
;(8-a*b*100+c)/d+x
;a,b,d-byte; c-doubleword; x-qword
; our code starts here
segment code use32 class=code
    start:
        mov AL, [a] ;AL:= [a] = 2
        mov BL, [b] ; BL:=[b] = 1
        imul BL      ;AX := AL * BL = 2*1 = 2
        mov BX, 100 ; BX -> 64(h)
        imul BX      ; DX:AX = AX* 100= 200 = C8
        mov EBX, [c]; EBX -> c
        add EBX, 8  ; c+8
        
        shl EAX, 16
        mov DX, AX
        rol EAX, 16 ;EAX -> :AX:DX
        
        
        sub EBX, EAX
        mov EAX, EBX
        
        rol EAX, 16
        mov DX, AX
        shr EAX, 16
        ; EAX -> DX:AX
        
        mov BL, [d]
        movsx BX, BL ; conversie cu semn byte -> word
        idiv BX     
        
        add AX, [x]    ; AX += AX + 5 = -94+5 = -89 = FFA2  
        cwde
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
