default rel

section .text
	global my_atoi
	global my_itoa
	global my_strtol

my_atoi:
	xor rax, rax
	mov rcx, 1

.atoi_skip_spaces:
	cmp byte [rdi], ' '
	jne .atoi_minus
	inc rdi
	jmp .atoi_skip_spaces

.atoi_minus:
	cmp byte [rdi], '-'
	jne .atoi_plus
	inc rdi
	mov rcx, -1
	jmp .atoi_parse

.atoi_plus:
	cmp byte [rdi], '+'
	jne .atoi_parse
	inc rdi

.atoi_parse:
	movzx r8, byte [rdi]
	cmp r8, '0'
	jb .atoi_done
	cmp r8, '9'
	ja .atoi_done

	sub r8, '0'
	imul rax, rax, 10
	add rax, r8
	inc rdi
	jmp .atoi_parse

.atoi_done:
	imul rax, rcx
	ret

my_itoa:
	push r12
	mov r12, rsi
	push r13
	mov r13, rsi
	push r14
	mov r14, rsi
	push r15
	mov r15, rdx
	movsxd rdi, edi

.itoa_loop:
	cmp rdi, 0
	jne .itoa_baseten
	mov byte [r13], '0'
	inc r13
	mov byte [r13], 0
	mov rax, r14
	jmp .itoa_done

.itoa_baseten:
	cmp rdi, 0
	jge .itoa_generate
	cmp rdx, 10
	jne .itoa_generate

	mov byte [r13], '-'
	inc r13
	inc r12
	neg rdi

.itoa_generate:
	test rdi, rdi
	jz .itoa_done
	mov rax, rdi
	xor rdx, rdx
	idiv r15

	cmp rdx, 10
	jl .itoa_addzero
	sub rdx, 10
	add rdx, 'a'
	mov byte [r13], dl
	inc r13
	mov rdi, rax
	jmp .itoa_generate

.itoa_addzero:
	add rdx, '0'
	mov byte [r13], dl
	inc r13
	mov rdi, rax
	jmp .itoa_generate

.itoa_done:
	mov byte [r13], 0
	lea r8, [r12]
	lea r9, [r13 - 1]

.itoa_reverse:
	; inversion buffer
	cmp r8, r9
	jge .itoa_ret

	mov al, byte [r8]
	mov cl, byte [r9]
	mov byte [r8], cl
	mov byte [r9], al

	inc r8
	dec r9
	jmp .itoa_reverse

.itoa_ret:
	mov rax, r14
	pop r15
	pop r14
	pop r13
	pop r12
	ret

my_strtol:
	push r12
	push r13
	push r14
	push r15
	mov r12, rdi
	mov r13, 1
	mov r14, rdx
	xor r15, r15

.strtol_skip_spaces:
	cmp byte [r12], ' '
	jne .strtol_detect_sign
	inc r12
	jmp .strtol_skip_spaces

.strtol_detect_sign:
	cmp byte [r12], '-'
	je .strtol_minus
	cmp byte [r12], '+'
	je .strtol_plus

	cmp r14, 0
	jne .strtol_detect_base
	cmp byte [r12], '0'
	je .strtol_zero_prefix
	mov r14, 10
	jmp .strtol_parse

.strtol_minus:
	neg r13
	inc r12
	jmp .strtol_detect_base

.strtol_plus:
	inc r12

.strtol_detect_base:
	cmp r14, 0
	jne .strtol_skip_prefixes

	cmp byte [r12], '0'
	je .strtol_zero_prefix

	mov r14, 10
	jmp .strtol_parse

.strtol_zero_prefix:
	cmp byte [r12 + 1], 'x'
	mov r14, 16
	je .strtol_skip_prefixes
	cmp byte [r12 + 1], 'X'
	mov r14, 16
	je .strtol_skip_prefixes

	mov r14, 8
	inc r12
	jmp .strtol_parse

.strtol_skip_prefixes:
	cmp r14, 16
	jne .strtol_parse

	cmp byte [r12], '0'
	jne .strtol_parse

	cmp byte [r12 + 1], 'x'
	je .strtol_consume

	cmp byte [r12 + 1], 'X'
        je .strtol_consume

	jmp .strtol_parse

.strtol_consume:
	add r12, 2

.strtol_parse:
	mov al, byte [r12]

	cmp al, '0'
	jb .strtol_endptr
	cmp al, '9'
	jbe .strtol_digit

	cmp al, 'a'
        jb .strtol_endptr
        cmp al, 'z'
        jbe .strtol_low

	cmp al, 'A'
        jb .strtol_endptr
        cmp al, 'Z'
        jbe .strtol_up

	jmp .strtol_endptr

.strtol_digit:
	movzx rcx, al
	sub rcx, '0'
	jmp .strtol_check

.strtol_low:
	movzx rcx, al
	sub rcx, 'a'
	add rcx, 10
	jmp .strtol_check

.strtol_up:
	movzx rcx, al
        sub rcx, 'A'
	add rcx, 10

.strtol_check:
	cmp rcx, r14
	jae .strtol_endptr

	imul r15, r14
	add r15, rcx

	inc r12
	jmp .strtol_parse

.strtol_endptr:
	cmp rsi, 0
	je .strtol_done
	mov [rsi], r12

.strtol_done:
	imul r15, r13
	mov rax, r15
	pop r15
	pop r14
	pop r13
	pop r12
	ret
