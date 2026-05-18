default rel

section .text
	global my_putchar
	global my_puts
	global my_printf

my_putchar:
	push rdi

	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	syscall

	pop rdi
	mov rax, rdi
	ret

my_puts:
	push r12
	push r13
	mov r12, rdi

	call my_strlen
	mov r13, rax

	mov rax, 1
	mov rdi, 1
	mov rsi, r12
	mov rdx, r13
	syscall

	mov rdi, 10
	call my_putchar
	mov rax, r13
	inc rax
	pop r13
	pop r12
	ret
