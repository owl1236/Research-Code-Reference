global _start
section .text
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 14
    int 0x80
    mov eax, 1
    xor ebx, ebx
    int 0x80
msg: db 'Hello, World!', 0xa

