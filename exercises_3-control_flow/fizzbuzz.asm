default abs

section .data
	fizz		db "Fizz", 10
	fizz_len 	equ $ - fizz
	buzz 		db "Buzz", 10
	buzz_len	equ $ - buzz
	fizzbuzz	db "Fizzbuzz",10
	fizzbuzz_len	equ $ - fizzbuzz
	number		db "Number", 10
	number_len	equ $ - number

section .text
	global _start

_start:
	mov r12, 1

.loop:
	cmp r12, 100
	jg .end

	mov rax, r12
	xor rdx, rdx
	mov rbx, 15
	div rbx
	test rdx, rdx
	jnz .check3

	mov rax, 1
	mov rdi, 1
	mov rsi, fizzbuzz
	mov rdx, fizzbuzz_len
	syscall
	jmp .next

.check3:
	mov rax, r12
	xor rdx, rdx
	mov rbx, 3
	div rbx
	test rdx, rdx
	jnz .check5

	mov rax, 1
	mov rdi, 1
	mov rsi, fizz
	mov rdx, fizz_len
	syscall
	jmp .next

.check5:
	mov rax, r12
	xor rdx, rdx
	mov rbx, 5
	div rbx
	test rdx, rdx
	jnz .number

	mov rax, 1
	mov rdi, 1
	mov rsi, buzz
	mov rdx, buzz_len
	syscall
	jmp .next

.number:
	mov rax, 1
	mov rdi, 1
	mov rsi, number
	mov rdx, number_len
	syscall


.next:
	inc r12
	jmp .loop

.end:
	mov rax, 60
	xor rdi, rdi
	syscall
