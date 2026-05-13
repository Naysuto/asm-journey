default abs

section .text
	global _start

_start:
	mov rdi, 6
	mov rsi, 7
	call multiply

	mov rdi, rax
	mov rax, 60
	syscall

multiply:
	mov rax, rdi
	imul rax, rsi
	ret
