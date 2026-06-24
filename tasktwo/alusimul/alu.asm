; ALU simulator for BIT4220
; Menu-driven arithmetic and bitwise operations with flag output.

section .data
menuMsg db 'ALU Simulator', 10, '1. Add', 10, '2. Subtract', 10, '3. Multiply', 10, '4. Divide', 10
        db '5. AND', 10, '6. OR', 10, '7. XOR', 10, '8. NOT', 10, '9. TEST', 10, '0. Exit', 10, 0
menuLen equ $-menuMsg-1
promptChoice db 'Choice: ', 0
promptChoiceLen equ $-promptChoice-1
promptNumber1 db 'Number 1: ', 0
promptNumber1Len equ $-promptNumber1-1
promptNumber2 db 'Number 2: ', 0
promptNumber2Len equ $-promptNumber2-1
errorDivZero db 'Error: divide by zero', 10, 0
errorDivZeroLen equ $-errorDivZero-1
errorOption db 'Invalid option', 10, 0
errorOptionLen equ $-errorOption-1
resultLabel db 'Result = ', 0
resultLabelLen equ $-resultLabel-1
flagsTemplate db 'CF=0 ZF=0 SF=0 OF=0', 10, 0
flagsTemplateLen equ $-flagsTemplate-1
newline db 10, 0

section .bss
inputBuf resb 32
outputBuf resb 32
flagsBuf resb 22

section .text
global _start
_start:
    jmp menu_loop

menu_loop:
    lea rsi, [menuMsg]
    mov rdx, menuLen
    call write_str

    lea rsi, [promptChoice]
    mov rdx, promptChoiceLen
    call write_str
    call read_int
    mov ebx, eax
    cmp eax, 0
    je exit_program
    cmp eax, 1
    jb invalid_option
    cmp eax, 9
    ja invalid_option

    cmp ebx, 8
    je prompt_not

    lea rsi, [promptNumber1]
    mov rdx, promptNumber1Len
    call write_str
    call read_int
    mov r12, rax

    lea rsi, [promptNumber2]
    mov rdx, promptNumber2Len
    call write_str
    call read_int
    mov r13, rax
    jmp perform_operation

prompt_not:
    lea rsi, [promptNumber1]
    mov rdx, promptNumber1Len
    call write_str
    call read_int
    mov r12, rax
    mov r13, 0
    jmp perform_operation

perform_operation:
    cmp ebx, 1
    je do_add
    cmp ebx, 2
    je do_sub
    cmp ebx, 3
    je do_mul
    cmp ebx, 4
    je do_div
    cmp ebx, 5
    je do_and
    cmp ebx, 6
    je do_or
    cmp ebx, 7
    je do_xor
    cmp ebx, 8
    je do_not
    cmp ebx, 9
    je do_test
    jmp invalid_option

do_add:
    mov rax, r12
    add rax, r13
    jmp finish_op

do_sub:
    mov rax, r12
    sub rax, r13
    jmp finish_op

do_mul:
    mov rax, r12
    imul rax, r13
    jmp finish_op

do_div:
    cmp r13, 0
    je div_by_zero
    mov rax, r12
    cqo
    idiv r13
    jmp finish_op

do_and:
    mov rax, r12
    and rax, r13
    jmp finish_op

do_or:
    mov rax, r12
    or rax, r13
    jmp finish_op

do_xor:
    mov rax, r12
    xor rax, r13
    jmp finish_op

do_not:
    mov rax, r12
    not rax
    jmp finish_op

do_test:
    mov rax, r12
    mov rcx, r13
    test rax, rcx
    xor rax, rax
    jmp finish_op

div_by_zero:
    lea rsi, [errorDivZero]
    mov rdx, errorDivZeroLen
    call write_str
    jmp menu_loop

invalid_option:
    lea rsi, [errorOption]
    mov rdx, errorOptionLen
    call write_str
    jmp menu_loop

finish_op:
    pushfq
    pop rdx
    call render_flags
    lea rsi, [flagsBuf]
    mov rdx, flagsTemplateLen
    call write_str
    lea rsi, [resultLabel]
    mov rdx, resultLabelLen
    call write_str
    call print_int
    lea rsi, [newline]
    mov rdx, 1
    call write_str
    jmp menu_loop

write_str:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

read_int:
    mov rax, 0
    mov rdi, 0
    lea rsi, [inputBuf]
    mov rdx, 32
    syscall
    mov rcx, rax
    lea rbx, [inputBuf]
    xor rax, rax
    mov r8, 1
    cmp byte [rbx], '-'
    jne .parse_digits
    mov r8, -1
    inc rbx
.parse_digits:
    xor rax, rax
.parse_loop:
    cmp rcx, 0
    je .parse_end
    movzx rdx, byte [rbx]
    cmp rdx, 10
    je .parse_end
    cmp rdx, 13
    je .parse_end
    cmp rdx, '0'
    jl .parse_end
    cmp rdx, '9'
    jg .parse_end
    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rbx
    dec rcx
    jmp .parse_loop
.parse_end:
    cmp r8, 0
    jg .done
    neg rax
.done:
    ret

print_int:
    mov rsi, outputBuf
    xor rcx, rcx
    mov rdx, rax
    cmp rax, 0
    jne .convert
    mov byte [rsi], '0'
    mov rcx, 1
    jmp .output
.convert:
    mov rbx, rsi
    mov r9, 0
    cmp rax, 0
    jge .conv_loop
    neg rax
    mov r9, 1
.conv_loop:
    xor rdx, rdx
    mov rdi, 10
    div rdi
    add dl, '0'
    mov [rbx + rcx], dl
    inc rcx
    cmp rax, 0
    jne .conv_loop
    cmp r9, 0
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

render_flags:
    lea rsi, [flagsTemplate]
    lea rdi, [flagsBuf]
    mov rcx, flagsTemplateLen
    rep movsb
    mov rax, rdx
    test rax, 1
    setnz al
    add al, '0'
    mov [flagsBuf + 3], al
    xor al, al
    test rax, 0x40
    setnz al
    add al, '0'
    mov [flagsBuf + 8], al
    xor al, al
    test rax, 0x80
    setnz al
    add al, '0'
    mov [flagsBuf + 13], al
    xor al, al
    test rax, 0x800
    setnz al
    add al, '0'
    mov [flagsBuf + 18], al
    ret

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
