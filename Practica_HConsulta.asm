extern printf
extern scanf
extern system

section .data
    clear_cmd db 'clear',0
    tabla db '123456789', 10, 0
    tabla_formato db ' %c | %c | %c', 10, 
                  db '------------',10,
                  db ' %c | %c | %c', 10,
                  db '------------',10,
                  db ' %c | %c | %c', 10, 0
section .bss
section .text
global main

main:
push clear_cmd
call system
add esp, 4


push tabla
call print_board
add esp, 4


mov eax, 1
xor ebx, ebx
int 0x80



print_board:
    push ebp
    mov ebp, esp
    push esi
    mov esi, [ebp+8]

    push dword [esi+8]
    push dword [esi+7]
    push dword [esi+6]
    push dword [esi+5]
    push dword [esi+4]
    push dword [esi+3]
    push dword [esi+2]
    push dword [esi+1]
    push dword [esi]
    push tabla_formato
    call printf
    add esp, 40

    pop esi
    mov esp, ebp
    pop ebp
    ret
    
    finish: