extern printf
extern scanf
extern system

section .data
    ;-------------------------------------
    ; Comentario:
    ; Arreglo principal del tablero con 100 casillas.
    ; Cada casilla es un solo caracter, esto representa
    ; una matriz logica de 10x10.
    ;-------------------------------------
    casillas: times 100 db '.'

    clear_cmd   db "clear", 0

    ;-------------------------------------
    ; Comentario:
    ; Caracteres de referencia para el juego.
    ;-------------------------------------
    serpiente   db 'S', 0
    escalera    db 'E', 0
    jugador1_c  db '1', 0
    jugador2_c  db '2', 0
    jugador3_c  db '3', 0
    vacio       db '.', 0

    ;-------------------------------------
    ; Comentario:
    ; Formatos para dibujar el tablero con caracteres
    ; de caja. Cada linea tiene espacio para 10 columnas.
    ;-------------------------------------
    fmt_top     db "┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐", 10, 0
    fmt_mid     db "├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤", 10, 0
    fmt_bottom  db "└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘", 10, 0
    fmt_row     db "│%c│%c│%c│%c│%c│%c│%c│%c│%c│%c│", 10, 0

    ;-------------------------------------
    ; Comentario:
    ; Mensajes e inputs para interactuar con el usuario.
    ;-------------------------------------
    msg_pedir_jug   db 10, "Cuantos jugadores van a jugar? (1-3): ", 0
    msg_turno       db 10, "Turno del jugador %d de %d", 10, 0
    msg_enter       db 10, "Presiona ENTER para tirar el dado...", 10, 0
    msg_dado        db 10, "Valor del dado: %d", 10, 0

    fmt_char    db "%c", 0
    fmt_int     db "%d", 0

section .bss
    ;-------------------------------------
    ; Comentario:
    ; Variables para el numero de jugadores, posiciones,
    ; contadores de turnos y ultimo valor de dado.
    ;-------------------------------------
    num_jugadores   resd 1
    pos_j1          resd 1
    pos_j2          resd 1
    pos_j3          resd 1

    turnos_j1       resd 1
    turnos_j2       resd 1
    turnos_j3       resd 1

    valor_dado      resd 1
    tecla           resb 1

section .text
    global main

;====================================================
;               FUNCION PRINCIPAL
;====================================================
main:
    push    ebp
    mov     ebp, esp

    ;-------------------------------------
    ; Comentario:
    ; Se pide al usuario la cantidad de jugadores.
    ; Si el usuario pone un valor fuera de rango,
    ; se ajusta a un minimo de 1 y maximo de 3.
    ;-------------------------------------
    push    msg_pedir_jug
    call    printf
    add     esp, 4

    lea     eax, [num_jugadores]
    push    eax
    push    fmt_int
    call    scanf
    add     esp, 8

    mov     eax, [num_jugadores]
    cmp     eax, 1
    jge     .check_max
    mov     dword [num_jugadores], 1
    jmp     .validado

.check_max:
    cmp     eax, 3
    jle     .validado
    mov     dword [num_jugadores], 3

.validado:
    ;-------------------------------------
    ; Comentario:
    ; Se inicializan las posiciones de los jugadores en 1.
    ; Todos empiezan en la casilla 1 segun el enunciado.
    ; Tambien se limpian los contadores de turnos.
    ;-------------------------------------
    mov     dword [pos_j1], 1
    mov     dword [pos_j2], 1
    mov     dword [pos_j3], 1

    mov     dword [turnos_j1], 0
    mov     dword [turnos_j2], 0
    mov     dword [turnos_j3], 0

    ;-------------------------------------
    ; Comentario:
    ; Se dibuja por primera vez el tablero con los jugadores
    ; en sus posiciones iniciales.
    ;-------------------------------------
    call    dibujar_tablero

    ;-------------------------------------
    ; Comentario:
    ; Se realiza una ronda de turnos: cada jugador
    ; tira el dado y se mueve una vez.
    ;-------------------------------------
    mov     ebx, 1                      ; jugador actual = 1
    mov     ecx, [num_jugadores]        ; total de jugadores

bucle_jugadores:
    cmp     ebx, ecx
    jg      fin_ronda                   ; si jugador actual > num_jugadores, termina

    ;-------------------------------------
    ; Comentario:
    ; Mensaje que indica de quien es el turno.
    ;-------------------------------------
    push    ecx                         ; segundo parametro: total jugadores
    push    ebx                         ; primer parametro: numero de jugador
    push    msg_turno
    call    printf
    add     esp, 12

    ;-------------------------------------
    ; Comentario:
    ; Se solicita al usuario que presione ENTER
    ; para simular el lanzamiento del dado.
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
    ; Comentario:
    ; Lanzamiento del dado usando rdtsc como fuente
    ; pseudoaleatoria. Se limita el resultado al rango 1..6.
    ;-------------------------------------
    rdtsc
    mov     edi, 6
    xor     edx, edx
    div     edi                ; EAX / 6, resto en EDX

    mov     eax, edx           ; 0..5
    add     eax, 1             ; 1..6
    mov     [valor_dado], eax  ; guardar el valor real del dado

    ; Mostrar el valor del dado
    push    eax
    push    msg_dado
    call    printf
    add     esp, 8

    ;-------------------------------------
    ; Comentario:
    ; Se actualiza la posicion del jugador actual
    ; sumando el valor del dado guardado.
    ;-------------------------------------
    cmp     ebx, 1
    je      mover_j1
    cmp     ebx, 2
    je      mover_j2
    cmp     ebx, 3
    je      mover_j3
    jmp     despues_movimiento

mover_j1:
    mov     eax, [valor_dado]
    mov     edx, [pos_j1]
    add     edx, eax
    cmp     edx, 100
    jle     .ok1
    mov     edx, 100
.ok1:
    mov     [pos_j1], edx
    mov     esi, [turnos_j1]
    inc     esi
    mov     [turnos_j1], esi
    jmp     despues_movimiento

mover_j2:
    mov     eax, [valor_dado]
    mov     edx, [pos_j2]
    add     edx, eax
    cmp     edx, 100
    jle     .ok2
    mov     edx, 100
.ok2:
    mov     [pos_j2], edx
    mov     esi, [turnos_j2]
    inc     esi
    mov     [turnos_j2], esi
    jmp     despues_movimiento

mover_j3:
    mov     eax, [valor_dado]
    mov     edx, [pos_j3]
    add     edx, eax
    cmp     edx, 100
    jle     .ok3
    mov     edx, 100
.ok3:
    mov     [pos_j3], edx
    mov     esi, [turnos_j3]
    inc     esi
    mov     [turnos_j3], esi

despues_movimiento:
    ;-------------------------------------
    ; Comentario:
    ; Despues de mover al jugador se vuelve a dibujar
    ; el tablero para reflejar las nuevas posiciones.
    ;-------------------------------------
    call    dibujar_tablero

    inc     ebx
    jmp     bucle_jugadores

fin_ronda:
    ;-------------------------------------
    ; Comentario:
    ; Por ahora el programa termina despues de una ronda
    ; de turnos. Mas adelante aqui se agregara la logica
    ; de victoria y reinicio de partida.
    ;-------------------------------------
    mov     eax, 0
    leave
    ret

;====================================================
; Funcion: convertir_pos_a_indice
; Entrada: eax = posicion logica (1..100)
; Salida:  eax = indice en el arreglo casillas (0..99)
;====================================================
convertir_pos_a_indice:
    ;-------------------------------------
    ; Comentario:
    ; Convierte una posicion de juego (1 a 100)
    ; al indice real dentro del arreglo lineal casillas.
    ; La casilla 1 se ubica en la esquina inferior izquierda,
    ; y la 100 en la esquina superior derecha.
    ;-------------------------------------
    push    ebx
    push    ecx
    push    edx

    dec     eax             ; pos 1..100 -> 0..99
    mov     ebx, 10
    xor     edx, edx
    div     ebx             ; eax = fila desde abajo (0..9), edx = columna (0..9)

    ; fila_desde_abajo = eax
    ; fila_arriba = 9 - fila_desde_abajo
    mov     ecx, 9
    sub     ecx, eax        ; ecx = fila_arriba

    ; indice = fila_arriba * 10 + columna
    mov     eax, ecx
    mov     ebx, 10
    mul     ebx             ; eax = fila_arriba * 10
    add     eax, edx        ; eax = indice final

    pop     edx
    pop     ecx
    pop     ebx
    ret

;====================================================
; Funcion: dibujar_tablero
; Dibuja el tablero 10x10 con los jugadores en sus
; posiciones actuales.
;====================================================
dibujar_tablero:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi

    ;-------------------------------------
    ; Comentario:
    ; Se limpia la pantalla para que cada dibujo del tablero
    ; se vea fresco sin basura de impresiones anteriores.
    ;-------------------------------------
    push    clear_cmd
    call    system
    add     esp, 4

    ;-------------------------------------
    ; Comentario:
    ; Se llena el arreglo casillas con puntos para
    ; representar casillas vacias antes de colocar
    ; a los jugadores.
    ;-------------------------------------
    mov     ecx, 100
    mov     edi, casillas
    mov     al, '.'
    rep stosb

    ;-------------------------------------
    ; Comentario:
    ; Se colocan las fichas de los jugadores en el
    ; arreglo casillas segun su posicion actual.
    ;-------------------------------------

    ; Jugador 1
    mov     eax, [pos_j1]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '1'

    ; Jugador 2 (solo si hay al menos 2 jugadores)
    mov     eax, [num_jugadores]
    cmp     eax, 2
    jl      .skip_j2
    mov     eax, [pos_j2]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '2'
.skip_j2:

    ; Jugador 3 (solo si hay 3 jugadores)
    mov     eax, [num_jugadores]
    cmp     eax, 3
    jl      .skip_j3
    mov     eax, [pos_j3]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '3'
.skip_j3:

    ;-------------------------------------
    ; Comentario:
    ; Se dibuja la linea superior del tablero.
    ;-------------------------------------
    push    fmt_top
    call    printf
    add     esp, 4

    xor     esi, esi        ; fila = 0 (fila superior)

print_filas_tablero:
    ; base = fila * 10
    mov     eax, esi
    mov     ebx, 10
    mul     ebx             ; eax = fila * 10
    mov     edx, eax        ; edx = base

    ; columnas 9..1 en el loop
    mov     ecx, 9

push_cols_tablero:
    mov     eax, edx
    add     eax, ecx
    movzx   ebx, byte [casillas + eax]
    push    ebx
    loop    push_cols_tablero

    ; columna 0
    mov     eax, edx
    movzx   ebx, byte [casillas + eax]
    push    ebx

    ; dibujar la fila
    push    fmt_row
    call    printf
    add     esp, 4 + 10*4

    ; linea media si no es la ultima fila
    cmp     esi, 9
    je      .no_mid_line

    push    fmt_mid
    call    printf
    add     esp, 4

.no_mid_line:
    inc     esi
    cmp     esi, 10
    jl      print_filas_tablero

    ;-------------------------------------
    ; Comentario:
    ; Se dibuja la linea inferior del tablero para cerrar
    ; el marco visualmente.
    ;-------------------------------------
    push    fmt_bottom
    call    printf
    add     esp, 4

    pop     edi
    pop     esi
    pop     ebx
    leave
    ret
