default abs

section .bss
	buf 	resb 64
	out_buf resb 32

section .text
	global _start

_start:
	; ---- read (0, buf, 64) ---
	mov rax, 0	; syscall(read)
	mov rdi, 0	; fd = stdin
	mov rsi, buf	; ptr buf
	mov rdx, 64	; 64o max
	syscall

	; --- parse num1 ---
	mov rsi, buf
	xor rax, rax

.parse1:
	movzx rcx, byte [rsi]

	cmp cl, '0'
	jb .num1_done

	cmp cl, '9'
	ja .num1_done

	sub cl, '0'
	imul rax, rax, 10
	add rax, rcx
	inc rsi
	jmp .parse1

.num1_done:
	mov r12, rax

.skip_space1:
	movzx rcx, byte [rsi]
	cmp cl, ' '
	jne .operand
	inc rsi
	jmp .skip_space1

.operand:
	movzx r13, byte [rsi]
	inc rsi

.skip_space2:
        movzx rcx, byte [rsi]
        cmp cl, ' '
        jne .parse2_init
        inc rsi
        jmp .skip_space2

.parse2_init:
	xor rax, rax

.parse2:
        movzx rcx, byte [rsi]

        cmp cl, '0'
        jb .num2_done

        cmp cl, '9'
        ja .num2_done

        sub cl, '0'
        imul rax, rax, 10
        add rax, rcx
        inc rsi
        jmp .parse2

.num2_done:
        mov r14, rax

.calcul:
	cmp r13, '+'
	je .add
	cmp r13, '-'
	je .sub
	cmp r13, '*'
	je .imul
	cmp r13, '/'
	je .div

	mov rdi, 255
	mov rax, 60
	syscall

.add:
	mov r15, r12
	add r15, r14
	jmp .itoa

.sub:
	mov r15, r12
	sub r15, r14
	jmp .itoa

.imul:
	mov r15, r12
	imul r15, r14
	jmp .itoa

.div:
	mov rax, r12
	xor rdx, rdx
	div r14
	mov r15, rax
	jmp .itoa

.itoa:
	lea rdi, [out_buf + 32]
	test r15, r15
	jnz .itoa_loop

	dec rdi
	mov byte [rdi], '0'
	jmp .itoa_done

.itoa_loop:
	test r15, r15
	jz .itoa_done

	mov rax, r15
	xor rdx, rdx
	mov rcx, 10
	div rcx

	add dl, '0'
	dec rdi
	mov [rdi], dl

	mov r15, rax
	jmp .itoa_loop

.itoa_done:
	mov rsi, rdi
	lea rdx, [out_buf + 32]
	sub rdx, rdi

	; --- write(1, buf, rax) ---
	mov rax, 1	; syscall(write)
	mov rdi, 1	; fd = stdout
	syscall

	; --- newline ---
	mov byte [out_buf], 10
	mov rax, 1
	mov rdi, 1
	mov rsi, out_buf
	mov rdx, 1
	syscall

	; ---exit(0) ---
	mov rax, 60
	xor rdi, rdi
	syscall
