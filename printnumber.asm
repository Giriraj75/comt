section .data
prompt db "enter a number:", 0
len equ $ - prompt

section .bss
num resb 20  ; Reserve space for the input number

section .text
global _start

_start:
    ; Display prompt
    mov rax, 1              ; syscall number for sys_write (1)
    mov rdi, 1              ; file descriptor (1 = stdout)
    mov rsi, prompt         ; pointer to the input string
    mov rdx, len            ; length of prompt
    syscall                 ; make the syscall
 
    ; Read a number from stdin
    mov rax, 0              ; syscall number for sys_read (0)
    mov rdi, 0              ; file descriptor (0 = stdin)
    mov rsi, num            ; buffer to store the input
    mov rdx, 20             ; number of bytes to read
    syscall                 ; make the syscall
    
    ; Write the number to stdout
    mov rax, 1              ; syscall number for sys_write (1)
    mov rdi, 1              ; file descriptor (1 = stdout)
    mov rsi, num            ; pointer to the input number
    mov rdx, rcx            ; number of bytes to write (without newline)
    syscall                 ; make the syscall

    ; Exit the program
    mov rax, 60             ; syscall number for sys_exit (60)
    xor rdi, rdi            ; status code 0
    syscall                 ; make the syscall

