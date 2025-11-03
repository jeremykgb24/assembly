extern printf
extern sprintf ;convertir numeros a strings
extern scanf
extern system ;para comandos de la terminal

section .data
    casillas:
        times 100 db '.',0

    clear_cmd db 'clear',0
    serpiente db 'S',0
    escalera db 'E',0
    jugador1 db 'P1',0
    jugador2 db 'P2',0
    jugador3 db 'P3',0
    vacio db '.',0

    num_buf db '00',0

    board_format:
         db '┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10,0
         db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10,0
         db '└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘',10,0,0
                 


section .bss

section .text
global main 

main:
    push ebp
    mov ebp,esp

    mov ecx,100
    mov esi,casillas + 297

.push_loop:
    push esi
    sub esi,3
    loop .push_loop

    push board_format
    call printf
    add esp,404

    pop ebp
    ret