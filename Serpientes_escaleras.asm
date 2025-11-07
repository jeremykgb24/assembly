extern printf
extern scanf
extern system

section .data
    casillas:   times 100 db '.'

    clear_cmd   db "clear", 0

    serpiente   db 'S', 0
    escalera    db 'E', 0
    jugador1_c  db '1', 0
    jugador2_c  db '2', 0
    jugador3_c  db '3', 0
    vacio       db '.', 0

    fmt_top     db "┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐", 10, 0
    fmt_mid     db "├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤", 10, 0
    fmt_bottom  db "└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘", 10, 0
    fmt_row     db "│%c│%c│%c│%c│%c│%c│%c│%c│%c│%c│", 10, 0

    msg_pedir_jug   db 10, "Cuantos jugadores van a jugar? (1-3): ", 0
    msg_turno       db 10, "Turno del jugador %d de %d", 10, 0
    msg_enter       db 10, "Presiona ENTER para tirar el dado...", 10, 0

    msg_ganador     db 10, "El jugador %d ha ganado la partida.", 10, 0
    msg_resumen     db 10, "Resumen de la partida:", 10, 0
    msg_linea_jug   db "Jugador %d: posicion final %d, turnos jugados %d", 10, 0

    msg_turno_info  db 10, "Jugador %d: dado %d, posicion %d, turnos %d", 10, 0

    fmt_char    db "%c", 0
    fmt_int     db "%d", 0

section .bss
    num_jugadores   resd 1
    jugador_actual  resd 1

    pos_j1          resd 1
    pos_j2          resd 1
    pos_j3          resd 1

    turnos_j1       resd 1
    turnos_j2       resd 1
    turnos_j3       resd 1

    valor_dado      resd 1
    ganador         resd 1

    tecla           resb 1

section .text
    global main

;====================================================
; FUNCION PRINCIPAL
;====================================================
main:
    push    ebp
    mov     ebp, esp

    ; pedir numero de jugadores
    push    msg_pedir_jug
    call    printf
    add     esp, 4

    lea     eax, [num_jugadores]
    push    eax
    push    fmt_int
    call    scanf
    add     esp, 8

    ; asegurar rango 1..3
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
    ; inicializar posiciones y turnos
    mov     dword [pos_j1], 1
    mov     dword [pos_j2], 1
    mov     dword [pos_j3], 1

    mov     dword [turnos_j1], 0
    mov     dword [turnos_j2], 0
    mov     dword [turnos_j3], 0

    mov     dword [ganador], 0

;====================================================
; BUCLE PRINCIPAL DE LA PARTIDA
;====================================================
bucle_partida:
    mov     eax, [ganador]
    cmp     eax, 0
    jne     fin_partida

    ; jugador_actual = 1 al inicio de la ronda
    mov     dword [jugador_actual], 1

bucle_turnos:
    ; cargar jugador_actual y total jugadores
    mov     eax, [jugador_actual]   ; eax = jugador actual
    mov     ecx, [num_jugadores]    ; ecx = total jugadores

    ; si jugador_actual > num_jugadores, empezar nueva ronda
    cmp     eax, ecx
    jg      bucle_partida

    ; si ya hay ganador, salir
    mov     edx, [ganador]
    cmp     edx, 0
    jne     fin_partida

    ; guardar el numero de jugador en ESI (constante en este turno)
    mov     esi, eax                ; esi = jugador actual

    ;---------------------------------
    ; INICIO DEL TURNO DEL JUGADOR ESI
    ;---------------------------------

    ; dibujar tablero antes de lanzar dado
    call    dibujar_tablero

    ; mensaje de turno: jugador ESI de ECX
    push    ecx
    push    esi
    push    msg_turno
    call    printf
    add     esp, 12

    ; pedir ENTER
    push    msg_enter
    call    printf
    add     esp, 4

    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    ; lanzar dado 1..6
    rdtsc
    mov     ecx, 6
    xor     edx, edx
    div     ecx               ; eax / 6, resto en edx

    mov     eax, edx          ; 0..5
    add     eax, 1            ; 1..6
    mov     [valor_dado], eax

    ; mover jugador segun ESI
    mov     eax, [valor_dado]

    cmp     esi, 1
    je      mover_j1
    cmp     esi, 2
    je      mover_j2
    jmp     mover_j3

mover_j1:
    mov     edx, [pos_j1]
    add     edx, eax
    cmp     edx, 100
    jle     .ok1
    mov     edx, 100
.ok1:
    mov     [pos_j1], edx
    mov     ebx, [turnos_j1]
    inc     ebx
    mov     [turnos_j1], ebx
    jmp     check_win

mover_j2:
    mov     edx, [pos_j2]
    add     edx, eax
    cmp     edx, 100
    jle     .ok2
    mov     edx, 100
.ok2:
    mov     [pos_j2], edx
    mov     ebx, [turnos_j2]
    inc     ebx
    mov     [turnos_j2], ebx
    jmp     check_win

mover_j3:
    mov     edx, [pos_j3]
    add     edx, eax
    cmp     edx, 100
    jle     .ok3
    mov     edx, 100
.ok3:
    mov     [pos_j3], edx
    mov     ebx, [turnos_j3]
    inc     ebx
    mov     [turnos_j3], ebx

; comprobar si este jugador gano
check_win:
    cmp     esi, 1
    je      check_win_j1
    cmp     esi, 2
    je      check_win_j2
    jmp     check_win_j3

check_win_j1:
    mov     eax, [pos_j1]
    cmp     eax, 100
    jne     despues_movimiento
    mov     dword [ganador], 1
    jmp     despues_movimiento

check_win_j2:
    mov     eax, [pos_j2]
    cmp     eax, 100
    jne     despues_movimiento
    mov     dword [ganador], 2
    jmp     despues_movimiento

check_win_j3:
    mov     eax, [pos_j3]
    cmp     eax, 100
    jne     despues_movimiento
    mov     dword [ganador], 3

despues_movimiento:
    ; dibujar tablero despues de mover
    call    dibujar_tablero

    ; mostrar info del turno: jugador, dado, posicion, turnos
    mov     eax, esi              ; jugador
    mov     edx, [valor_dado]     ; dado

    cmp     esi, 1
    je      info_j1
    cmp     esi, 2
    je      info_j2
    ; jugador 3
    mov     ebx, [pos_j3]
    mov     ecx, [turnos_j3]
    jmp     imprimir_info

info_j1:
    mov     ebx, [pos_j1]
    mov     ecx, [turnos_j1]
    jmp     imprimir_info

info_j2:
    mov     ebx, [pos_j2]
    mov     ecx, [turnos_j2]

imprimir_info:
    ; printf("Jugador %d: dado %d, posicion %d, turnos %d")
    ; args (de derecha a izquierda): turnos (ECX), pos (EBX), dado (EDX), jugador (EAX)
    push    ecx
    push    ebx
    push    edx
    push    eax
    push    msg_turno_info
    call    printf
    add     esp, 20

    ; si ya hay ganador, salir
    mov     eax, [ganador]
    cmp     eax, 0
    jne     fin_partida

    ; siguiente jugador: jugador_actual++
    mov     eax, [jugador_actual]
    inc     eax
    mov     [jugador_actual], eax
    jmp     bucle_turnos

;====================================================
; FIN PARTIDA Y RESUMEN
;====================================================
fin_partida:
    ; mostrar tablero final
    call    dibujar_tablero

    ; mensaje de ganador
    mov     eax, [ganador]
    push    eax
    push    msg_ganador
    call    printf
    add     esp, 8

    ; linea de resumen
    push    msg_resumen
    call    printf
    add     esp, 4

    ; jugador 1
    mov     eax, 1
    mov     ebx, [pos_j1]
    mov     ecx, [turnos_j1]
    push    ecx
    push    ebx
    push    eax
    push    msg_linea_jug
    call    printf
    add     esp, 16

    ; jugador 2 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 2
    jl      skip_j2_resumen
    mov     eax, 2
    mov     ebx, [pos_j2]
    mov     ecx, [turnos_j2]
    push    ecx
    push    ebx
    push    eax
    push    msg_linea_jug
    call    printf
    add     esp, 16
skip_j2_resumen:

    ; jugador 3 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 3
    jl      skip_j3_resumen
    mov     eax, 3
    mov     ebx, [pos_j3]
    mov     ecx, [turnos_j3]
    push    ecx
    push    ebx
    push    eax
    push    msg_linea_jug
    call    printf
    add     esp, 16
skip_j3_resumen:

    mov     eax, 0
    leave
    ret

;====================================================
; convertir_pos_a_indice
; Entrada: eax = posicion (1..100)
; Salida:  eax = indice en casillas (0..99)
;====================================================
convertir_pos_a_indice:
    push    ebx
    push    ecx
    push    edx

    dec     eax             ; 1..100 -> 0..99
    mov     ebx, 10
    xor     edx, edx
    div     ebx             ; eax = fila_desde_abajo, edx = columna

    mov     ecx, 9
    sub     ecx, eax        ; fila_arriba = 9 - fila_desde_abajo

    mov     eax, ecx
    mov     ebx, 10
    mul     ebx             ; fila_arriba * 10
    add     eax, edx        ; + columna

    pop     edx
    pop     ecx
    pop     ebx
    ret

;====================================================
; dibujar_tablero
;====================================================
dibujar_tablero:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx

    ; limpiar pantalla
    push    clear_cmd
    call    system
    add     esp, 4

    ; llenar casillas con '.'
    mov     ecx, 100
    mov     edi, casillas
    mov     al, '.'
    rep stosb

    ; jugador 1
    mov     eax, [pos_j1]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '1'

    ; jugador 2 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 2
    jl      .skip_j2
    mov     eax, [pos_j2]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '2'
.skip_j2:

    ; jugador 3 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 3
    jl      .skip_j3
    mov     eax, [pos_j3]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], '3'
.skip_j3:

    ; linea superior
    push    fmt_top
    call    printf
    add     esp, 4

    xor     esi, esi        ; fila = 0

print_filas_tablero:
    mov     eax, esi
    mov     ebx, 10
    mul     ebx             ; eax = fila * 10
    mov     edx, eax        ; base

    mov     ecx, 9          ; columnas 9..1

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

    push    fmt_row
    call    printf
    add     esp, 4 + 10*4

    cmp     esi, 9
    je      .no_mid_line

    push    fmt_mid
    call    printf
    add     esp, 4

.no_mid_line:
    inc     esi
    cmp     esi, 10
    jl      print_filas_tablero

    ; linea inferior
    push    fmt_bottom
    call    printf
    add     esp, 4

    pop     edx
    pop     ecx
    pop     edi
    pop     esi
    pop     ebx
    leave
    ret
