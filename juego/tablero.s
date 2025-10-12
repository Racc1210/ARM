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
Tablero:
        .skip 30*24   // Tamaño máximo: 30 filas x 24 columnas (1 byte por celda)

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
// Limpia el tablero: pone todas las celdas como vacías ('#')
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
        // Calcular offset: offset = fila * columnas + columna
        MUL x5, x3, x1
        ADD x5, x5, x4
        ADD x5, x12, x5
        // Escribir símbolo vacío ('#')
        LDR x6, =SimboloVacio
        LDRB w7, [x6]
        STRB w7, [x5]
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
// Imprime el estado actual del tablero
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
        LDR x13, =BufferSimbolo
        MOV x3, #0         // fila
print_tablero_filas_directo:
        CMP x3, x0
        B.GE print_tablero_fin_directo
        MOV x4, #0         // columna
print_tablero_columnas_directo:
        CMP x4, x1
        B.GE print_tablero_nuevaLinea_directo
        // Calcular offset: offset = fila * columnas + columna
        MUL x5, x3, x1
        ADD x5, x5, x4
        // Validar que offset < 30*24
        CMP x5, #(30*24)
        B.GE print_tablero_error
        ADD x5, x12, x5
        LDRB w6, [x5]      // símbolo de la celda
        // Imprimir el símbolo usando buffer fijo
        STRB w6, [x13]
        MOV x1, x13
        MOV x2, #1
        BL f01ImprimirCadena
        // No imprimir espacio entre símbolos
        ADD x4, x4, #1
        B print_tablero_columnas_directo
print_tablero_nuevaLinea_directo:
        // Imprimir salto de línea como carácter ASCII 0x0A usando buffer temporal
        MOV x1, x13
        MOV w7, #10        // 0x0A = 10 decimal
        STRB w7, [x1]
        MOV x2, #1
        BL f01ImprimirCadena
        ADD x3, x3, #1
        B print_tablero_filas_directo
print_tablero_fin_directo:
        ldp x29, x30, [sp], 16
        RET
print_tablero_error:
        // Error: offset fuera de rango
        ldp x29, x30, [sp], 16
        RET
