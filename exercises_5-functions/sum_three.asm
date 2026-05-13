default abs

section .text
	global _start

_start:
	mov rdi, 10
	mov rsi, 20
	mov rdx, 30
	call sum_three

	mov rdi, rax
	mov rax, 60
	syscall

sum_three:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov [rbp - 8], rdi
	add [rbp - 8], rsi
	add [rbp - 8], rdx
	mov rax, [rbp - 8]

	leave
	ret
