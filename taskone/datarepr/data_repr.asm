; Data representation demo for BIT4220
; This program shows how values are stored in memory and how x86-64 uses
; the .data section, string output, and little-endian ordering.

section .data
byteVal     db 65              ; 65 decimal = 0x41 = 'A'
wordVal     dw 1234h           ; 0x1234 stored as 34 12 in memory
hdwordVal   dd 12345678h       ; 0x12345678 stored as 78 56 34 12 in memory

msg1        db 'Byte Value = 65', 10
msg1Len     equ $ - msg1
msg2        db 'ASCII = A', 10
msg2Len     equ $ - msg2
msg3        db 'Word Value = 1234h', 10
msg3Len     equ $ - msg3
msg4        db 'Dword Value = 12345678h', 10
msg4Len     equ $ - msg4
msg5        db 'Little Endian memory bytes for dd 12345678h:', 10
msg5Len     equ $ - msg5
memBytes    db '78 56 34 12', 10
memBytesLen equ $ - memBytes

section .text
global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, msg1Len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, msg2Len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, msg3Len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg4
    mov rdx, msg4Len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg5
    mov rdx, msg5Len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, memBytes
    mov rdx, memBytesLen
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

msg1_end:
msg2_end:
msg3_end:
msg4_end:
msg5_end:
memBytes_end:
