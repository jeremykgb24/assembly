
extern printf
extern system

section .data
    casillas: times 100 db '.', 0

    clear_cmd db 'clear',0

    serpiente db 'S',0
    escalera  db 'E',0
    jugador1  db '1',0
    jugador2  db '2',0
    jugador3  db '3',0
    vacio     db '.',0
    texto_dado db '00',0   ; para guardar el numero del dado como texto

    board_format:
        db '┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤',10
        db '│%s│%s│%s│%s│%s│%s│%s│%s│%s│%s│',10
        db '└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘',10,0

section .text
global main

main:
    push ebp
    mov  ebp, esp

    ;  Colocar al jugador 1 en casilla 1
    mov byte [casillas + 0], '1'

   
    mov ecx, 100          ; total de casillas
    mov esi, casillas
    add esi, 198          ; ultima casilla = (99 * 2)
.push_loop:
    push esi              ; empuja dirección de la celda a printf
    sub  esi, 2
    loop .push_loop

    push board_format
    call printf
    add  esp, 404         ; limpiar la pila (100*4 + 4)


    xor eax, eax
    leave
    ret
