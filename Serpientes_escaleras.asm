
extern printf
extern scanf
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

    msg_enter  db 'Presiona ENTER para lanzar el dado...',10,0
    msg_dado   db 'Dado: %s',10,0
    fmt_char   db ' %c',0                    

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

section .bss
    tecla resb 1                  ;para leer ENTER
section .text
global main

main:
    push ebp
    mov  ebp, esp

    ;  colocar al jugador 1 en casilla 1
    mov byte [casillas + 180], '1'

   
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


    push dword msg_enter        ;pedir enter
    call printf
    add  esp, 4
    

    lea  eax, [tecla]
    push eax
    push dword fmt_char
    call scanf
    add  esp, 8

     
    rdtsc                 
    mov  edx, 0
    mov  ebx, 6
    div  ebx              
    mov  eax, edx         
    add  eax, 1           

    ; convertir a texto en 'texto_dado'
    mov  bl, al
    add  bl, '0'          ; '1'..'6'
    mov  [texto_dado], bl
    mov  byte [texto_dado+1], 0

    ; mostrar resultado del dado
    push dword texto_dado
    push dword msg_dado
    call printf
    add  esp, 8

    xor eax, eax
    leave
    ret
