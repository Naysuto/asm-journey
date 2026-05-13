default abs

section .data
	prog db "/bin/ls", 0
	argv dq prog, 0

section .text
	global _start

_start:
	; --- fork() ---
	mov rax, 57
	syscall

	test rax, rax
	jz .child

	; parent waiting
	mov rax, 61
	mov rdi, -1
	xor rdi, rdi
	xor rsi, rsi
	xor r10, r10
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

.child:
	; --- execve("/bin/ls", argv, NULL) ---
	mov rax, 59
	lea rdi, [rel prog]
	lea rsi, [rel argv]
	xor rdx, rdx
	syscall

	mov rax, 60
	mov rdi, 1
	syscall
