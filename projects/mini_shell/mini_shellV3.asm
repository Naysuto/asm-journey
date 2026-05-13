default rel

section .data
	prompt db "~$ ", 0
	newline db 10, 0

section .bss
	buf resb 4096
	argv resq 64

section .text
	global _start

_start:

.loop:
	; --- print prompt on screen ---
	mov rax, 1
	mov rdi, 1
	lea rsi, [prompt]
	mov rdx, 3
	syscall

	; --- read stdin ---
	mov rax, 0
	mov rdi, 0
	lea rsi, [buf]
	mov rdx, 4096
	syscall

	test rax, rax
	jz .end

	; === TOKENIZER ===
	lea rsi, [buf]
	xor r13, r13

	mov [argv + r13*8], rsi
	inc r13

.tok_loop:
	movzx rax, byte [rsi]

	cmp al, 10
	je .tok_end

	cmp al, ' '
	je .tok_space

	inc rsi
	jmp .tok_loop

.tok_space:
	mov byte [rsi], 0
	inc rsi

.skip_spaces:
	movzx rax, byte [rsi]

	cmp al, ' '
	jne .after_skip

	inc rsi
	jmp .skip_spaces

.after_skip:
	movzx rax, byte [rsi]

	cmp al, 10
	je .tok_end
	cmp al, 0
	je .tok_end

	mov [argv + r13*8], rsi
	inc r13
	inc rsi
	jmp .tok_loop

.tok_end:
	mov byte [rsi], 0
	mov qword [argv + r13*8], 0

	mov rax, 57
	syscall
	test rax, rax
	jz .child

	mov rax, 61
	mov rdi, -1
	xor rsi, rsi
	xor rdx, rdx
	xor r10, r10
	syscall

	jmp .loop

.child:
	mov rax, 59
	mov rdi, [argv]
	lea rsi, [argv]
	xor rdx, rdx
	syscall

	mov rax, 60
	mov rdi, 1
	syscall

.end:
	mov rax, 60
	xor rdi, rdi
	syscall
