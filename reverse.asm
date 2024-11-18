%macro scall 4
   mov rax, %1
   mov rdi, %2
   mov rsi, %3
   mov rdx, %4
   syscall
%endmacro

section .data
   m1 db "Enter the string: ", 10d, 13d
   l1 equ $-m1
   
   m2 db "The length of the string is: ", 10d, 13d
   l2 equ $-m2
   
   m3 db 10d, 13d, "The reverse of the string is: ", 10d, 13d
   l3 equ $-m3
   
section .bss
    string resb 50   ;for intput string
    string2 resb 50  ;for storing reverse string
    length resb 16   ;for storing input string length
    answer resb 16   ;for storing reversed string

section .text
    global _start
_start: 
;use to measure length of input string 
    scall 1, 1, m1, l1
    scall 0, 0, string, 50
    
    ;dec rax  ; Adjust for newline character
    mov [length], rax ;stores the value of length into length buffer

    scall 1, 1, m2, l2
    mov rax, [length]
    call display

    mov rsi, string  ;points to input string
    mov rdi, string2  ;points to reverse string variable from end
    mov rcx, [length]  
    add rdi, rcx
    dec rdi

loop2:  
    mov al, [rsi]        
    mov [rdi], al
    dec rdi
    inc rsi
    loop loop2
    
    scall 1, 1, m3, l3
    scall 1, 1, string2, [length]

exit:                           
    mov rax, 60
    mov rdx, 0
    syscall
    
display:
    mov rsi, answer+15
    mov rcx, 16

label1:
    mov rdx, 0
    mov rbx, 10  ; Change base to decimal
    div rbx
    add dl, '0'  ; Convert to ASCII
    mov [rsi], dl
    
    dec rsi
    dec rcx
    test rax, rax
    jnz label1
    scall 1, 1, answer, 16       
ret