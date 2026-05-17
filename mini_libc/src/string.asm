default rel

section .text
        global my_strlen
	global my_strcpy

my_strlen:
	xor rax, rax

.strlen_loop:
        cmp byte [rdi + rax], 0
        je .strlen_done
        inc rax
        jmp .strlen_loop

.strlen_done:
        ret

my_strcpy:
	mov rcx, rdi

.strcpy_loop:
	mov al, [rsi]
	mov [rdi], al
	test al, al
	je .strcpy_done

	inc rsi
	inc rdi
	jmp .strcpy_loop

.strcpy_done:
	mov rax, rcx
	ret
