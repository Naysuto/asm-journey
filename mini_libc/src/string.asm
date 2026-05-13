default rel

section .text
        global my_strlen
	global my_strcpy
	global my_memcmp

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

my_memcmp:

.memcmp_loop:
	test rdx, rdx			; test pour savoir si rdx vaut 0
	je .memcmp_done			; si c'est le cas, on termine la boucle

	movzx eax, byte [rdi]		; on charge les deux octets
	movzx r8d, byte [rsi]
	cmp eax, r8d			; on les comparent ensemble
	jne .different			; si différents, on retourne eax - r8d

	inc rdi				; on incrémente pour afficher le 2nd octet
	inc rsi
	dec rdx				; et on décrémente pour faire en sorte que rdx atteigne 0 quand les deux sont comparés
	jmp .memcmp_loop		; on recommence la boucle

.different:
	sub eax, r8d
	ret

.memcmp_done:
	xor eax, eax
	ret
