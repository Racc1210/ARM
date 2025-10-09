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

_start:
    // Bienvenida
    LDR x1, =Bienvenida
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeSalir
    LDR x1, =MensajeSalir
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // Menu
    LDR x1, =Menu
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorSeleccion
    LDR x1, =MensajeErrorSeleccion
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeFilas
    LDR x1, =MensajeFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeColumnas
    LDR x1, =MensajeColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeMinas
    LDR x1, =MensajeMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadFilas
    LDR x1, =MensajeErrorCantidadFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadColumnas
    LDR x1, =MensajeErrorCantidadColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadMinas
    LDR x1, =MensajeErrorCantidadMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MenuAccion
    LDR x1, =MenuAccion
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeFila
    LDR x1, =MensajeFila
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeColumna
    LDR x1, =MensajeColumna
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeDerrota
    LDR x1, =MensajeDerrota
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeVictoria
    LDR x1, =MensajeVictoria
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloVacio
    LDR x1, =SimboloVacio
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloMina
    LDR x1, =SimboloMina
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloBandera
    LDR x1, =SimboloBandera
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // NuevaLinea
    LDR x1, =NuevaLinea
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // Fin
    MOV x8, #93
    SVC #0

// print_long: imprime el valor en x0 como número (simple, solo para ver el resultado)

// print_long: imprime el valor en x0 como número decimal
// x0 = número a imprimir
// Usa un buffer local en la pila
print_long:
    SUB sp, sp, #16         // reservar espacio para buffer (max 16 dígitos)
    MOV x1, sp              // x1 = buffer
    MOV x2, #0              // x2 = contador de dígitos
    CMP x0, #0
    BNE print_long_loop
    MOV w3, #'0'
    STRB w3, [x1]
    ADD x2, x2, #1
    B print_long_done
print_long_loop:
    MOV x3, x0
    MOV x4, #10
    UDIV x0, x3, x4         // x0 = x3 / 10
    MSUB x5, x0, x4, x3     // x5 = x3 - x0*10 (resto)
    ADD w5, w5, #'0'        // convertir a ASCII
    STRB w5, [x1, x2]
    ADD x2, x2, #1
    CMP x0, #0
    BNE print_long_loop
print_long_done:
    // invertir el buffer
    MOV x3, #0
    SUB x4, x2, #1
print_long_reverse:
    CMP x3, x4
    BGE print_long_print
    LDRB w5, [x1, x3]
    LDRB w6, [x1, x4]
    STRB w6, [x1, x3]
    STRB w5, [x1, x4]
    ADD x3, x3, #1
    SUB x4, x4, #1
    B print_long_reverse
print_long_print:
    MOV x2, x2              // longitud
    BL f01ImprimirCadena
    ADD sp, sp, #16         // liberar buffer
    // imprimir salto de línea
    LDR x1, =NuevaLinea
    MOV x2, #1
    BL f01ImprimirCadena
    RET
