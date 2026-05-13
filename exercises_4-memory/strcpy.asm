default abs

section .data
	src db "Hello!", 0
	src_len equ $ - src -1

	nl db 10

section .bss
	dst resb 64

section .text
	global _start

_start:
	mov rsi, src
	mov rdi, dst

.loop:
	mov al, [rsi]
	mov [rdi], al
	test al, al
	jz .done

	inc rsi
	inc rdi
	jmp .loop

.done:
	mov rax, 1
	mov rdi, 1
	mov rsi, dst
	mov rdx, src_len
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall
