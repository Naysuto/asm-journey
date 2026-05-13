default abs

section .data
	path db "/etc/passwd", 0

section .bss
	buf resb 4096

section .text
	global _start

_start:
	; --- open(path, 0_RDONLY) ---
	mov rax, 2
	mov rdi, path
	xor rsi, rsi
	xor rdx, rdx
	syscall

	mov r12, rax

	; --- read(fd, buf, 4096) ---
	mov rax, 0
	mov rdi, r12
	mov rsi, buf
	mov rdx, 4096
	syscall

	mov r13, rax

	; --- write(1, buf, r13) ---
	mov rax, 1
	mov rdi, 1
	mov rsi, buf
	mov rdx, r13
	syscall

	; --- close(fd) ---
	mov rax, 3
	mov rdi, r12
	syscall

	; --- exit(0) ---
	mov rax, 60
	xor rdi, rdi
	syscall
