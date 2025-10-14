.section .text
.global _start

.global OpcionSel

OpcionSel:      .skip 8
.extern f01ImprimirCadena
.extern f05LongitudCadena
.extern Bienvenida
.extern MensajeSalir
.extern Menu
.extern MensajeErrorSeleccion
.extern MensajeFilas
.extern MensajeColumnas
.extern MensajeMinas
.extern MensajeErrorCantidadFilas
.extern MensajeErrorCantidadColumnas
.extern MensajeErrorCantidadMinas
.extern MenuAccion
.extern MensajeFila
.extern MensajeColumna
.extern MensajeDerrota
.extern MensajeVictoria
.extern SimboloVacio
.extern SimboloMina
.extern SimboloBandera
.extern NuevaLinea

// --- NUEVA RUTINA print_long: minimalista, robusta y alineada ---
print_long:
    stp x29, x30, [sp, -32]!
    mov x29, sp
    // Reservar buffer local en el stack (16 bytes, ya incluido en stp)
    mov x1, sp          // x1 = buffer
    mov x2, #0          // x2 = longitud
    cmp x0, #0
    bne .pl_loop
    mov w3, #'0'
    strb w3, [x1]
    add x2, x2, #1
    b .pl_done
.pl_loop:
    mov x3, x0
    mov x4, #10
    udiv x0, x3, x4
    msub x5, x0, x4, x3
    add w5, w5, #'0'
    strb w5, [x1, x2]
    add x2, x2, #1
    cmp x0, #0
    bne .pl_loop
.pl_done:
    mov x3, #0
    sub x4, x2, #1
.pl_reverse:
    cmp x3, x4
    bge .pl_print
    ldrb w5, [x1, x3]
    ldrb w6, [x1, x4]
    strb w6, [x1, x3]
    strb w5, [x1, x4]
    add x3, x3, #1
    sub x4, x4, #1
    b .pl_reverse
.pl_print:
    mov x8, #64
    mov x0, #1
    mov x1, sp
    mov x2, x2
    svc #0
    ldr x1, =NuevaLinea
    mov x2, #1
    mov x8, #64
    mov x0, #1
    svc #0
    ldp x29, x30, [sp], 32
    ret

// --- INICIO TEST CON IDENTIFICADORES ---
_start:
    // Inicializar semilla con el PID del proceso
    MOV x8, #172 // syscall getpid
    SVC #0
    LDR x3, =Semilla
    STR x0, [x3]

    // Llamar varias veces a f02NumeroAleatorio y mostrar el resultado
    MOV x4, #5 // cantidad de pruebas
prueba_loop:
    CMP x4, #0
    BEQ prueba_fin
    BL f02NumeroAleatorio
    MOV x0, x0
    BL print_long
    SUB x4, x4, #1
    B prueba_loop
prueba_fin:
    MOV x8, #93
    SVC #0
    // Fin del programa
// --- Rutina: imprimir_cadena_n_veces ---
// x3: dirección de la cadena
// x2: longitud de la cadena
// x4: cantidad de impresiones
imprimir_cadena_n_veces:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    MOV x5, #0        // contador
imprimir_bucle:
    CMP x5, x4
    B.GE imprimir_fin
    MOV x8, #64       // syscall: write
    MOV x0, #1        // fd: stdout
    MOV x1, x3        // buffer
    MOV x2, x2        // longitud
    SVC #0
    ADD x5, x5, #1
    B imprimir_bucle
imprimir_fin:
    ldp x29, x30, [sp], 16
    RET
// --- FIN TEST CON IDENTIFICADORES ---

// --- Rutina: repetir_caracter_n_veces ---
// x1: carácter, x2: cantidad
// Reserva memoria dinámica, rellena, añade salto de línea, imprime
repetir_caracter_n_veces:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // 1. Obtener heap actual
    MOV x8, #214      // syscall: brk (ARM64)
    MOV x0, #0
    SVC #0
    MOV x3, x0        // x3 = base heap
    // 2. Reservar N+1 bytes
    ADD x0, x3, x2    // x0 = base + N
    ADD x0, x0, #1    // x0 = base + N + 1
    MOV x8, #214      // syscall: brk
    SVC #0
    // 3. Rellenar N veces con el carácter
    MOV x4, #0        // índice
repetir_bucle:
    CMP x4, x2
    B.GE repetir_fin_bucle
    STRB w1, [x3, x4]
    ADD x4, x4, #1
    B repetir_bucle
repetir_fin_bucle:
    // 4. Añadir salto de línea
    MOV w5, #10       // '\n'
    STRB w5, [x3, x2]
    // 5. Imprimir la cadena
    MOV x8, #64       // syscall: write
    MOV x0, #1        // fd: stdout
    MOV x1, x3        // buffer
    ADD x2, x2, #1    // longitud = N + 1
    SVC #0
    ldp x29, x30, [sp], 16
    RET

.section .data
msgBienvenida:        .asciz "Bienvenida: "
msgSalir:             .asciz "MensajeSalir: "
msgMenu:              .asciz "Menu: "
msgErrorSeleccion:    .asciz "MensajeErrorSeleccion: "
msgFilas:             .asciz "MensajeFilas: "
msgColumnas:          .asciz "MensajeColumnas: "
msgMinas:             .asciz "MensajeMinas: "
msgErrorCantidadFilas:.asciz "MensajeErrorCantidadFilas: "
msgErrorCantidadColumnas:.asciz "MensajeErrorCantidadColumnas: "
msgErrorCantidadMinas:.asciz "MensajeErrorCantidadMinas: "
msgMenuAccion:        .asciz "MenuAccion: "
msgFila:              .asciz "MensajeFila: "
msgColumna:           .asciz "MensajeColumna: "
msgDerrota:           .asciz "MensajeDerrota: "
msgVictoria:          .asciz "MensajeVictoria: "
msgSimboloVacio:      .asciz "SimboloVacio: "
msgSimboloMina:       .asciz "SimboloMina: "
msgSimboloBandera:    .asciz "SimboloBandera: "
msgNuevaLinea:        .asciz "NuevaLinea: "

// Definición local para pruebas unitarias

