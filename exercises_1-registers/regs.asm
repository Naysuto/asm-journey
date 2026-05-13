section .text
	global _start

_start:
	mov rax, 10
	mov rbx, 20
	mov rcx, 30
	mov rdx, 40
	mov rsi, 50

	mov rdi, rax
	add rdi, rbx
	add rdi, rcx
	add rdi, rdx
	add rdi, rsi
	lea rdi, [rdi - 8]

	mov rax, 60
	syscall
