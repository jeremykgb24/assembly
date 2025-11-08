extern printf
extern scanf
extern system

section .data
    casillas:   times 100 db '.'

    clear_cmd   db "clear", 0

    fmt_top     db "┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐", 10, 0
    fmt_mid     db "├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤", 10, 0
    fmt_bottom  db "└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘", 10, 0
    fmt_row     db "|%c|%c|%c|%c|%c|%c|%c|%c|%c|%c|", 10, 0

    msg_pedir_jug   db 10, "Cuantos jugadores van a jugar? (1-3): ", 0
    msg_turno       db 10, "Turno del jugador %d de %d", 10, 0
    msg_enter       db 10, "Presiona ENTER para tirar el dado...", 10, 0
    msg_opciones_turno db 10, "Presiona ENTER para tirar el dado, (r) para reiniciar o (q) para salir: ", 0
    msg_saliendo       db 10, "Saliendo del juego...", 10, 0


    msg_ganador     db 10, "El jugador %d ha ganado la partida.", 10, 0
    msg_resumen     db 10, "Resumen de la partida:", 10, 0
    msg_linea_jug   db "Jugador %d: posicion final %d, turnos jugados %d", 10, 0

    msg_resumen_esc   db "   Escaleras usadas por el ganador: %d", 10, 0
    msg_resumen_serp  db "   Serpientes usadas por el ganador: %d", 10, 0


    msg_turno_info  db 10, "Jugador %d: dado %d, posicion %d, turnos %d", 10, 0

    msg_subio_esc   db "   -> Subio por escalera de %d a %d", 10, 0
    msg_bajo_serp   db "   -> Bajo por serpiente de %d a %d", 10, 0
    msg_sin_cambio  db "   -> Sin serpiente ni escalera", 10, 0

    msg_reiniciar   db 10, "Desea jugar otra partida con los mismos jugadores? (s/n): ", 0


    fmt_char        db "%c", 0
    fmt_int         db "%d", 0

section .bss
    num_jugadores   resd 1
    jugador_actual  resd 1

    pos_j1          resd 1
    pos_j2          resd 1
    pos_j3          resd 1

    turnos_j1       resd 1
    turnos_j2       resd 1
    turnos_j3       resd 1

        ; contadores de escaleras y serpientes por jugador
    esc_j1         resd 1
    esc_j2         resd 1
    esc_j3         resd 1

    serp_j1        resd 1
    serp_j2        resd 1
    serp_j3        resd 1


    valor_dado      resd 1
    ganador         resd 1

    serpientes_origen     resd 3
    serpientes_destino    resd 3
    escaleras_origen      resd 3
    escaleras_destino     resd 3


    ultimo_jugador  resd 1
    ultimo_dado     resd 1
    hay_ultimo      resd 1

    evento_tipo     resd 1      ; 0 = nada, 1 = escalera, 2 = serpiente
    evento_origen   resd 1      ; posición antes de cambiar
    evento_destino  resd 1      ; posición después de cambiar



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

    ; consumir el ENTER que queda en el buffer
    ; (para que no se use como primer tiro del jugador 1)
    lea     eax, [tecla]        ; tecla ya está declarada en .bss
    push    eax
    push    fmt_char            ; "%c"
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
    mov     dword [hay_ultimo], 0

    mov     dword [esc_j1], 0
    mov     dword [esc_j2], 0
    mov     dword [esc_j3], 0

    mov     dword [serp_j1], 0
    mov     dword [serp_j2], 0
    mov     dword [serp_j3], 0

    
    call generar_serpientes_escaleras


;====================================================
; BUCLE PRINCIPAL DE LA PARTIDA
;====================================================
bucle_partida:
    mov     eax, [ganador]
    cmp     eax, 0
    jne     fin_partida

    mov     dword [jugador_actual], 1

bucle_turnos:
    ; cargar jugador_actual y total jugadores
    mov     eax, [jugador_actual]
    mov     ecx, [num_jugadores]

    ; si jugador_actual > num_jugadores, empezar nueva ronda
    cmp     eax, ecx
    jg      bucle_partida

    ; si ya hay ganador, salir
    mov     edx, [ganador]
    cmp     edx, 0
    jne     fin_partida

    mov     esi, eax

    ; dibujar tablero antes de lanzar dado
    call    dibujar_tablero

    
    ;---------------------------------------
    ; Mostrar resumen del turno anterior
    ;---------------------------------------
    mov     eax, [hay_ultimo]
    cmp     eax, 0
    je      .sin_prev    ; si no hay turno anterior, saltar

    ; EAX = ultimo_jugador
    mov     eax, [ultimo_jugador]
    mov     edx, [ultimo_dado]     ; dado que saco

    ; obtener pos y turnos del jugador anterior
    cmp     eax, 1
    je      .prev_j1
    cmp     eax, 2
    je      .prev_j2

    ; jugador 3
    mov     ebx, [pos_j3]
    mov     ecx, [turnos_j3]
    jmp     .tengo_prev

.prev_j1:
    mov     ebx, [pos_j1]
    mov     ecx, [turnos_j1]
    jmp     .tengo_prev

.prev_j2:
    mov     ebx, [pos_j2]
    mov     ecx, [turnos_j2]

.tengo_prev:
    ; imprimir: Jugador X: dado Y, posicion Z, turnos T
    push    ecx         ; turnos
    push    ebx         ; posicion
    push    edx         ; dado
    push    eax         ; jugador
    push    msg_turno_info
    call    printf
    add     esp, 20

    ; imprimir si subio/bajo o nada
    mov     eax, [evento_tipo]
    cmp     eax, 1
    je      .prev_escalera
    cmp     eax, 2
    je      .prev_serpiente

    ; sin serpiente ni escalera
    push    msg_sin_cambio
    call    printf
    add     esp, 4
    jmp     .fin_prev_evento

.prev_escalera:
    mov     eax, [evento_origen]
    mov     ebx, [evento_destino]
    push    ebx             ; destino
    push    eax             ; origen
    push    msg_subio_esc
    call    printf
    add     esp, 12
    jmp     .fin_prev_evento

.prev_serpiente:
    mov     eax, [evento_origen]
    mov     ebx, [evento_destino]
    push    ebx             ; destino
    push    eax             ; origen
    push    msg_bajo_serp
    call    printf
    add     esp, 12

.fin_prev_evento:
    ; limpiar evento para que no se repita
    mov     dword [evento_tipo], 0

.sin_prev:
    ;---------------------------------------
    ; mensaje de turno actual
    ;---------------------------------------
    mov     ecx, [num_jugadores]   ; <-- RECARGAR AQUÍ

    push    ecx            ; total de jugadores
    push    esi            ; jugador_actual
    push    msg_turno
    call    printf
    add     esp, 12

    ;---------------------------------------
    ; Esperar acción del jugador
    ;---------------------------------------
.esperar_accion:
    push    msg_opciones_turno
    call    printf
    add     esp, 4

    ; leer una tecla
    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    mov     al, [tecla]

    ;-----------------------------------
    ; Reiniciar durante la partida
    ;-----------------------------------
    cmp     al, 'r'
    je      .reiniciar_durante
    cmp     al, 'R'
    je      .reiniciar_durante

    ;-----------------------------------
    ; Salir durante la partida
    ;-----------------------------------
    cmp     al, 'q'
    je      .salir_durante
    cmp     al, 'Q'
    je      .salir_durante

    ; Si presionó ENTER (ASCII 10 o 13 dependiendo del sistema)
    cmp     al, 10
    je      .continuar_turno
    cmp     al, 13
    je      .continuar_turno

    ; Si presionó algo inválido, volver a preguntar
    jmp     .esperar_accion

.reiniciar_durante:
    ; tragarse el ENTER que se escribió después de la 'r'
    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    jmp     reiniciar_partida    ; usa tu rutina ya existente

.salir_durante:
    ; tragarse el ENTER que se escribió después de la 'q'
    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    jmp     salir_programa       ; usa tu rutina ya existente

.continuar_turno:



    ; lanzar dado 1..6 usando rdtsc
    rdtsc
    mov     ecx, 6
    xor     edx, edx
    div     ecx

    mov     eax, edx
    add     eax, 1
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
; comprobar si este jugador gano
check_win:
    ; aplicar serpiente/escalera si corresponde
    call    aplicar_casilla_especial

    ; guardar info del evento para imprimir despues
    mov     [evento_tipo], eax
    mov     [evento_origen], ebx
    mov     [evento_destino], ecx

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
    ; guardar info basica del turno para el siguiente
    mov     eax, esi              ; jugador que acaba de jugar
    mov     edx, [valor_dado]     ; dado que saco

    mov     [ultimo_jugador], eax
    mov     [ultimo_dado], edx
    mov     dword [hay_ultimo], 1

    ; aquí NO dibujamos tablero ni imprimimos nada.
    ; solo guardamos la info, el tablero se dibuja
    ; al inicio del siguiente turno en bucle_turnos.

    mov     eax, [ganador]
    cmp     eax, 0
    jne     fin_partida

    mov     eax, [jugador_actual]
    inc     eax
    mov     [jugador_actual], eax
    jmp     bucle_turnos


;====================================================
; FIN PARTIDA Y RESUMEN
;====================================================
fin_partida:
    call    dibujar_tablero

    mov     eax, [ganador]
    push    eax
    push    msg_ganador
    call    printf
    add     esp, 8

    push    msg_resumen
    call    printf
    add     esp, 4

    mov     eax, 1
    mov     ebx, [pos_j1]
    mov     ecx, [turnos_j1]
    push    ecx
    push    ebx
    push    eax
    push    msg_linea_jug
    call    printf
    add     esp, 16

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

    ;---------------------------------------
    ; Mostrar cuantas escaleras y serpientes
    ; uso el jugador ganador
    ;---------------------------------------
    mov     eax, [ganador]
    cmp     eax, 1
    je      .ganador_j1
    cmp     eax, 2
    je      .ganador_j2
    ; si no es 1 ni 2, es 3
    jmp     .ganador_j3

.ganador_j1:
    mov     ebx, [esc_j1]
    mov     ecx, [serp_j1]
    jmp     .tengo_contadores

.ganador_j2:
    mov     ebx, [esc_j2]
    mov     ecx, [serp_j2]
    jmp     .tengo_contadores

.ganador_j3:
    mov     ebx, [esc_j3]
    mov     ecx, [serp_j3]

.tengo_contadores:
    ; imprimir escaleras usadas
    push    ebx
    push    msg_resumen_esc
    call    printf
    add     esp, 8

    ; imprimir serpientes usadas
    push    ecx
    push    msg_resumen_serp
    call    printf
    add     esp, 8
    ;---------------------------------------
    ; Preguntar si desea jugar otra partida
    ;---------------------------------------
.preguntar:
    push    msg_reiniciar
    call    printf
    add     esp, 4

    ; leer opcion en 'tecla'
    lea     eax, [tecla]
    push    eax
    push    fmt_char        ; "%c"
    call    scanf
    add     esp, 8

    mov     bl, [tecla]     ; guardar respuesta

    ; consumir el ENTER que queda en el buffer
    lea     eax, [tecla]
    push    eax
    push    fmt_char
    call    scanf
    add     esp, 8

    ; normalizar: solo aceptamos s/S o n/N
    cmp     bl, 's'
    je      reiniciar_partida
    cmp     bl, 'S'
    je      reiniciar_partida
    cmp     bl, 'n'
    je      salir_programa
    cmp     bl, 'N'
    je      salir_programa

    ; si puso otra cosa, volver a preguntar
    jmp     .preguntar

salir_programa:
    mov     eax, 0
    push    msg_saliendo
    call    printf
    add     esp, 4

    leave
    ret


reiniciar_partida:
    ;---------------------------------------
    ; Re-inicializar posiciones y contadores
    ;---------------------------------------
    mov     dword [pos_j1], 1
    mov     dword [pos_j2], 1
    mov     dword [pos_j3], 1

    mov     dword [turnos_j1], 0
    mov     dword [turnos_j2], 0
    mov     dword [turnos_j3], 0

    mov     dword [ganador], 0
    mov     dword [hay_ultimo], 0

    mov     dword [ultimo_jugador], 0
    mov     dword [ultimo_dado], 0

    mov     dword [evento_tipo], 0
    mov     dword [evento_origen], 0
    mov     dword [evento_destino], 0

    mov     dword [esc_j1], 0
    mov     dword [esc_j2], 0
    mov     dword [esc_j3], 0

    mov     dword [serp_j1], 0
    mov     dword [serp_j2], 0
    mov     dword [serp_j3], 0

    ;---------------------------------------
    ; Generar nuevas serpientes y escaleras
    ;---------------------------------------
    call    generar_serpientes_escaleras

    jmp     bucle_partida


;====================================================
; random_rango(min, max)
; Entrada (cdecl):
;   push max
;   push min
;   call random_rango
;
; En la función:
;   [ebp+8]  = min
;   [ebp+12] = max
;
; Salida:
;   eax = número aleatorio entre min y max (inclusive)
;====================================================
random_rango:
    push    ebp
    mov     ebp, esp

    push    ebx
    push    ecx
    push    edx

    rdtsc                      ; aleatorio base en EDX:EAX
    xor     edx, edx           ; usaremos solo EAX como dividendo

    mov     ecx, [ebp+8]       ; min
    mov     ebx, [ebp+12]      ; max

    sub     ebx, ecx           ; max - min
    inc     ebx                ; rango = max - min + 1
    div     ebx                ; EAX/EBX, resto en EDX (0..rango-1)

    add     edx, ecx           ; min + resto
    mov     eax, edx           ; resultado final en EAX

    pop     edx
    pop     ecx
    pop     ebx
    pop     ebp
    ret     8                  ; limpia 2 argumentos (min, max)


;====================================================
; generar_serpientes_escaleras
; Genera 3 serpientes y 3 escaleras:
;   - SIEMPRE verticales (misma columna).
;   - Longitud de 1 a 3 casillas.
;   - Sin posiciones repetidas entre sí.
;====================================================
generar_serpientes_escaleras:
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi
    push    ebp

    ;---------------------------------------
    ; Generar 3 serpientes
    ;---------------------------------------
    xor     ebx, ebx              ; ebx = índice de serpiente (0..2)

.gen_serp_outer:
    cmp     ebx, 3
    jge     .fin_serpientes       ; ya tenemos las 3

.serp_try:
    ; columna aleatoria 0..9
    push    9
    push    0
    call    random_rango
    mov     esi, eax              ; ESI = columna

    ; fila 1 (desde arriba) 0..9
    push    9
    push    0
    call    random_rango
    mov     edi, eax              ; EDI = fila1

.serp_fila2:
    ; fila 2 (desde arriba) 0..9
    push    9
    push    0
    call    random_rango
    mov     ecx, eax              ; ECX = fila2

    ; diff = |fila1 - fila2|
    mov     eax, edi
    sub     eax, ecx
    jns     .serp_no_neg
    neg     eax
.serp_no_neg:
    cmp     eax, 1                ; mínimo 1 casilla de diferencia
    jl      .serp_fila2
    cmp     eax, 3                ; máximo 3 casillas de diferencia
    jg      .serp_fila2

    ; convertir (fila1, columna) -> pos1
    mov     eax, edi              ; fila1
    mov     edx, esi              ; columna
    call    convertir_fila_col_a_pos
    mov     ebp, eax              ; EBP = pos1

    ; convertir (fila2, columna) -> pos2
    mov     eax, ecx              ; fila2
    mov     edx, esi              ; columna
    call    convertir_fila_col_a_pos
    mov     edx, eax              ; EDX = pos2

    ; ordenar para que origen > destino (serpiente baja)
    mov     eax, ebp              ; EAX = pos1
    cmp     eax, edx
    jg      .serp_pos_ok          ; si pos1 > pos2 ya está bien
    ; swap: origen = pos2, destino = pos1
    mov     eax, edx
    mov     edx, ebp
.serp_pos_ok:
    ; EAX = origen (arriba, número mayor)
    ; EDX = destino (abajo, número menor)

    ; evitar conflictos con serpientes ya generadas
    mov     ecx, ebx              ; cuántas serpientes hay
    jecxz   .no_prev_serp_conf    ; si 0, no hay nada que revisar

    xor     esi, esi              ; indice i = 0
.serp_conf_loop:
    mov     edi, [serpientes_origen + esi*4]
    cmp     eax, edi
    je      .serp_conflict
    cmp     edx, edi
    je      .serp_conflict

    mov     edi, [serpientes_destino + esi*4]
    cmp     eax, edi
    je      .serp_conflict
    cmp     edx, edi
    je      .serp_conflict

    inc     esi
    loop    .serp_conf_loop

.no_prev_serp_conf:
    ; guardar serpiente válida
    mov     [serpientes_origen  + ebx*4], eax
    mov     [serpientes_destino + ebx*4], edx

    inc     ebx
    jmp     .gen_serp_outer

.serp_conflict:
    jmp     .serp_try


.fin_serpientes:
    ;---------------------------------------
    ; Generar 3 escaleras
    ;---------------------------------------
    xor     ebx, ebx              ; ebx = índice de escalera (0..2)

.gen_esc_outer:
    cmp     ebx, 3
    jge     .fin_todo             ; ya tenemos las 3

.esc_try:
    ; columna aleatoria 0..9
    push    9
    push    0
    call    random_rango
    mov     esi, eax              ; ESI = columna

    ; fila 1 (desde arriba) 0..9
    push    9
    push    0
    call    random_rango
    mov     edi, eax              ; EDI = fila1

.esc_fila2:
    ; fila 2 (desde arriba) 0..9
    push    9
    push    0
    call    random_rango
    mov     ecx, eax              ; ECX = fila2

    ; diff = |fila1 - fila2|, 1..3
    mov     eax, edi
    sub     eax, ecx
    jns     .esc_no_neg
    neg     eax
.esc_no_neg:
    cmp     eax, 1
    jl      .esc_fila2
    cmp     eax, 3
    jg      .esc_fila2

    ; convertir (fila1, columna) -> pos1
    mov     eax, edi
    mov     edx, esi
    call    convertir_fila_col_a_pos
    mov     ebp, eax              ; EBP = pos1

    ; convertir (fila2, columna) -> pos2
    mov     eax, ecx
    mov     edx, esi
    call    convertir_fila_col_a_pos
    mov     edx, eax              ; EDX = pos2

    ; ordenar para que origen < destino (escalera sube)
    mov     eax, ebp
    cmp     eax, edx
    jl      .esc_pos_ok           ; si pos1 < pos2 ya está bien
    ; swap: origen = pos2, destino = pos1
    mov     eax, edx
    mov     edx, ebp
.esc_pos_ok:
    ; EAX = origen (abajo, número menor)
    ; EDX = destino (arriba, número mayor)

    ;-----------------------------------
    ; evitar conflictos con serpientes
    ;-----------------------------------
    mov     ecx, 3
    xor     esi, esi
.esc_vs_serp_loop:
    mov     edi, [serpientes_origen + esi*4]
    cmp     eax, edi
    je      .esc_conflict
    cmp     edx, edi
    je      .esc_conflict

    mov     edi, [serpientes_destino + esi*4]
    cmp     eax, edi
    je      .esc_conflict
    cmp     edx, edi
    je      .esc_conflict

    inc     esi
    loop    .esc_vs_serp_loop

    ;-----------------------------------
    ; evitar conflictos con escaleras previas
    ;-----------------------------------
    mov     ecx, ebx              ; cuántas escaleras ya hay
    jecxz   .no_prev_esc_conf

    xor     esi, esi
.esc_conf_loop2:
    mov     edi, [escaleras_origen + esi*4]
    cmp     eax, edi
    je      .esc_conflict
    cmp     edx, edi
    je      .esc_conflict

    mov     edi, [escaleras_destino + esi*4]
    cmp     eax, edi
    je      .esc_conflict
    cmp     edx, edi
    je      .esc_conflict

    inc     esi
    loop    .esc_conf_loop2

.no_prev_esc_conf:
    ; guardar escalera válida
    mov     [escaleras_origen  + ebx*4], eax
    mov     [escaleras_destino + ebx*4], edx

    inc     ebx
    jmp     .gen_esc_outer

.esc_conflict:
    jmp     .esc_try


.fin_todo:
    pop     ebp
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    ret


;====================================================
; convertir_pos_a_indice
; Entrada: eax = posicion (1..100)
; Salida:  eax = indice en casillas (0..99)
;
; Tablero tipo serpiente:
;   - La fila inferior (1..10) va de IZQUIERDA a DERECHA.
;   - La siguiente fila (11..20) va de DERECHA a IZQUIERDA.
;   - Luego izquierda a derecha, y así sucesivamente.
;   - Visualmente se imprime de la fila superior a la inferior.
;====================================================
convertir_pos_a_indice:
    push    ebx
    push    ecx
    push    edx

    ; pasar de posicion 1..100 a 0..99
    dec     eax                 ; eax = k (0..99)

    ; eax = fila_desde_abajo (0..9)
    ; edx = columna_en_ruta (0..9) como si fuera de izq->der
    mov     ebx, 10
    xor     edx, edx
    div     ebx                 ; eax = fila_desde_abajo, edx = columna

    mov     ecx, eax            ; ecx = fila_desde_abajo
    mov     ebx, edx            ; ebx = columna_en_ruta

    ; decidir sentido de la fila (serpiente):
    ; fila_desde_abajo PAR  -> izquierda a derecha (NO se invierte)
    ; fila_desde_abajo IMPAR-> derecha a izquierda (se invierte)
    test    ecx, 1
    jz      .no_invertir        ; si es par, dejar la columna tal cual

    ; fila impar: invertir columna (0..9 -> 9..0)
    mov     edx, 9
    sub     edx, ebx
    mov     ebx, edx

.no_invertir:
    ; calcular fila desde arriba: 9 - fila_desde_abajo
    mov     eax, 9
    sub     eax, ecx            ; eax = fila_desde_arriba (0..9)

    ; indice = fila_arriba * 10 + columna_desde_izquierda
    mov     edx, 10
    mul     edx                 ; eax = fila_arriba * 10
    add     eax, ebx            ; eax = indice final (0..99)

    pop     edx
    pop     ecx
    pop     ebx
    ret

;====================================================
; convertir_fila_col_a_pos
; Entrada:
;   EAX = fila_desde_arriba (0..9)
;   EDX = columna (0..9)
; Salida:
;   EAX = posicion (1..100)
;====================================================
convertir_fila_col_a_pos:
    push    ebx
    push    ecx
    push    edx

    mov     ecx, edx        ; ECX = columna
    mov     ebx, 9
    sub     ebx, eax        ; EBX = fila_desde_abajo (0..9)

    ; si la fila desde abajo es impar, se invierte la columna (tablero serpenteante)
    test    ebx, 1
    jz      .fila_par

    ; fila impar -> columna_en_ruta = 9 - col
    mov     edx, 9
    sub     edx, ecx
    mov     ecx, edx

.fila_par:
    ; k0 = fila_desde_abajo * 10 + columna_en_ruta
    mov     eax, ebx
    mov     edx, 10
    mul     edx             ; EAX = fila*10
    add     eax, ecx        ; EAX = k0 (0..99)
    inc     eax             ; posicion = k0 + 1 (1..100)

    pop     edx
    pop     ecx
    pop     ebx
    ret

;====================================================
; aplicar_casilla_especial
; Entrada:
;   ESI = jugador_actual (1..3)
; Salida:
;   EAX = tipo_evento (0=nada, 1=escalera, 2=serpiente)
;   EBX = origen (posicion antes de cambiar)  si tipo != 0
;   ECX = destino (posicion despues de cambiar) si tipo != 0
; Efecto:
;   Actualiza pos_j1/pos_j2/pos_j3 si hay serpiente/escalera
;====================================================
aplicar_casilla_especial:
    push    ebp
    mov     ebp, esp
    push    edi
    push    esi

    ;---------------------------------
    ; Obtener puntero a posicion jugador en EDI
    ;---------------------------------
    cmp     esi, 1
    je      .jug1
    cmp     esi, 2
    je      .jug2
    ; jugador 3
    lea     edi, [pos_j3]
    jmp     .tengo_ptr

.jug2:
    lea     edi, [pos_j2]
    jmp     .tengo_ptr

.jug1:
    lea     edi, [pos_j1]

.tengo_ptr:
    mov     eax, [edi]       ; posicion actual del jugador
    mov     ebx, eax         ; origen

    ;---------------------------------
    ; Revisar escaleras primero (sube)
    ;---------------------------------
    mov     ecx, 3
    xor     edx, edx         ; indice = 0
.esc_loop:
    cmp     eax, [escaleras_origen + edx*4]
    je      .escalera_encontrada
    inc     edx
    loop    .esc_loop

    ;---------------------------------
    ; Revisar serpientes (baja)
    ;---------------------------------
    mov     ecx, 3
    xor     edx, edx
.serp_loop:
    cmp     eax, [serpientes_origen + edx*4]
    je      .serpiente_encontrada
    inc     edx
    loop    .serp_loop

    ;---------------------------------
    ; No hubo serpiente ni escalera
    ;---------------------------------
    mov     eax, 0           ; tipo_evento = 0
    jmp     .fin

.escalera_encontrada:
    mov     ecx, [escaleras_destino + edx*4] ; destino
    mov     [edi], ecx       ; actualizar posicion del jugador

    ; incrementar contador de escaleras segun el jugador (ESI)
    cmp     esi, 1
    je      .inc_esc_j1
    cmp     esi, 2
    je      .inc_esc_j2
    ; si no es 1 ni 2, asumimos jugador 3
    inc     dword [esc_j3]
    jmp     .esc_listo

.inc_esc_j1:
    inc     dword [esc_j1]
    jmp     .esc_listo

.inc_esc_j2:
    inc     dword [esc_j2]

.esc_listo:
    mov     eax, 1           ; tipo_evento = 1 (escalera)
    jmp     .fin


.serpiente_encontrada:
    mov     ecx, [serpientes_destino + edx*4]
    mov     [edi], ecx

    ; incrementar contador de serpientes segun el jugador (ESI)
    cmp     esi, 1
    je      .inc_serp_j1
    cmp     esi, 2
    je      .inc_serp_j2
    ; jugador 3 por defecto
    inc     dword [serp_j3]
    jmp     .serp_listo

.inc_serp_j1:
    inc     dword [serp_j1]
    jmp     .serp_listo

.inc_serp_j2:
    inc     dword [serp_j2]

.serp_listo:
    mov     eax, 2           ; tipo_evento = 2 (serpiente)
    jmp     .fin

.fin:
    pop     esi
    pop     edi
    pop     ebp
    ret


;====================================================
; colocar_jugador_en_casillas
; Entrada:
;   EAX = posicion (1..100)
;   DL  = caracter del jugador ('1', '2' o '3')
;
; Lógica:
;   - Si la casilla está vacía ('.' o cualquier cosa que consideres vacío):
;       se escribe DL.
;   - Si ya hay un jugador (ej: '1','2','3','S','E', etc.):
;       se escribe 'D' (dos jugadores).
;   - Si ya hay 'D':
;       se escribe 'T' (tres jugadores).
;   - Si ya hay 'T':
;       se deja como 'T'.
;====================================================
colocar_jugador_en_casillas:
    push    ebx
    push    ecx

    ; convertir posicion a indice de la matriz
    call    convertir_pos_a_indice     ; EAX = indice

    ; leer lo que hay actualmente en la casilla
    mov     bl, [casillas + eax]

    ; si la casilla está vacía ('.'), escribir el jugador
    cmp     bl, '.'
    je      .set_single

    ; si ya hay 'D', pasa a 'T'
    cmp     bl, 'D'
    je      .set_T

    ; si ya hay 'T', no hacer nada
    cmp     bl, 'T'
    je      .done

    ; si hay cualquier otra cosa (otro jugador, S, E, etc):
    ; dos elementos -> 'D'
    mov     byte [casillas + eax], 'D'
    jmp     .done

.set_single:
    mov     [casillas + eax], dl
    jmp     .done

.set_T:
    mov     byte [casillas + eax], 'T'

.done:
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
    rep     stosb
    
    ;------------------------------------------------
    ; Colocar serpientes (S/s) y escaleras (E/e)
    ;------------------------------------------------
    mov     ecx, 3
    xor     ebx, ebx

.dib_s:
    ; cabeza de la serpiente (S)
    mov     eax, [serpientes_origen + ebx*4]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], 'S'

    ; cola de la serpiente (s)
    mov     eax, [serpientes_destino + ebx*4]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], 's'

    inc     ebx
    loop    .dib_s

    mov     ecx, 3
    xor     ebx, ebx

.dib_e:
    ; base de la escalera (E)
    mov     eax, [escaleras_origen + ebx*4]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], 'E'

    ; cima de la escalera (e)
    mov     eax, [escaleras_destino + ebx*4]
    call    convertir_pos_a_indice
    mov     byte [casillas + eax], 'e'

    inc     ebx
    loop    .dib_e


    ; colocar jugador 1
    mov     eax, [pos_j1]
    mov     dl, '1'
    call    colocar_jugador_en_casillas

    ; colocar jugador 2 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 2
    jl      .skip_j2

    mov     eax, [pos_j2]
    mov     dl, '2'
    call    colocar_jugador_en_casillas
.skip_j2:

    ; colocar jugador 3 si existe
    mov     eax, [num_jugadores]
    cmp     eax, 3
    jl      .skip_j3

    mov     eax, [pos_j3]
    mov     dl, '3'
    call    colocar_jugador_en_casillas
.skip_j3:

    ; linea superior del tablero
    push    fmt_top
    call    printf
    add     esp, 4

    ; recorrer filas desde la parte superior (0..9)
    xor     esi, esi          ; esi = fila (0..9 desde arriba)

.filas_tablero:
    ; calcular índice base de la fila: fila * 10
    mov     eax, esi
    mov     ebx, 10
    mul     ebx
    mov     edx, eax          ; edx = indice base de la fila

    ; recorrer columnas de izquierda a derecha, pero empujando al revés
    ; para que printf las reciba en el orden correcto.
    mov     ecx, 9            ; empezamos en la columna 9

.columnas_tablero:
    mov     eax, edx
    add     eax, ecx          ; eax = indice casilla (base_fila + columna)
    movzx   ebx, byte [casillas + eax]
    push    ebx               ; se empuja primero col9, luego 8, ..., hasta 0
    dec     ecx
    jge     .columnas_tablero


    push    fmt_row
    call    printf
    add     esp, 4 + 10*4

    cmp     esi, 9
    je      .ultima_fila

    push    fmt_mid
    call    printf
    add     esp, 4

.ultima_fila:
    inc     esi
    cmp     esi, 10
    jl      .filas_tablero

    ; linea inferior del tablero
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
