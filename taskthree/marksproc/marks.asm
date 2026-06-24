; Marks processor for BIT4220
; Computes total, average, highest, lowest, and grade categories.

section .data
marks db 35,40,70,80,55,90,39,100,67,45
count equ 10
failLabel db 'Fail: ', 0
failLabelLen equ $-failLabel-1
passLabel db 'Pass: ', 0
passLabelLen equ $-passLabel-1
creditLabel db 'Credit: ', 0
creditLabelLen equ $-creditLabel-1
distLabel db 'Distinction: ', 0
distLabelLen equ $-distLabel-1
totalLabel db 'Total = ', 0
totalLabelLen equ $-totalLabel-1
avgLabel db 'Average = ', 0
avgLabelLen equ $-avgLabel-1
highLabel db 'Highest = ', 0
highLabelLen equ $-highLabel-1
lowLabel db 'Lowest = ', 0
lowLabelLen equ $-lowLabel-1
newline db 10, 0

section .bss
total resd 1
highest resd 1
lowest resd 1
failCount resd 1
passCount resd 1
creditCount resd 1
distCount resd 1
avgTenths resd 1
printBuf resb 32

section .text
global _start
_start:
    xor eax, eax
    mov [total], eax
    mov eax, 0x80000000
    mov [highest], eax
    mov eax, 0x7fffffff
    mov [lowest], eax
    xor eax, eax
    mov [failCount], eax
    mov [passCount], eax
    mov [creditCount], eax
    mov [distCount], eax

    xor rbx, rbx
.loop:
    cmp rbx, count
    je .compute
    movzx eax, byte [marks + rbx]
    add [total], eax
    mov edx, [highest]
    cmp eax, edx
    jle .skip_high
    mov [highest], eax
.skip_high:
    mov edx, [lowest]
    cmp eax, edx
    jge .skip_low
    mov [lowest], eax
.skip_low:
    cmp eax, 40
    jl .is_fail
    cmp eax, 50
    jl .is_pass
    cmp eax, 70
    jl .is_credit
    inc dword [distCount]
    jmp .next_mark
.is_credit:
    inc dword [creditCount]
    jmp .next_mark
.is_pass:
    inc dword [passCount]
    jmp .next_mark
.is_fail:
    inc dword [failCount]
.next_mark:
    inc rbx
    jmp .loop

.compute:
    mov eax, [total]
    mov ebx, count
    mov ecx, 10
    imul eax, ecx
    cdq
    idiv ebx
    mov [avgTenths], eax

    lea rsi, [totalLabel]
    mov rdx, totalLabelLen
    call write_str
    mov eax, [total]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [avgLabel]
    mov rdx, avgLabelLen
    call write_str
    mov eax, [avgTenths]
    mov ebx, 10
    cdq
    idiv ebx
    call print_decimal
    mov al, '.'
    call print_char
    mov eax, [avgTenths]
    mov ebx, 10
    cdq
    idiv ebx
    mov eax, edx
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [highLabel]
    mov rdx, highLabelLen
    call write_str
    mov eax, [highest]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [lowLabel]
    mov rdx, lowLabelLen
    call write_str
    mov eax, [lowest]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [failLabel]
    mov rdx, failLabelLen
    call write_str
    mov eax, [failCount]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [passLabel]
    mov rdx, passLabelLen
    call write_str
    mov eax, [passCount]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [creditLabel]
    mov rdx, creditLabelLen
    call write_str
    mov eax, [creditCount]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    lea rsi, [distLabel]
    mov rdx, distLabelLen
    call write_str
    mov eax, [distCount]
    call print_decimal
    lea rsi, [newline]
    mov rdx, 1
    call write_str

    mov rax, 60
    xor rdi, rdi
    syscall

write_str:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

print_char:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

print_decimal:
    mov rsi, printBuf
    xor rcx, rcx
    cmp eax, 0
    jne .convert
    mov byte [rsi], '0'
    inc rcx
    jmp .output
.convert:
    mov rbx, rsi
    mov r8, 0
    cmp eax, 0
    jge .conv_loop
    neg eax
    mov r8, 1
.conv_loop:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    mov [rbx + rcx], dl
    inc rcx
    cmp eax, 0
    jne .conv_loop
    cmp r8, 0
    je .reverse
    mov byte [rbx + rcx], '-'
    inc rcx
.reverse:
    mov rdi, rsi
    lea rsi, [rsi + rcx - 1]
.rev_loop:
    cmp rdi, rsi
    jge .output
    mov al, [rdi]
    mov dl, [rsi]
    mov [rdi], dl
    mov [rsi], al
    inc rdi
    dec rsi
    jmp .rev_loop
.output:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall
    ret
