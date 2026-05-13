default abs

section .text
	global _start

_start:
	mov rax, 10
	mov rbx, 20
	mov rcx, 30

	push rax
	push rbx
	push rcx

	pop rax
	pop rbx
	pop rcx

	mov rdi, rcx
	mov rax, 60
	syscall
