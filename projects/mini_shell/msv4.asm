default rel

section .data
	prompt	db "~$ ", 0

section .bss
	buf	resb 4096
	argv	resq 64

section .text
	global _start

_start:

.loop:
	; write
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, 3
	syscall

	; read
	mov rax, 0
	mov rdi, 0
	mov rsi, buf
	mov rdx, 4096
	syscall

	test rax, rax
	jz .end

	; TOKENIZER
	mov rsi, buf			; pointeur sur buf
	xor r13, r13			; init & zéroage r13
	mov qword [argv + r13*8], rsi	; stockage du 1er token
	inc r13				; on incrémente pour passer au prochain token après la 1ère boucle

.tok_loop:
	mov al, byte [rsi]		; chargement du premier octet
	cmp al, 10			; comparaison avec newline
	je .tok_end			; si l'octet est une nl, goto tok_end
	cmp al, 0			; comparaison avec NULL
	je .tok_end			; si l'octet est NULL, goto tok_end
	cmp al, 32			; comparaison avec un espace
	je .tok_space			; si l'octet est un espace, goto tok_space

	inc rsi				; on fait avancer le pointeur
	jmp .tok_loop			; puis on recommence la boucle

.tok_space:
	mov byte [rsi], 0
	inc rsi

.skip:
	mov al, byte [rsi]
	cmp al, 32
	jne .after_skip
	inc rsi
	jmp .skip

.after_skip:
	cmp al, 10
	je .tok_end
	cmp al, 0
	je .tok_end

	mov qword [argv + r13*8], rsi
	inc r13
	jmp .tok_loop

.tok_end:
	mov byte [rsi], 0
	mov qword [argv + r13*8], 0	; tableau de pointeurs init avec l'index d'argv

	; --- fork() ---
        mov rax, 57
        syscall
        test rax, rax
        jz .child

        ; --- parent: wait4 ---
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
