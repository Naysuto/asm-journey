default abs

section .data
	msg	db "Hello, World!", 0

section .text
	global _start

_start:
	mov rdi, msg
	xor rcx, rcx

.loop:
	cmp byte [rdi + rcx], 0
	je .end
	inc rcx
	jmp .loop

.end:
	mov rdi, rcx
	mov rax, 60
	syscall
