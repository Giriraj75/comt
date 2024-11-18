section .bss
    input_num1    resb 5        ; Reserve 5 bytes for the first number input as a string
    input_num2    resb 5        ; Reserve 5 bytes for the second number input as a string
    output_result  resb 20       ; Reserve 20 bytes for the result string

section .data
    prompt_num1   db 'Enter first number: ', 0    ; Prompt for first number
    prompt_num2   db 'Enter second number: ', 0    ; Prompt for second number
    msg_result     db 'Result: ', 0                 ; Message before displaying result
    newline_char   db 0xA                             ; New line character
    divisor_ten    dq 10                              ; Constant ten for division

%macro scall 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .text
    global _start

_start:
    scall 1, 1, prompt_num1, 20   ; Print prompt message for first number
    scall 0, 0, input_num1, 5      ; Read the first number

    call str_to_int                 ; Convert the first number to integer
    mov rbx, rax                    ; Store in register rbx

    scall 1, 1, prompt_num2, 20    ; Print prompt message for second number
    scall 0, 0, input_num2, 5      ; Read the second number

    call str_to_int                 ; Convert the second number to integer
    mov rcx, rax                    ; Store in register rcx

    xor rdx, rdx                    ; Clear rdx to prepare for multiplication

multiply:
    cmp rcx, 0                      ; Check if rcx is zero
    je done                          ; Jump to done if rcx is zero
    add rdx, rbx                    ; Add rbx (first number) to rdx
    dec rcx                         ; Decrement rcx
    jmp multiply                     ; Repeat

done:
    mov rax, rdx                    ; Move the result into rax
    call int_to_str                 ; Convert the result to string

    scall 1, 1, msg_result, 8       ; Print result message
    scall 1, 1, output_result, 20    ; Print the converted result
    scall 1, 1, newline_char, 1      ; Print new line character

    mov rax, 60                      ; Exit syscall
    xor rdi, rdi                     ; Exit code 0
    syscall

str_to_int:
    xor rax, rax                    ; Clear rax for the accumulated integer
    xor rdi, rdi                    ; Clear rdi for the index

next_digit:
    mov dl, [rsi + rdi]             ; Load the next character
    cmp dl, 0xA                     ; Check for the end of string (newline)
    je done_conv                    ; If newline, finish conversion
    sub dl, '0'                     ; Convert ASCII to integer
    imul rax, rax, 10               ; Multiply current result by 10
    add rax, rdx                    ; Add the new digit
    inc rdi                         ; Move to the next character
    jmp next_digit                  ; Loop to process the next digit

done_conv:
    ret                              ; Return from function

int_to_str:                         ; Convert integer in rax to string
    mov rbx, 0                      ; Digit count
    mov rdi, output_result + 19     ; Point to the end of the result buffer
    mov byte [rdi], 0               ; Null-terminate the string
    dec rdi                          ; Move back for writing

    test rax, rax                    ; Check if rax is zero
    jz int_zero                      ; If zero, jump to zero handling

int_loop:
    xor rdx, rdx                    ; Clear rdx for division
    div qword [divisor_ten]         ; Divide rax by ten
    add dl, '0'                     ; Convert remainder to ASCII
    mov [rdi], dl                   ; Store ASCII digit
    dec rdi                          ; Move back
    inc rbx                          ; Increment digit count
    test rax, rax                    ; Check if there are more digits
    jnz int_loop                     ; If not zero, loop again

jmp int_done

int_zero:
    mov byte [rdi], '0'             ; Handle the zero case
    dec rdi                          ; Move back
    inc rbx                          ; Increment for the zero digit

int_done:
    mov rsi, rdi                     ; Set rsi to the position of the first digit
    inc rsi                          ; Move forward for the correct string output
    ret                               ; Return from the conversion function
