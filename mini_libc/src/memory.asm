default rel

section .text
	global my_memcmp
	global my_memset
	global my_memcpy
	global my_strncmp
	global my_strchr

my_memcmp:

.memcmp_loop:
        test rdx, rdx                   ; test pour savoir si rdx vaut 0
        je .memcmp_done                 ; si c'est le cas, on termine la boucle

        movzx eax, byte [rdi]           ; on charge les deux octets
        movzx r8d, byte [rsi]
        cmp eax, r8d                    ; on les comparent ensemble
        jne .different                  ; si différents, on retourne eax - r8d

        inc rdi                         ; on incrémente pour afficher le 2nd octet
        inc rsi
        dec rdx                         ; et on décrémente pour faire en sorte que rdx atteigne 0 quand les deux sont comparés
        jmp .memcmp_loop                ; on recommence la boucle

.different:
        sub eax, r8d
        ret

.memcmp_done:
        xor eax, eax
        ret

my_memset:
	push r12
	mov r12, rdi
	push r13
	xor r13, r13

.memset_loop:
	test rdx, rdx
	jz .memset_done

	cmp r13, rdx
	jae .memset_done

	mov byte [r12 + r13], sil
	inc r13
	jmp .memset_loop

.memset_done:
	mov rax, r12
	pop r13
	pop r12
	ret

my_memcpy:
	push r12
	mov r12, rdi
	xor rcx, rcx

.memcpy_loop:
	cmp rcx, rdx
	jae .memcpy_done

	mov al, [rsi + rcx]
	mov byte [r12 + rcx], al

	inc rcx
	jmp .memcpy_loop

.memcpy_done:
	mov rax, r12
	pop r12
	ret

my_strncmp:
	xor rcx, rcx

.strncmp_loop:
	cmp rcx, rdx
	jae .strncmp_done

	mov al, [rdi + rcx]
	cmp al, [rsi + rcx]
	jne .strncmp_different

	test al, al
	jz .strncmp_done

	inc rcx
	jmp .strncmp_loop

.strncmp_different:
	movzx eax, al
	movzx ecx, byte [rsi + rcx]
	sub eax, ecx
	ret

.strncmp_done:
	xor rax, rax
	ret

my_strchr:
	xor rcx, rcx

.strchr_loop:
	mov al, byte [rdi + rcx]
	cmp al, sil
	je .strchr_done
	test al, al
	jz .strchr_null

	inc rcx
	jmp .strchr_loop

.strchr_null:
	xor rax, rax
	ret

.strchr_done:
	lea rax, [rdi + rcx]
	ret
