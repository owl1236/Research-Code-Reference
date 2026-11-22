BITS 32
org 0x05430000

    db 0x7F, "ELF"           ; ELF magic
    dd 1                      ; ELFCLASS32 and padding
    dd 0
    dd $$                     ; load address

    dw 2                      ; e_type = executable
    dw 3                      ; e_machine = i386
    dd _start                 ; also overlaps program-header fields
    dw _start - $$            ; completes e_entry

_start:
    inc ebx                   ; stdout = 1
    add eax, strict dword 4   ; sys_write = 4
    mov ecx, msg              ; message address
    mov dl, 13                ; message length
    int 0x80

    and eax, 0x10020
    xchg eax, ebx             ; sys_exit, status 0
    int 0x80

msg:
    db "hello, world", 10
