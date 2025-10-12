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
        .extern f06CrearCadenaDinamica, f07ImprimirCadenaNVeces

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
        // Obtener cantidad de filas y columnas
        LDR x10, =FilasSel
        LDR x20, [x10]      // x20 = filas
        LDR x11, =ColumnasSel
        LDR x21, [x11]      // x21 = columnas
        // Crear cadena de una fila con símbolo vacío
        LDR x12, =SimboloVacio
        LDRB w13, [x12]    // w13 = símbolo vacío
        MOV x2, x21         // cantidad de columnas
        MOV w1, w13        // carácter a repetir
        BL f06CrearCadenaDinamica
        // x3 = dirección de la cadena, x2 = longitud
        MOV x4, #1         // índice de fila
        B f03ImprimirTablero_check
f03ImprimirTablero_next:
        ADD x4, x4, #1     // incrementar índice de fila
f03ImprimirTablero_check:
        CMP x4, x0         // ¿imprimimos todas las filas?
        B.GE f03ImprimirTablero_fin
        // Imprimir la cadena dinámica (una fila)
        MOV x1, x3         // buffer
        MOV x2, x2         // longitud
        BL f01ImprimirCadena
        B f03ImprimirTablero_next
f03ImprimirTablero_fin:
        ldp x29, x30, [sp], 16
        RET