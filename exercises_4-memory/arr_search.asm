default abs

section .data
	arr dq 10, 20, 30, 40, 50	; init de l'array
	arr_count equ 5			; longueur de l'array

section .text
	global _start

_start:
	xor r12, r12			; compteur

.loop:
	cmp r12, 5
	jge .not_found			; si compteur atteint 5 (arr_count), goto exit, sinon continue et incrémente le compteur

	mov rax, [arr + r12*8]
	cmp rax, 99
	je .found

	inc r12
	jmp .loop

.not_found:
	mov rdi, 255
	jmp .end

.found:
	mov rdi, r12

.end:
	mov rax, 60
	syscall
