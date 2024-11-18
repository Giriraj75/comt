%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	m1 db 10,"Enter 4 digit Hex Number:"
	l1 equ $-m1
	m2 db 10,13,"Equivalent BCD number is:"
	l2 equ $-m2

section .bss
	buf resb 6
	digitcount resb 1
	char_ans resb 4

section .text
global _start

_start:
	scall 01,01,m1,l1
	scall 0,0,buf,5
	call accept_proc
	mov ax,bx
	call h2bproc

	mov rax,60
	mov rdi,0
	syscall

h2bproc:
	mov rbx,0Ah

back:
	xor rdx,rdx
	div rbx
	push dx
	inc byte[digitcount]
	cmp rax,0
	jne back
	
	scall 01,01,m2,12

print_bcd:
	pop dx
	add dl,30h
	mov [char_ans],dl
	scall 01,01,char_ans,1
	dec byte[digitcount]
	jnz print_bcd
	ret

accept_proc:
	xor bx,bx
	mov rcx,4
	mov rsi,buf

next_digit:
	shl bx,04
	mov al,[rsi]
	cmp al,39h
	jbe label1
	sub al,07h
	
label1:
	sub al,30h
	add bx,ax
	inc rsi
	loop next_digit
	ret
