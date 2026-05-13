default abs

section .bss
	BUF_SIZE equ 64
	buf	resb BUF_SIZE

section .text
	global _start

_start:
	mov rcx, 0

.loop:
	mov byte [buf + rcx], 0x41
	inc rcx
	cmp rcx, BUF_SIZE
	jl .loop

	mov byte [buf], 10
	mov rax, 1
	mov rdi, 1
	mov rsi, buf
	mov rdx, BUF_SIZE
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall
