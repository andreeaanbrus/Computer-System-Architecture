bits 32

global start
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s1 db 'a', 'c', 'e'
    len1 equ $-s1
    s2 db 'b', 'd'
    len2 equ $-s2
    len equ len1+len2
    s times len db 0
    dsadfs db 210
    
segment code use32 class=code

    start:
    
    push dword 0
    call [exit]