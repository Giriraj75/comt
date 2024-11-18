%macro scall 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro

section .data
    msg1 db "enter no: ",0xa
    len1 equ $-msg1
    msg2 db "enter no: ", 0xa
   
    len2 equ $ - msg2
    result_msg db "The sum is: ", 10, 13
    len_result equ $-result_msg

section .bss
    sum resb 10
    num1 resb 10
    num2 resb 10

section .text
    global _start



_start:

scall 1,1,msg1,len1
scall 0,0,num1,10

scall 1,1,msg2,len2
scall 0,0,num2,10

    movzx rax, byte [num1]
    sub rax, '0'
    imul rax, rax, 10

    movzx rbx, byte [num1 + 1]
    sub rbx, '0'
    add rax, rbx

    movzx rbx, byte [num2]
    sub rbx, '0'
    imul rbx, rbx, 10

    movzx rcx, byte [num2 + 1]
    sub rcx, '0'
    add rbx, rcx

    add rax, rbx

    mov rcx, rax
    mov rbx, 10
    xor rdx, rdx
    div rbx

    add rax, '0'
    mov [sum], al

    add dl, '0'
    mov [sum + 1], dl
    mov byte [sum + 2], 0

    scall 1, 1, result_msg, len_result
    scall 1, 1, sum, 2

    exit
