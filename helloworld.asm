section .data
    hello db 'Hello World', 0     ; null-terminated string

section .text
    global _start

_start:
    ; write(1, hello, 12)
    mov rax, 1                    ; syscall number for sys_write
    mov rdi, 1                    ; file descriptor 1 is stdout
    mov rsi, hello                ; address of string to output
    mov rdx, 12                   ; number of bytes
    syscall                       ; call kernel

    ; exit(0)
    mov rax, 60                   ; syscall number for sys_exit
    xor rdi, rdi                  ; exit code 0
    syscall                       ; call kernel

