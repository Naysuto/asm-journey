default rel

section .bss
	buf	resb 4096

section .text
	global _start

_start:
	mov rdi, [rsp + 16]
	xor rsi, rsi
	xor rdx, rdx
	mov rax, 2
	syscall

	mov r12, rax

.loop:
	; read
	mov rax, 0
	mov rdi, r12
	mov rsi, buf
	mov rdx, 4096
	syscall

	mov r13, rax

	test rax, rax
	jz .end

	mov rdx, r13

	mov rax, 1
	mov rdi, 1
	mov rsi, buf
	syscall

	jmp .loop

.end:
	mov rax, 3
	mov rdi, r12
	syscall

	xor rdi, rdi
	mov rax, 60
	syscall
