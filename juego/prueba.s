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

// --- INICIO TEST CON IDENTIFICADORES ---
_start:
    // Bienvenida
    LDR x1, =msgBienvenida
    MOV x2, #11
    MOV x8, #64      // syscall: write
    MOV x0, #1       // fd: stdout
    SVC #0
    LDR x1, =Bienvenida
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeSalir
    LDR x1, =msgSalir
    MOV x2, #12
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeSalir
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // Menu
    LDR x1, =msgMenu
    MOV x2, #5
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =Menu
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeErrorSeleccion
    LDR x1, =msgErrorSeleccion
    MOV x2, #21
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeErrorSeleccion
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeFilas
    LDR x1, =msgFilas
    MOV x2, #13
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeColumnas
    LDR x1, =msgColumnas
    MOV x2, #16
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeMinas
    LDR x1, =msgMinas
    MOV x2, #12
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeErrorCantidadFilas
    LDR x1, =msgErrorCantidadFilas
    MOV x2, #22
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeErrorCantidadFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeErrorCantidadColumnas
    LDR x1, =msgErrorCantidadColumnas
    MOV x2, #25
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeErrorCantidadColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeErrorCantidadMinas
    LDR x1, =msgErrorCantidadMinas
    MOV x2, #21
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeErrorCantidadMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MenuAccion
    LDR x1, =msgMenuAccion
    MOV x2, #11
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MenuAccion
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeFila
    LDR x1, =msgFila
    MOV x2, #12
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeFila
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeColumna
    LDR x1, =msgColumna
    MOV x2, #15
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeColumna
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeDerrota
    LDR x1, =msgDerrota
    MOV x2, #13
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeDerrota
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // MensajeVictoria
    LDR x1, =msgVictoria
    MOV x2, #15
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =MensajeVictoria
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // SimboloVacio
    LDR x1, =msgSimboloVacio
    MOV x2, #13
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =SimboloVacio
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // SimboloMina
    LDR x1, =msgSimboloMina
    MOV x2, #12
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =SimboloMina
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // SimboloBandera
    LDR x1, =msgSimboloBandera
    MOV x2, #16
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =SimboloBandera
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // NuevaLinea
    LDR x1, =msgNuevaLinea
    MOV x2, #12
    MOV x8, #64
    MOV x0, #1
    SVC #0
    LDR x1, =NuevaLinea
    BL f05LongitudCadena
    MOV x0, x0
    BL .align_stack_and_print_long
    // Fin
    MOV x8, #93
    SVC #0
// --- FIN TEST CON IDENTIFICADORES ---

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
// --- Rutina corregida para imprimir un número decimal en ARMv8 ---
// Entrada: x0 = número a imprimir
// Utiliza f01ImprimirCadena para mostrar el resultado
// Alinea el stack y valida argumentos
print_long:
    // Prologo de función: guardar marco y retorno
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // Reservar espacio para el buffer (16 bytes, alineado)
    sub sp, sp, #16
    mov x1, sp          // x1 = puntero al buffer
    mov x2, #0          // x2 = longitud
    cmp x0, #0
    bne print_long_loop
    mov w3, #'0'
    strb w3, [x1]
    add x2, x2, #1
    b print_long_done
print_long_loop:
    mov x3, x0
    mov x4, #10
    udiv x0, x3, x4         // x0 = x3 / 10
    msub x5, x0, x4, x3     // x5 = x3 - x0*10 (resto)
    add w5, w5, #'0'        // convertir a ASCII
    strb w5, [x1, x2]
    add x2, x2, #1
    cmp x0, #0
    bne print_long_loop
print_long_done:
    mov x3, #0
    sub x4, x2, #1
print_long_reverse:
    cmp x3, x4
    bge print_long_print
    ldrb w5, [x1, x3]
    ldrb w6, [x1, x4]
    strb w6, [x1, x3]
    strb w5, [x1, x4]
    add x3, x3, #1
    sub x4, x4, #1
    b print_long_reverse
print_long_print:
    // Imprimir el buffer usando SVC 64 (write)
    mov x8, #64         // syscall: write
    mov x0, #1          // fd: stdout
    mov x1, sp          // buffer
    mov x2, x2          // longitud
    svc #0
    add sp, sp, #16     // liberar buffer
    // imprimir salto de línea
    ldr x1, =NuevaLinea
    mov x2, #1
    mov x8, #64         // syscall: write
    mov x0, #1          // fd: stdout
    svc #0
    // Epilogo de función: restaurar marco y retorno
    ldp x29, x30, [sp], 16
    ret

// --- Rutina para asegurar alineación del stack antes de print_long ---
.align_stack_and_print_long:
    // Alinear el stack a 16 bytes antes de llamar a print_long
    MOV x9, sp
    AND x9, x9, #15
    CMP x9, #0
    BEQ .call_print_long
    SUB sp, sp, #8      // Ajusta el stack si es necesario
.call_print_long:
    BL print_long
    // Restaurar el stack si se ajustó
    MOV x9, sp
    AND x9, x9, #15
    CMP x9, #0
    BEQ .done_restore
    ADD sp, sp, #8
.done_restore:
    RET

