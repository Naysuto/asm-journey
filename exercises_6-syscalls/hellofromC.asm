default abs

extern printf

section .data
	fmt db "Hello %s, you are %d years old!", 10, 0
	name db "Naysuto", 0

section .text
	global main

main:
	; épilogue
	push rbp
	mov rbp, rsp
	sub rsp, 16

	; printf(fmt, name, years)
	lea rdi, [rel fmt]
	lea rsi, [rel name]
	mov rdx, 23
	xor rax, rax
	call printf

	; exit
	leave
	xor rax, rax
	ret
