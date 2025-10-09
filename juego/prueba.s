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
// Aquí solo se imprime el valor como carácter (no como número decimal)
// Para ver el resultado real, deberías convertir x0 a cadena decimal y luego imprimir
print_long:
    // Aquí solo imprime el valor como byte (no como número)
    // Puedes mejorar esto para imprimir como número decimal si lo necesitas
    MOV x1, sp
    STRB w0, [x1]
    MOV x2, #1
    BL f01ImprimirCadena
    RET
