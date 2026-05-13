default rel

extern strlen
extern printf

section .data
	msg db "Hello, World!", 0
	fmt db "Length: %d", 10, 0

section .text
	global main

main:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	lea rdi, [msg]
	call strlen

	mov r12, rax

	lea rdi, [fmt]
	mov rsi, r12
	xor rax, rax
	call printf

	leave
	xor rax, rax
	ret
