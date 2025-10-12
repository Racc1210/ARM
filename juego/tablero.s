        .global f02ColocarMinas
        .global f04DescubrirCelda
        .global f06Victoria
        .global f07ColocarBandera

// -------------------------------------------------
// Stubs mínimos para evitar errores de linker
// -------------------------------------------------
f02ColocarMinas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // TODO: lógica de colocación de minas
        ldp x29, x30, [sp], 16
        RET

f04DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // TODO: lógica de descubrir celda
        ldp x29, x30, [sp], 16
        RET

f06Victoria:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // TODO: lógica de victoria
        ldp x29, x30, [sp], 16
        RET

f07ColocarBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // TODO: lógica de colocar/quitar bandera
        ldp x29, x30, [sp], 16
        RET
// =====================================
// Tablero ARM64: estructura y funciones mínimas
// =====================================

        .section .bss
        .global Tablero
// Cada celda: 2 bytes (mina, estado)
Tablero:
        .skip 30*24*2   // Tamaño máximo: 30 filas x 24 columnas (2 bytes por celda)

        .section .bss
        .global BufferSimbolo
BufferSimbolo:
        .skip 8
        .section .text
        .global f01InicializarTablero
        .global f03ImprimirTablero

        .extern FilasSel
        .extern ColumnasSel
        .extern SimboloVacio, LargoSimboloVacioVal
        .extern SimboloMina, LargoSimboloMinaVal
        .extern SimboloBandera, LargoSimboloBanderaVal
        .extern NuevaLinea, LargoNuevaLineaVal
        .extern Espacio, LargoEspacioVal
        .extern f01ImprimirCadena

// -------------------------------------------------
// f01InicializarTablero
// Inicializa todas las celdas: mina=0, estado=0
// Usa FilasSel y ColumnasSel
// -------------------------------------------------
f01InicializarTablero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x0, [x10]      // x0 = filas
        LDR x11, =ColumnasSel
        LDR x1, [x11]      // x1 = columnas
        LDR x12, =Tablero
        MOV x3, #0         // fila
init_tablero_filas:
        CMP x3, x0
        B.GE init_tablero_fin
        MOV x4, #0         // columna
init_tablero_columnas:
        CMP x4, x1
        B.GE init_tablero_nextfila
        // Calcular offset base: offset = 2 * (fila * columnas + columna)
        MUL x5, x3, x1
        ADD x5, x5, x4
        LSL x5, x5, #1     // x5 = x5 * 2
        ADD x6, x12, x5    // dirección base de celda
        MOV w7, #0         // mina = 0
        STRB w7, [x6]
        MOV w7, #0         // estado = 0
        STRB w7, [x6, #1]
        ADD x4, x4, #1
        B init_tablero_columnas
init_tablero_nextfila:
        ADD x3, x3, #1
        B init_tablero_filas
init_tablero_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f03ImprimirTablero
// Imprime el estado actual del tablero como matriz de sublistas
// Usa FilasSel y ColumnasSel
// -------------------------------------------------
f03ImprimirTablero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x0, [x10]      // x0 = filas
        LDR x11, =ColumnasSel
        LDR x1, [x11]      // x1 = columnas
        LDR x12, =Tablero
        MOV x20, #0        // fila actual
print_tablero_filas:
        CMP x20, x0
        B.GE print_tablero_fin_directo
        MOV x21, #0        // columna actual
print_tablero_columnas:
        CMP x21, x1
        B.GE print_tablero_fin_fila
        // Calcular offset base: offset = 2 * (fila * columnas + columna)
        MUL x5, x20, x1
        ADD x5, x5, x21
        LSL x5, x5, #1     // x5 = x5 * 2
        ADD x6, x12, x5    // dirección base de celda
        // Leer mina y estado
        LDRB w7, [x6]      // mina
        LDRB w8, [x6, #1]  // estado
        // Seleccionar símbolo a imprimir
        CMP w8, #0
        BEQ print_simbolo_vacio
        CMP w8, #1
        BEQ print_simbolo_descubierta
        CMP w8, #2
        BEQ print_simbolo_bandera
        B print_simbolo_vacio
print_simbolo_vacio:
        LDR x1, =SimboloVacio
        LDR x2, =LargoSimboloVacioVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x21, x21, #1
        B print_tablero_columnas
print_simbolo_descubierta:
        CMP w7, #1
        BEQ print_simbolo_mina
        // Si no hay mina, imprimir espacio
        MOV w9, #' '
        SUB sp, sp, #8
        STRB w9, [sp]
        MOV x1, sp
        MOV x2, #1
        BL f01ImprimirCadena
        ADD sp, sp, #8
        ADD x21, x21, #1
        B print_tablero_columnas
print_simbolo_mina:
        LDR x1, =SimboloMina
        LDR x2, =LargoSimboloMinaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x21, x21, #1
        B print_tablero_columnas
print_simbolo_bandera:
        LDR x1, =SimboloBandera
        LDR x2, =LargoSimboloBanderaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x21, x21, #1
        B print_tablero_columnas
print_tablero_fin_fila:
        // Imprimir salto de línea
        LDR x1, =NuevaLinea
        LDR x2, =LargoNuevaLineaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ADD x20, x20, #1
        B print_tablero_filas
print_tablero_fin_directo:
        ldp x29, x30, [sp], 16
        RET
