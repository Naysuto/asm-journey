default abs

section .data
	a db "Hello!", 0
	b db "Helo!", 0

section .text
	global _start

_start:
	mov rsi, a
	mov rdi, b
	mov rcx, 5
	xor r12, r12

.loop:
	cmp r12, rcx
	jge .equal

	mov al, [rsi + r12]
	mov bl, [rdi + r12]
	cmp al, bl
	jne .different

	inc r12
	jne .loop

.equal:
	mov rdi, 0
	jmp .done

.different:
	mov rdi, 1

.done:
	mov rax, 60
	syscall
