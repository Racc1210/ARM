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
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // Reservar buffer local en el stack (16 bytes)
    sub sp, sp, #16
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
    add sp, sp, #16
    ldr x1, =NuevaLinea
    mov x2, #1
    mov x8, #64
    mov x0, #1
    svc #0
    ldp x29, x30, [sp], 16
    ret

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
    BL print_long
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
