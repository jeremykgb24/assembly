extern printf
extern scanf
extern system

section .data
    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se creo el arreglo principal del tablero con 100 casillas.
    ; Cada casilla es un solo caracter sin ceros intermedios.
    ; Esto representa una matriz logica de 10x10.
    ;-------------------------------------
    casillas: times 100 db '.'

    clear_cmd   db "clear", 0

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Estos caracteres se dejan listos para cuando se implementen
    ; las serpientes, escaleras y los tres jugadores.
    ; Por ahora no se usan, pero sirven como referencia.
    ;-------------------------------------
    serpiente   db 'S', 0
    escalera    db 'E', 0
    jugador1    db '1', 0
    jugador2    db '2', 0
    jugador3    db '3', 0
    vacio       db '.', 0

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Formatos para dibujar el tablero con caracteres de caja.
    ; Cada linea representa 10 columnas.
    ;-------------------------------------
    fmt_top     db "┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐", 10, 0
    fmt_mid     db "├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤", 10, 0

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Esta linea se agrega para cerrar el tablero por la parte inferior.
    ; Antes el tablero terminaba abierto visualmente, por eso parecia incompleto.
    ;-------------------------------------
    fmt_bottom  db "└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘", 10, 0

    ; Fila con 10 caracteres
    fmt_row     db "│%c│%c│%c│%c│%c│%c│%c│%c│%c│%c│", 10, 0

    msg_enter   db 10, "Presiona ENTER para tirar el dado...", 10, 0
    fmt_char    db "%c", 0
    msg_dado    db 10, "Valor del dado: %d", 10, 0

section .bss
    tecla       resb 1

section .text
    global main

;====================================================
;               FUNCION PRINCIPAL
;====================================================
main:
    push    ebp
    mov     ebp, esp

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se limpia el tablero llenandolo con puntos.
    ; Esto asegura que todas las casillas inician vacias
    ; antes de colocar jugadores o elementos del juego.
    ;-------------------------------------
    mov     ecx, 100
    mov     edi, casillas
    mov     al, '.'
    rep stosb

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se coloca el jugador 1 en la esquina inferior izquierda.
    ; Se usa la formula fila*10 + columna.
    ; Fila 9, columna 0 -> 9*10 + 0 = indice 90.
    ;-------------------------------------
    mov     byte [casillas + 90], '1'

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se limpia la pantalla con el comando "clear"
    ; para que el tablero aparezca sin basura visual.
    ;-------------------------------------
    push    clear_cmd
    call    system
    add     esp, 4

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se imprime la linea superior del tablero.
    ; Esta linea corresponde a las 10 columnas horizontales.
    ;-------------------------------------
    push    fmt_top
    call    printf
    add     esp, 4

    xor     esi, esi        ; esi = numero de fila (0..9)

;====================================================
;            IMPRESION DE LAS 10 FILAS
;====================================================
print_filas:
    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se calcula la base de la fila en el arreglo lineal.
    ; base = fila * 10
    ;-------------------------------------
    mov     eax, esi
    mov     ebx, 10
    mul     ebx             ; eax = fila * 10
    mov     edx, eax        ; edx = base de la fila

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se van empujando las 10 casillas de la fila como caracteres.
    ; Se usa %c por cada casilla para no depender de cadenas con 0.
    ;-------------------------------------
    mov     ecx, 9          ; columnas 9..1 en el loop

push_cols:
    mov     eax, edx
    add     eax, ecx        ; base + columna
    movzx   ebx, byte [casillas + eax]
    push    ebx
    loop    push_cols

    ; columna 0 (la que falta despues del loop)
    mov     eax, edx
    movzx   ebx, byte [casillas + eax]
    push    ebx

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se imprime la fila completa del tablero con sus 10 casillas.
    ;-------------------------------------
    push    fmt_row
    call    printf
    add     esp, 4 + 10*4       ; formato + 10 argumentos

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Si no es la ultima fila, se imprime la linea de separacion.
    ; Esto marca claramente las 10 filas verticales.
    ;-------------------------------------
    cmp     esi, 9
    je      skip_mid_line

    push    fmt_mid
    call    printf
    add     esp, 4

skip_mid_line:
    inc     esi
    cmp     esi, 10
    jl      print_filas

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Despues de imprimir las 10 filas se cierra el tablero
    ; con la linea inferior. Ahora el tablero se ve como un
    ; marco completo de 10x10.
    ;-------------------------------------
    push    fmt_bottom
    call    printf
    add     esp, 4

    ;================================================
    ;          PAUSA Y LANZAMIENTO DEL DADO
    ;================================================
    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se muestra un mensaje para que el usuario presione ENTER
    ; antes de lanzar el dado, simulando un turno real.
    ;-------------------------------------
    push    msg_enter
    call    printf
    add     esp, 4

    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Se usa rdtsc para generar un numero pseudoaleatorio.
    ; Luego se aplica modulo 6 y se suma 1 para limitar
    ; el resultado al rango de un dado (1 a 6).
    ;-------------------------------------
    rdtsc
    mov     ebx, 6
    xor     edx, edx
    div     ebx              ; EAX / 6, resto en EDX

    mov     eax, edx         ; 0..5
    add     eax, 1           ; 1..6

    push    eax
    push    msg_dado
    call    printf
    add     esp, 8

    ;-------------------------------------
    ; Trever
    ; Comentario:
    ; Finaliza el programa limpiamente usando leave y ret.
    ;-------------------------------------
    mov     eax, 0
    leave
    ret
