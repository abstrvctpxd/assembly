section .data
helloMsg db 'Hello BIT4220', 10
helloLen equ $ - helloMsg

section .text
global _start
_start:
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, helloMsg   ; message address
    mov rdx, helloLen   ; message length
    syscall

    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code 0
    syscall
