default abs

section .data
	arr dq 10, 20, 30, 40, 50	; init de l'array
	arr_count equ 5			; longueur de l'array

section .text
	global _start

_start:
	xor r12, r12	; compteur
	xor r13, r13 	; somme

.loop:
	cmp r12, 5
	jge .end	; si compteur atteint 5 (arr_count), goto exit, sinon continue et incrémente le compteur

	add r13, [arr + r12*8]

	inc r12
	jmp .loop

.end:
	mov rdi, r13
	mov rax, 60
	syscall
