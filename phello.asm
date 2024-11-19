section .data:
	l1 db "hello world" , 1
section .text
	global _start
		_start:
			mov rax ,1
			mov rdi ,1
			mov rsi, l1
			mov rdx, 12
			syscall
			
			mov rax, 60
			xor rdi , rdi
			syscall
			
			
			

