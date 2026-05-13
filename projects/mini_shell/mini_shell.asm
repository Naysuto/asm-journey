default rel

section .data
	prog db "/bin/ls", 0
        argv dq prog, 0
	prompt db "~$ ", 0

section .bss
	buf resb 4096
	argv resq 64

section .text
	global _start

_start:

.loop:

	; --- write(1, buf, 4096) / afficher le prompt ---
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt
	mov rdx, 3
	syscall

	; --- read(0, buf, 4096) ---
	mov rax, 0
	mov rdi, 0
	mov rsi, buf
	mov rdx, 4096
	syscall

	test rax, rax		; si rax == 0,
	jz .end			; goto exit (Ctrl+D)
	mov rsi, buf
	jmp .parse_nl

	; --- Find the nl and terminate the string instead ---
.parse_nl:
        movzx rcx, byte [rsi]
	cmp cl, 10
	je .found_nl
        cmp cl, 0
	je .found_nl
	inc rsi
        jmp .parse_nl

.found_nl:
	mov byte [rsi], 0

        lea rax, [buf]
        mov [argv], rax

        ; --- fork() ---
        mov rax, 57
        syscall
        test rax, rax
        jz .child

        ; --- parent waiting 4 the child ---
        mov rax, 61
        mov rdi, -1
        xor rsi, rsi
        xor rdx, rdx
        xor r10, r10
        syscall

        jmp .loop

.child:
	; --- execve() ---
	mov rax, 59
	lea rdi, [buf]
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
