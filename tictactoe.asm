section .data
    board db '123456789', 0       ; Tic-tac-toe board
    player db 'X', 0              ; Current player
    prompt db 'Player %c, enter a position (1-9): ', 0
    invalid_move_msg db 'Invalid move. Try again.', 10, 0
    win_msg db 'Player %c wins!', 10, 0
    draw_msg db "It's a draw!", 10, 0
    input_format db '%d', 0
    newline db 10, 0
    board_format db ' %c │ %c │ %c ', 10
              db '───┼───┼───', 10
              db ' %c │ %c │ %c ', 10
              db '───┼───┼───', 10
              db ' %c │ %c │ %c ', 10, 0


extern printf
extern scanf

section .bss
    move resd 1

section .text
global main

main:
    push ebp
    mov ebp, esp

game_loop:
    ; Print the board
    push board
    call print_board
    add esp, 4

    ; Prompt for move
    push dword [player]
    push prompt
    call printf
    add esp, 8

    ; Get player's move
    push move
    push input_format
    call scanf
    add esp, 8

    ; Validate and make move
    push dword [move]
    call make_move
    add esp, 4
    test eax, eax
    jz invalid_move_handler

    ; Check for win
    call check_win
    test eax, eax
    jnz game_over

    ; Check for draw
    call check_draw
    test eax, eax
    jnz game_over

    ; Switch player
    mov al, [player]
    cmp al, 'X'
    je set_o
    mov byte [player], 'X'
    jmp game_loop
set_o:
    mov byte [player], 'O'
    jmp game_loop

invalid_move_handler:
    push invalid_move_msg
    call printf
    add esp, 4
    jmp game_loop

game_over:
    ; Print final board state
    push board
    call print_board
    add esp, 4

    ; Print win or draw message
    call check_win
    test eax, eax
    jz check_draw_msg

    push dword [player]
    push win_msg
    jmp print_final_msg
check_draw_msg:
    push draw_msg
print_final_msg:
    call printf
    add esp, 8

    ; Exit
    mov esp, ebp
    pop ebp
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_board:
    push ebp
    mov ebp, esp
    push esi
    mov esi, [ebp+8]  ; Get board address

    push dword [esi+8]
    push dword [esi+7]
    push dword [esi+6]
    push dword [esi+5]
    push dword [esi+4]
    push dword [esi+3]
    push dword [esi+2]
    push dword [esi+1]
    push dword [esi]
    push board_format
    call printf
    add esp, 40

    pop esi
    mov esp, ebp
    pop ebp
    ret

make_move:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp+8]  ; Get move
    dec esi           ; Convert to 0-based index
    mov edi, board

    cmp esi, 0
    jl invalid_move_label
    cmp esi, 8
    jg invalid_move_label

    mov al, [edi+esi]
    cmp al, 'X'
    je invalid_move_label
    cmp al, 'O'
    je invalid_move_label

    mov al, [player]
    mov [edi+esi], al

    mov eax, 1        ; Return 1 for valid move
    jmp make_move_end

invalid_move_label:
    xor eax, eax      ; Return 0 for invalid move

make_move_end:
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

check_win:
    push ebp
    mov ebp, esp
    push esi
    mov esi, board

    ; Check rows
    call check_line
    add esi, 3
    call check_line
    add esi, 3
    call check_line
    sub esi, 6

    ; Check columns
    call check_column
    inc esi
    call check_column
    inc esi
    call check_column
    sub esi, 2

    ; Check diagonals
    call check_diagonal
    add esi, 2
    call check_diagonal

    xor eax, eax      ; Return 0 if no win
    pop esi
    mov esp, ebp
    pop ebp
    ret

check_line:
    mov al, [esi]
    cmp al, [esi+1]
    jne check_line_end
    cmp al, [esi+2]
    jne check_line_end
    mov eax, 1        ; Return 1 for win
    add esp, 4        ; Adjust stack to return from check_win
    jmp check_win_end
check_line_end:
    ret

check_column:
    mov al, [esi]
    cmp al, [esi+3]
    jne check_column_end
    cmp al, [esi+6]
    jne check_column_end
    mov eax, 1        ; Return 1 for win
    add esp, 4        ; Adjust stack to return from check_win
    jmp check_win_end
check_column_end:
    ret

check_diagonal:
    mov al, [esi]
    cmp al, [esi+4]
    jne check_diagonal_end
    cmp al, [esi+8]
    jne check_diagonal_end
    mov eax, 1        ; Return 1 for win
    add esp, 4        ; Adjust stack to return from check_win
    jmp check_win_end
check_diagonal_end:
    ret

check_win_end:
    pop esi
    mov esp, ebp
    pop ebp
    ret

check_draw:
    push ebp
    mov ebp, esp
    push esi
    mov esi, board
    mov ecx, 9        ; Counter for 9 positions

check_draw_loop:
    mov al, [esi]
    cmp al, 'X'
    je next_position
    cmp al, 'O'
    je next_position
    xor eax, eax      ; Return 0 if empty position found
    jmp check_draw_end

next_position:
    inc esi
    loop check_draw_loop

    mov eax, 1        ; Return 1 if all positions filled

check_draw_end:
    pop esi
    mov esp, ebp
    pop ebp
    ret