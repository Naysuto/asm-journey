section .text
	global _start

_start:
	mov eax, 2
	mov ebx, 4
	mov ecx, 7
	mov edx, 3

	add eax, ebx
	imul eax, ecx
	sub eax, edx

	mov edi, eax
	mov eax, 60
	syscall
