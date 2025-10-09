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
    BL f01ImprimirCadena
    LDR x1, =Bienvenida
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeSalir
    LDR x1, =msgSalir
    MOV x2, #12
    BL f01ImprimirCadena
    LDR x1, =MensajeSalir
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // Menu
    LDR x1, =msgMenu
    MOV x2, #5
    BL f01ImprimirCadena
    LDR x1, =Menu
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorSeleccion
    LDR x1, =msgErrorSeleccion
    MOV x2, #21
    BL f01ImprimirCadena
    LDR x1, =MensajeErrorSeleccion
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeFilas
    LDR x1, =msgFilas
    MOV x2, #13
    BL f01ImprimirCadena
    LDR x1, =MensajeFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeColumnas
    LDR x1, =msgColumnas
    MOV x2, #16
    BL f01ImprimirCadena
    LDR x1, =MensajeColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeMinas
    LDR x1, =msgMinas
    MOV x2, #12
    BL f01ImprimirCadena
    LDR x1, =MensajeMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadFilas
    LDR x1, =msgErrorCantidadFilas
    MOV x2, #22
    BL f01ImprimirCadena
    LDR x1, =MensajeErrorCantidadFilas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadColumnas
    LDR x1, =msgErrorCantidadColumnas
    MOV x2, #25
    BL f01ImprimirCadena
    LDR x1, =MensajeErrorCantidadColumnas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeErrorCantidadMinas
    LDR x1, =msgErrorCantidadMinas
    MOV x2, #21
    BL f01ImprimirCadena
    LDR x1, =MensajeErrorCantidadMinas
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MenuAccion
    LDR x1, =msgMenuAccion
    MOV x2, #11
    BL f01ImprimirCadena
    LDR x1, =MenuAccion
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeFila
    LDR x1, =msgFila
    MOV x2, #12
    BL f01ImprimirCadena
    LDR x1, =MensajeFila
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeColumna
    LDR x1, =msgColumna
    MOV x2, #15
    BL f01ImprimirCadena
    LDR x1, =MensajeColumna
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeDerrota
    LDR x1, =msgDerrota
    MOV x2, #13
    BL f01ImprimirCadena
    LDR x1, =MensajeDerrota
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // MensajeVictoria
    LDR x1, =msgVictoria
    MOV x2, #15
    BL f01ImprimirCadena
    LDR x1, =MensajeVictoria
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloVacio
    LDR x1, =msgSimboloVacio
    MOV x2, #13
    BL f01ImprimirCadena
    LDR x1, =SimboloVacio
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloMina
    LDR x1, =msgSimboloMina
    MOV x2, #12
    BL f01ImprimirCadena
    LDR x1, =SimboloMina
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // SimboloBandera
    LDR x1, =msgSimboloBandera
    MOV x2, #16
    BL f01ImprimirCadena
    LDR x1, =SimboloBandera
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
    // NuevaLinea
    LDR x1, =msgNuevaLinea
    MOV x2, #12
    BL f01ImprimirCadena
    LDR x1, =NuevaLinea
    BL f05LongitudCadena
    MOV x0, x0
    BL print_long
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
