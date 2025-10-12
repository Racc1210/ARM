        .global f11DescubrirCascada
        .global f08DescubrirCelda
        .global f09ColocarBandera
        .global f10HayMina
        .global f99DiagnosticoTablero
// -------------------------------------------------
// f08DescubrirCelda
// Descubre la celda en (fila, columna)
// Entrada: x0 = fila, x1 = columna
// Modifica el estado a DESCUBIERTA si no tiene bandera
// -------------------------------------------------
f08DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =Tablero
        // Calcular offset base: offset = 2 * (fila * columnas + columna)
        MUL x13, x0, x11
        ADD x13, x13, x1
        LSL x13, x13, #1
        ADD x14, x12, x13
        // Leer estado actual
        LDRB w15, [x14, #1]
        LDR x16, =ESTADO_BANDERA
        LDR w16, [x16]
        CMP w15, w16
        BEQ f08DescubrirCelda_fin // Si tiene bandera, no descubrir
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        STRB w17, [x14, #1] // Marcar como descubierta
        // Calcular minas cercanas
        MOV x20, x0 // fila
        MOV x21, x1 // columna
        MOV x0, x20
        MOV x1, x21
        BL f12ContarMinasCercanas
        CMP x0, #0
        BNE f08DescubrirCelda_fin
        // Si no hay minas cercanas, descubrir en cascada
        MOV x0, x14 // dirección de celda actual
        BL f11DescubrirCascada
f08DescubrirCelda_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f11DescubrirCascada
// Descubre en cascada celdas vacías y con número
// Entrada: x0 = dirección de celda actual
// -------------------------------------------------
f11DescubrirCascada:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Obtener fila y columna desde dirección de celda
        LDR x12, =Tablero
        SUB x13, x0, x12
        LSR x13, x13, #1
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        UDIV x14, x13, x11 // fila
        MSUB x15, x14, x11, x13 // columna
        // Recorrer vecinos (-1,0,+1 en fila y columna)
        MOV x16, #-1
f11Cascada_fila_loop:
        CMP x16, #2
        B.GE f11DescubrirCascada_fin
        ADD x17, x14, x16 // fila vecina
        CMP x17, #0
        BLT f11Cascada_next_fila
        CMP x17, x10
        BGE f11Cascada_next_fila
        MOV x18, #-1
f11Cascada_columna_loop:
        CMP x18, #2
        B.GE f11Cascada_next_fila
        ADD x19, x15, x18 // columna vecina
        CMP x19, #0
        BLT f11Cascada_next_columna
        CMP x19, x11
        BGE f11Cascada_next_columna
        // Calcular dirección de celda vecina
        MUL x20, x17, x11
        ADD x20, x20, x19
        LSL x20, x20, #1
        ADD x21, x12, x20
        // Leer estado
        LDRB w22, [x21, #1]
        LDR x23, =ESTADO_OCULTA
        LDR w23, [x23]
        CMP w22, w23
        BNE f11Cascada_next_columna // Solo descubrir si está oculta
        // Descubrir celda vecina
        MOV x0, x17
        MOV x1, x19
        BL f08DescubrirCelda
f11Cascada_next_columna:
        ADD x18, x18, #1
        B f11Cascada_columna_loop
f11Cascada_next_fila:
        ADD x16, x16, #1
        B f11Cascada_fila_loop
f11DescubrirCascada_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f12ContarMinasCercanas
// Cuenta minas cercanas a una celda
// Entrada: x0 = fila, x1 = columna
// Salida: x0 = cantidad de minas cercanas
// -------------------------------------------------
f12ContarMinasCercanas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =Tablero
        MOV x2, #0 // contador de minas
        MOV x13, #-1
f12MinasCercanas_fila_loop:
        CMP x13, #2
        B.GE f12ContarMinasCercanas_fin
        ADD x14, x0, x13 // fila vecina
        CMP x14, #0
        BLT f12MinasCercanas_next_fila
        CMP x14, x10
        BGE f12MinasCercanas_next_fila
        MOV x15, #-1
f12MinasCercanas_columna_loop:
        CMP x15, #2
        B.GE f12MinasCercanas_next_fila
        ADD x16, x1, x15 // columna vecina
        CMP x16, #0
        BLT f12MinasCercanas_next_columna
        CMP x16, x11
        BGE f12MinasCercanas_next_columna
        // Saltar la celda central
        CMP x13, #0
        CBNZ x13, f12MinasCercanas_check
        CMP x15, #0
        CBNZ x15, f12MinasCercanas_check
        B f12MinasCercanas_next_columna
f12MinasCercanas_check:
        MUL x17, x14, x11
        ADD x17, x17, x16
        LSL x17, x17, #1
        ADD x18, x12, x17
        LDRB w19, [x18] // mina
        CMP w19, #1
        BNE f12MinasCercanas_next_columna
        ADD x2, x2, #1
f12MinasCercanas_next_columna:
        ADD x15, x15, #1
        B f12MinasCercanas_columna_loop
f12MinasCercanas_next_fila:
        ADD x13, x13, #1
        B f12MinasCercanas_fila_loop
f12ContarMinasCercanas_fin:
        MOV x0, x2
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f09ColocarBandera
// Coloca o quita bandera en (fila, columna)
// Entrada: x0 = fila, x1 = columna
// Si está oculta, pone bandera; si tiene bandera, la quita
// -------------------------------------------------
f09ColocarBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =Tablero
        MUL x13, x0, x11
        ADD x13, x13, x1
        LSL x13, x13, #1
        ADD x14, x12, x13
        LDRB w15, [x14, #1]
        LDR x16, =ESTADO_BANDERA
        LDR w16, [x16]
        CMP w15, w16
        BEQ f09QuitarBandera
        // Si está oculta, poner bandera
        LDR x17, =ESTADO_OCULTA
        LDR w17, [x17]
        CMP w15, w17
        BEQ f09PonerBandera
        B f09ColocarBandera_fin
f09PonerBandera:
        STRB w16, [x14, #1]
        B f09ColocarBandera_fin
f09QuitarBandera:
        LDR x18, =ESTADO_OCULTA
        LDR w18, [x18]
        STRB w18, [x14, #1]
f09ColocarBandera_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f10HayMina
// Consulta si la celda (fila, columna) tiene mina
// Entrada: x0 = fila, x1 = columna
// Salida: x0 = 1 si hay mina, 0 si no
// -------------------------------------------------
f10HayMina:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =Tablero
        MUL x13, x0, x11
        ADD x13, x13, x1
        LSL x13, x13, #1
        ADD x14, x12, x13
        LDRB w15, [x14] // primer byte: mina
        MOV x0, x15
        ldp x29, x30, [sp], 16
        RET
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
        // Colocar minas aleatorias en el tablero
        LDR x4, =FilasSel
        LDR x4, [x4]      // filas
        LDR x5, =ColumnasSel
        LDR x5, [x5]      // columnas
        LDR x6, =MinasSel
        LDR x6, [x6]      // minas
        LDR x7, =Tablero
        MOV x8, #0        // contador de minas colocadas
f02ColocarMinas_loop:
        CMP x8, x6
        B.GE f02ColocarMinas_fin
        // Generar fila aleatoria
        MOV x0, #0
        BL f02NumeroAleatorio
        UDIV x9, x0, x4
        MSUB x9, x9, x4, x0
        // Generar columna aleatoria
        MOV x0, #0
        BL f02NumeroAleatorio
        UDIV x10, x0, x5
        MSUB x10, x10, x5, x0
        // Calcular offset de celda
        MUL x11, x9, x5
        ADD x11, x11, x10
        LSL x11, x11, #1
        ADD x12, x7, x11
        // Verificar si ya hay mina
        LDRB w13, [x12]
        CMP w13, #1
        BEQ f02ColocarMinas_loop // Si ya hay mina, intentar otra posición
        // Colocar mina
        MOV w13, #1
        STRB w13, [x12]
        ADD x8, x8, #1
        B f02ColocarMinas_loop
f02ColocarMinas_fin:
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
                .extern print_decimal
                .extern print_hex_byte

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
// -------------------------------------------------
// f99DiagnosticoTablero
// Imprime el buffer del tablero en formato hexadecimal (mina, estado)
// -------------------------------------------------
f99DiagnosticoTablero:
        // Imprimir encabezado de diagnóstico
        LDR x1, =diag_tablero_msg
        MOV x2, #20
        MOV x8, #64
        MOV x0, #1
        SVC #0

        .section .rodata
diag_tablero_msg: .asciz "DIAGNOSTICO TABLERO\n"
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x20, [x10]      // x20 = filas
        LDR x11, =ColumnasSel
        LDR x21, [x11]      // x21 = columnas
        LDR x12, =Tablero
        MOV x4, #0         // fila actual
diag_tablero_fila_loop:
        CMP x4, x20
        B.GE diag_tablero_fin
        MOV x6, #0        // columna actual
diag_tablero_columna_loop:
        CMP x6, x21
        B.GE diag_tablero_nextfila
        MUL x13, x4, x21
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        LDRB w15, [x14]      // mina
        LDRB w16, [x14, #1]  // estado
        // Imprimir fila, columna, mina, estado
        // Formato: [F:x][C:y] M:0x.. E:0x..
        // Imprimir fila
        MOV x0, x4
        BL print_decimal
        // Imprimir columna
        MOV x0, x6
        BL print_decimal
        // Imprimir mina
        uxtb x0, w15
        BL print_hex_byte
        // Imprimir estado
        uxtb x0, w16
        BL print_hex_byte
        // Imprimir espacio
        MOV w23, #' '
        MOV x8, #64
        MOV x0, #1
        LDR x1, =Espacio
        MOV x2, #1
        SVC #0
        ADD x6, x6, #1
        B diag_tablero_columna_loop
diag_tablero_nextfila:
        // Imprimir salto de línea
        MOV w24, #10
        MOV x8, #64
        MOV x0, #1
        LDR x1, =NuevaLinea
        MOV x2, #1
        SVC #0
        ADD x4, x4, #1
        B diag_tablero_fila_loop
diag_tablero_fin:
        ldp x29, x30, [sp], 16
        RET

// Rutina auxiliar para imprimir byte en hexadecimal
// x0 = byte
print_hex_byte:
        // Imprime 2 dígitos hex de x0
        // No usa stack
        MOV x1, x0
        LSR x2, x1, #4
        AND x2, x2, #0xF
        ADD x2, x2, #'0'
        CMP x2, #'9'
        BLE .phb_ok1
        ADD x2, x2, #7
.phb_ok1:
        MOV x8, #64
        MOV x0, #1
        MOV x1, sp
        STRB w2, [x1]
        MOV x2, #1
        SVC #0
        AND x2, x1, #0xF
        ADD x2, x2, #'0'
        CMP x2, #'9'
        BLE .phb_ok2
        ADD x2, x2, #7
.phb_ok2:
        MOV x8, #64
        MOV x0, #1
        MOV x1, sp
        STRB w2, [x1]
        MOV x2, #1
        SVC #0
        RET
f03ImprimirTablero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Obtener cantidad de filas y columnas
        LDR x10, =FilasSel
        LDR x20, [x10]      // x20 = filas
        LDR x11, =ColumnasSel
        LDR x21, [x11]      // x21 = columnas
        // Recorrer filas
        MOV x4, #0         // fila actual
f03ImprimirTablero_fila_loop:
        CMP x4, x20
        B.GE f03ImprimirTablero_fin
        // Crear cadena dinámica para la fila
        // Obtener heap actual
        MOV x8, #214      // syscall brk
        MOV x0, #0
        SVC #0
        MOV x3, x0        // x3 = base heap
        // Reservar espacio: columnas*3 + 1 (símbolo + 2 espacios por celda + salto de línea)
        MOV x5, x21        // x5 = columnas
        MOV x22, #3
        MUL x5, x5, x22    // x5 = columnas * 3
        ADD x5, x5, #1     // x5 = columnas * 3 + 1
        ADD x0, x3, x5
        MOV x8, #214
        SVC #0
        // Recorrer columnas
        MOV x6, #0        // columna actual
        MOV x7, #0        // índice en cadena
f03ImprimirTablero_columna_loop:
        CMP x6, x21
        B.GE f03ImprimirTablero_cadena_fin
        // Calcular offset de celda
        LDR x12, =Tablero
        MUL x13, x4, x21
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        // Leer mina y estado
        LDRB w15, [x14]      // mina
        LDRB w16, [x14, #1]  // estado
        // Determinar símbolo
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        LDR x18, =ESTADO_BANDERA
        LDR w18, [x18]
        LDR x19, =SimboloVacio
        LDRB w19, [x19]
        LDR x23, =SimboloMina
        LDRB w24, [x23]
        LDR x25, =SimboloBandera
        LDRB w26, [x25]
        MOV w22, w19        // por defecto: vacío
        CMP w16, w18        // ¿bandera?
        BEQ f03ImprimirTablero_bandera
        CMP w16, w17        // ¿descubierta?
        BEQ f03ImprimirTablero_descubierta
        B f03ImprimirTablero_simbolo
f03ImprimirTablero_bandera:
        MOV w22, w26      // símbolo bandera
        B f03ImprimirTablero_simbolo
f03ImprimirTablero_descubierta:
        CMP w15, #1        // ¿mina?
        BEQ f03ImprimirTablero_mina
        // Calcular número de minas cercanas
        MOV x27, x4        // fila
        MOV x28, x6        // columna
        MOV x0, x27
        MOV x1, x28
        BL f12ContarMinasCercanas
        CMP x0, #0
        BEQ f03ImprimirTablero_vacia
        // Convertir número a carácter ASCII ('1'..'8')
        ADD w22, w0, #'0'
        B f03ImprimirTablero_simbolo
f03ImprimirTablero_vacia:
        MOV w22, w19       // símbolo vacío
        B f03ImprimirTablero_simbolo
f03ImprimirTablero_mina:
        MOV w22, w24      // símbolo mina
        B f03ImprimirTablero_simbolo
f03ImprimirTablero_simbolo:
        STRB w22, [x3, x7] // símbolo
        ADD x7, x7, #1
        MOV w23, #' '
        STRB w23, [x3, x7] // espacio
        ADD x7, x7, #1
        STRB w23, [x3, x7] // segundo espacio
        ADD x7, x7, #1
        ADD x6, x6, #1
        B f03ImprimirTablero_columna_loop
f03ImprimirTablero_cadena_fin:
        MOV w24, #10       // salto de línea
        STRB w24, [x3, x7]
        ADD x7, x7, #1
        MOV x1, x3         // buffer
        MOV x2, x7         // longitud
        BL f01ImprimirCadena
        ADD x4, x4, #1
        B f03ImprimirTablero_fila_loop
f03ImprimirTablero_fin:
        ldp x29, x30, [sp], 16
        RET
