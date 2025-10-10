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
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Inicializar tablero con símbolo vacío
        MOV x10, x0
        MOV x11, x1
        MOV x3, #0
        MUL x4, x10, x11
                ADR x5, Tablero
                ADR x6, SimboloVacio
        LDRB w6, [x6]
f01InicializarTablero_loop:
        CMP x3, x4
        B.GE f01InicializarTablero_fin
        STRB w6, [x5, x3]
        ADD x3, x3, #1
        B f01InicializarTablero_loop
        // Rutina para imprimir número decimal en x0
        .section .text
print_decimal:
        SUB sp, sp, #16
        MOV x1, sp
        MOV x2, #0
        MOV x3, x0
        CMP x3, #0
        BNE .print_decimal_loop
        MOV w4, #'0'
        STRB w4, [x1]
        ADD x2, x2, #1
        B .print_decimal_done
.print_decimal_loop:
        MOV x4, #10
        UDIV x5, x3, x4
        MSUB x6, x5, x4, x3
        ADD w6, w6, #'0'
        STRB w6, [x1, x2]
        ADD x2, x2, #1
        MOV x3, x5
        CMP x3, #0
        BNE .print_decimal_loop
.print_decimal_done:
        MOV x4, #0
        MOV x5, x2
        SUB x5, x5, #1
.print_decimal_reverse:
        CMP x4, x5
        BGE .print_decimal_print
        LDRB w6, [x1, x4]
        LDRB w7, [x1, x5]
        STRB w7, [x1, x4]
        STRB w6, [x1, x5]
        ADD x4, x4, #1
        SUB x5, x5, #1
        B .print_decimal_reverse
.print_decimal_print:
        MOV x1, sp
        MOV x2, x2
        BL f01ImprimirCadena
        ADD sp, sp, #16
        RET
        .section .rodata
debug_tablero_filas:
        .asciz "TABLERO FILAS: "
debug_tablero_columnas:
        .asciz "TABLERO COLUMNAS: "
debug_tablero_indice:
        .asciz "INDICE: "
        .section .text
f01InicializarTablero_fin:
        ldp x29, x30, [sp], 16
        RET

// =====================================
// Colocar minas
// =====================================
f02ColocarMinas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Depuración: INICIO colocar minas
        ADR x1, debug_colocar_minas_ini
        MOV x2, #18
        BL f01ImprimirCadena
        MUL x3, x0, x1
        MOV x4, x2
        ADR x5, Tablero
f02ColocarMinas_loop:
        CMP x4, #0
        BEQ f02ColocarMinas_fin
        BL f02NumeroAleatorio
        UDIV x7, x0, x3
        MSUB x6, x7, x3, x0
        ADD x8, x5, x6
        LDRB w9, [x8]
        ADR x10, SimboloMina
        LDRB w10, [x10]
        CMP w9, w10
        BEQ f02ColocarMinas_loop
        STRB w10, [x8]
        SUB x4, x4, #1
        B f02ColocarMinas_loop
f02ColocarMinas_fin:
        // Depuración: FIN colocar minas
        ADR x1, debug_colocar_minas_fin
        MOV x2, #16
        BL f01ImprimirCadena
        ldp x29, x30, [sp], 16
        RET
        .section .rodata
debug_colocar_minas_ini:
        .asciz "INICIO COLOCAR MINAS"
debug_colocar_minas_fin:
        .asciz "FIN COLOCAR MINAS"

// =====================================
// Imprimir tablero
// =====================================
f03ImprimirTablero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x3, #0
        ADR x5, Tablero
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
        ADR x1, NuevaLinea
        LDR x2, =LargoNuevaLineaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x3, x3, #1
        B f03ImprimirTablero_filas
f03ImprimirTablero_fin:
        ldp x29, x30, [sp], 16
        RET

// =====================================
// Descubrir celda
// =====================================
f04DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MUL x4, x0, x3
        ADD x4, x4, x1
        ADR x5, Tablero
        ADD x6, x5, x4
        LDRB w7, [x6]
        ADR x10, SimboloMina
        LDRB w10, [x10]
        CMP w7, w10
        BEQ f04DescubrirCelda_mina
        ADR x11, SimboloVacio
        LDRB w11, [x11]
        CMP w7, w11
        BNE f04DescubrirCelda_fin
        MOV x8, #0
        MOV x9, #-1
f04DescubrirCelda_loopFila:
        CMP x9, #1
        BGT f04DescubrirCelda_guardar
        MOV x10, #-1
f04DescubrirCelda_loopCol:
        CMP x10, #1
        BGT f04DescubrirCelda_nextFila
        ADD x11, x0, x9
        ADD x12, x1, x10
        CMP x11, #0
        BLT f04DescubrirCelda_skip
        CMP x11, x2
        BGE f04DescubrirCelda_skip
        CMP x12, #0
        BLT f04DescubrirCelda_skip
        CMP x12, x3
        BGE f04DescubrirCelda_skip
        MUL x13, x11, x3
        ADD x13, x13, x12
        ADD x14, x5, x13
        LDRB w15, [x14]
        CMP w15, w10
        BNE f04DescubrirCelda_skip
        ADD x8, x8, #1
f04DescubrirCelda_skip:
        ADD x10, x10, #1
        B f04DescubrirCelda_loopCol
f04DescubrirCelda_nextFila:
        ADD x9, x9, #1
        B f04DescubrirCelda_loopFila
f04DescubrirCelda_guardar:
        CMP x8, #0
        BEQ f04DescubrirCelda_expandir
        ADD w7, w8, #'0'
        STRB w7, [x6]
        B f04DescubrirCelda_fin
f04DescubrirCelda_expandir:
        MOV w7, #'0'
        STRB w7, [x6]
        MOV x9, #-1
f04DescubrirCelda_expandFila:
        CMP x9, #1
        BGT f04DescubrirCelda_fin
        MOV x10, #-1
f04DescubrirCelda_expandCol:
        CMP x10, #1
        BGT f04DescubrirCelda_nextExpandFila
        ADD x11, x0, x9
        ADD x12, x1, x10
        CMP x11, #0
        BLT f04DescubrirCelda_skipExpand
        CMP x11, x2
        BGE f04DescubrirCelda_skipExpand
        CMP x12, #0
        BLT f04DescubrirCelda_skipExpand
        CMP x12, x3
        BGE f04DescubrirCelda_skipExpand
        MOV x0, x11
        MOV x1, x12
        MOV x2, x2
        MOV x3, x3
        BL f04DescubrirCelda
f04DescubrirCelda_skipExpand:
        ADD x10, x10, #1
        B f04DescubrirCelda_expandCol
f04DescubrirCelda_nextExpandFila:
        ADD x9, x9, #1
        B f04DescubrirCelda_expandFila
f04DescubrirCelda_mina:
        MOV x0, x2
        MOV x1, x3
        BL f05Derrota
f04DescubrirCelda_fin:
        ldp x29, x30, [sp], 16
        RET

// =====================================
// Derrota
// =====================================
f05Derrota:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =MensajeDerrota
        LDR x2, =LargoMensajeDerrotaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        MOV x3, #0
        ADR x5, Tablero
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

        // imprimir mina
        LDR x1, =SimboloMina
        LDR x2, =LargoSimboloMinaVal
        LDR x2, [x2]
                 ADR x9, SimboloMina
                 ADR x1, SimboloMina

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
        ldp x29, x30, [sp], 16
        SVC #0

// =====================================
// Victoria
// =====================================
f06Victoria:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x3, #0
        ADR x5, Tablero
f06Victoria_filas:
        CMP x3, x0
        B.GE f06Victoria_ganar
        MOV x4, #0
f06Victoria_columnas:
        CMP x4, x1
        B.GE f06Victoria_nextFila
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        LDRB w8, [x7]

        ADR x8, SimboloVacio
        LDRB w8, [x8]
        ADR x9, SimboloBandera
        LDRB w9, [x9]

        LDR x10, =SimboloMina
        LDRB w10, [x10]
        CMP w8, w10
        BEQ f06Victoria_nextCol

        ldp x29, x30, [sp], 16
        RET                     // aún quedan celdas ocultas → no victoria

f06Victoria_nextCol:
        ADD x4, x4, #1
        B f06Victoria_columnas

f06Victoria_nextFila:
        ADD x3, x3, #1
        B f06Victoria_filas

f06Victoria_ganar:
        ADR x1, MensajeVictoria
        ADR x2, LargoMensajeVictoriaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        MOV x0, #0
        MOV x8, #93
        ldp x29, x30, [sp], 16
        SVC #0

// =====================================
// Colocar/Quitar bandera
// =====================================
f07ColocarBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MUL x4, x0, x3
        ADD x4, x4, x1
        LDR x5, =Tablero
        ADD x6, x5, x4
        LDRB w7, [x6]

        ADR x9, SimboloVacio
        LDRB w9, [x9]
        ADR x10, SimboloMina
        LDRB w10, [x10]
        LDR x9, =SimboloBandera
        LDRB w9, [x9]
        STRB w9, [x6]
        ldp x29, x30, [sp], 16
        RET

f07ColocarBandera_checkFlag:
        LDR x10, =SimboloBandera
                ADR x10, SimboloBandera
                LDRB w10, [x10]
        CMP w7, w10
        BNE f07ColocarBandera_fin
                ADR x11, SimboloVacio
        LDRB w11, [x11]
        STRB w11, [x6]

f07ColocarBandera_fin:
        ldp x29, x30, [sp], 16
        RET
