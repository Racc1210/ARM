        .section .bss
Tablero:
        .skip 720

        .section .text
        .global f01InicializarTablero
        .global f02ColocarMinas
        .global f03ImprimirTablero
        .global f04DescubrirCelda
        .global f05Derrota
        .global f06Victoria
        .global f07ColocarBandera

        // Dependencias de IO y utilidades
        .extern f01ImprimirCadena
        .extern f02NumeroAleatorio

        // Constantes (símbolos y longitudes en memoria)
        .extern SimboloVacio
        .extern LargoSimboloVacioVal
        .extern SimboloMina
        .extern LargoSimboloMinaVal
        .extern SimboloBandera
        .extern LargoSimboloBanderaVal
        .extern NuevaLinea
        .extern LargoNuevaLineaVal
        .extern MensajeDerrota
        .extern LargoMensajeDerrotaVal
        .extern MensajeVictoria
        .extern LargoMensajeVictoriaVal

// =====================================
// Inicializar tablero
// =====================================
f01InicializarTablero:
        MOV x3, #0
        MUL x4, x0, x1
        LDR x5, =Tablero
        LDR x6, =SimboloVacio
        LDRB w6, [x6]
f01InicializarTablero_loop:
        CMP x3, x4
        B.GE f01InicializarTablero_fin
        STRB w6, [x5, x3]
        ADD x3, x3, #1
        B f01InicializarTablero_loop
f01InicializarTablero_fin:
        RET

// =====================================
// Colocar minas
// =====================================
f02ColocarMinas:
        MUL x3, x0, x1
        MOV x4, x2
        LDR x5, =Tablero
f02ColocarMinas_loop:
        CMP x4, #0
        BEQ f02ColocarMinas_fin
        BL f02NumeroAleatorio
        UDIV x7, x0, x3
        MSUB x6, x7, x3, x0
        ADD x8, x5, x6
        LDRB w9, [x8]
        LDR x10, =SimboloMina
        LDRB w10, [x10]
        CMP w9, w10
        BEQ f02ColocarMinas_loop
        STRB w10, [x8]
        SUB x4, x4, #1
        B f02ColocarMinas_loop
f02ColocarMinas_fin:
        RET

// =====================================
// Imprimir tablero
// =====================================
f03ImprimirTablero:
        MOV x3, #0
        LDR x5, =Tablero
f03ImprimirTablero_filas:
        CMP x3, x0
        B.GE f03ImprimirTablero_fin
        MOV x4, #0
f03ImprimirTablero_columnas:
        CMP x4, x1
        B.GE f03ImprimirTablero_nuevaLinea
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        ADD x1, x5, x6
        MOV x2, #1
        BL f01ImprimirCadena
        ADD x4, x4, #1
        B f03ImprimirTablero_columnas
f03ImprimirTablero_nuevaLinea:
        LDR x1, =NuevaLinea
        LDR x2, =LargoNuevaLineaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x3, x3, #1
        B f03ImprimirTablero_filas
f03ImprimirTablero_fin:
        RET

// =====================================
// Descubrir celda
// =====================================
f04DescubrirCelda:
        // (sin cambios en la lógica principal)
        // ...
        RET

// =====================================
// Derrota
// =====================================
f05Derrota:
        LDR x1, =MensajeDerrota
        LDR x2, =LargoMensajeDerrotaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        MOV x3, #0
        LDR x5, =Tablero
f05Derrota_filas:
        CMP x3, x0
        B.GE f05Derrota_fin
        MOV x4, #0
f05Derrota_columnas:
        CMP x4, x1
        B.GE f05Derrota_nuevaLinea
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        LDRB w8, [x7]
        LDR x9, =SimboloMina
        LDRB w9, [x9]
        CMP w8, w9
        BNE f05Derrota_imprimirCelda
        LDR x1, =SimboloMina
        LDR x2, =LargoSimboloMinaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f05Derrota_nextCol
f05Derrota_imprimirCelda:
        ADD x1, x5, x6
        MOV x2, #1
        BL f01ImprimirCadena
f05Derrota_nextCol:
        ADD x4, x4, #1
        B f05Derrota_columnas
f05Derrota_nuevaLinea:
        LDR x1, =NuevaLinea
        LDR x2, =LargoNuevaLineaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x3, x3, #1
        B f05Derrota_filas
f05Derrota_fin:
        MOV x0, #0
        MOV x8, #93          // syscall exit
        SVC #0

// =====================================
// Victoria
// =====================================
f06Victoria:
        // ... lógica de verificación ...
f06Victoria_ganar:
        LDR x1, =MensajeVictoria
        LDR x2, =LargoMensajeVictoriaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        MOV x0, #0
        MOV x8, #93
        SVC #0

// =====================================
// Colocar/Quitar bandera
// =====================================
f07ColocarBandera:
        // (sin cambios en la lógica principal)
        RET
