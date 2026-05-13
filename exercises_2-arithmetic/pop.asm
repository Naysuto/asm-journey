section .text
	global _start

_start:
	mov al, 0XB7
	xor rcx, rcx

.loop:
	test rax, rax
	jz .done
	mov rbx, rax
	dec rbx
	and rax, rbx
	inc rcx
	jmp .loop

.done:
	mov edi, ecx
	mov eax, 60
	syscall

