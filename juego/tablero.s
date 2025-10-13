        .global f11DescubrirCascada
        .global f08DescubrirCelda
        .global f09ColocarBandera
        // ...sin lógica de minas...
        // ...sin diagnóstico...
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
        LDR x12, =TableroPtr
        LDR x12, [x12]
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
        LDR x12, =TableroPtr
        LDR x12, [x12]
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
        // Saltar la celda central
        CMP x16, #0
        CBNZ x16, .check_celda
        CMP x18, #0
        CBNZ x18, .check_celda
        B f11Cascada_next_columna
.check_celda:
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
        BNE f11Cascada_next_columna // Solo procesar si está oculta
        // Marcar como descubierta antes de expandir
        LDR x24, =ESTADO_DESCUBIERTA
        LDR w24, [x24]
        STRB w24, [x21, #1]
        // Contar minas cercanas
        MOV x0, x17
        MOV x1, x19
        BL f12ContarMinasCercanas
        MOV x22, x0 // guardar cantidad de minas cercanas
        // Si no hay minas cercanas, expandir cascada
        CMP x22, #0
        BNE f11Cascada_next_columna
        // Llamar recursivamente para expandir desde celdas vacías
        MUL x20, x17, x11
        ADD x20, x20, x19
        LSL x20, x20, #1
        ADD x21, x12, x20
        MOV x0, x21
        BL f11DescubrirCascada
        B f11Cascada_next_columna
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
        LDR x12, =TableroPtr
        LDR x12, [x12]
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
        LDR x12, =TableroPtr
        LDR x12, [x12]
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

        // ...sin lógica de minas...
        .global f04DescubrirCelda
        .global f06Victoria
        .global f07ColocarBandera

        // ...sin lógica de minas...

f04DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // x0 = fila, x1 = columna
        BL f08DescubrirCelda
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
        // x0 = fila, x1 = columna
        BL f09ColocarBandera
        ldp x29, x30, [sp], 16
        RET
// =====================================
// Tablero ARM64: estructura y funciones mínimas
// =====================================

        .section .bss
        .global TableroPtr
// TableroPtr: dirección dinámica del tablero
TableroPtr: .skip 8

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
        LDR x10, [x10]      // x10 = filas
        LDR x11, =ColumnasSel
        LDR x11, [x11]      // x11 = columnas
        // Calcular tamaño: filas * columnas * 2
        MUL x12, x10, x11
        LSL x12, x12, #1
        // Reservar memoria dinámica con brk
        MOV x8, #214      // syscall brk
        MOV x0, #0        // obtener heap actual
        SVC #0
        MOV x13, x0       // base actual del heap
        ADD x0, x13, x12  // nueva base = base + tamaño
        MOV x8, #214      // syscall brk
        SVC #0
        // Guardar dirección base en TableroPtr
        LDR x14, =TableroPtr
        STR x13, [x14]
        // Inicializar tablero dinámico
        MOV x3, #0         // fila
init_tablero_filas:
        CMP x3, x10
        B.GE init_tablero_fin
        MOV x4, #0         // columna
init_tablero_columnas:
        CMP x4, x11
        B.GE init_tablero_nextfila
        // Calcular offset: 2 * (fila * columnas + columna)
        MUL x15, x3, x11
        ADD x15, x15, x4
        LSL x15, x15, #1
        LDR x16, =TableroPtr
        LDR x16, [x16]
        ADD x17, x16, x15
        MOV w18, #0        // mina=0
        STRB w18, [x17]
        MOV w18, #0        // estado=0
        STRB w18, [x17, #1]
        ADD x4, x4, #1
        B init_tablero_columnas
init_tablero_nextfila:
        ADD x3, x3, #1
        B init_tablero_filas
init_tablero_fin:
         // Colocar minas aleatorias
         BL f02ColocarMinasAleatorias
        ldp x29, x30, [sp], 16
        RET
// -------------------------------------------------
// f02ColocarMinasAleatorias
// Coloca MinasSel minas en posiciones aleatorias del tablero
// Usa f02NumeroAleatorio de utilidades.s
// -------------------------------------------------
f02ColocarMinasAleatorias:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]      // x10 = filas
        LDR x11, =ColumnasSel
        LDR x11, [x11]      // x11 = columnas
        LDR x12, =MinasSel
        LDR x12, [x12]      // x12 = minas
        LDR x13, =TableroPtr
        LDR x13, [x13]      // x13 = base tablero
        MOV x14, #0         // contador de minas colocadas
        MOV x20, #0         // contador de intentos
        MOV x21, #10000     // máximo de intentos
minas_loop:
        CMP x14, x12
        B.GE minas_fin
        CMP x20, x21
        B.GE minas_fin      // Si se exceden los intentos, salir
        // Generar fila aleatoria
        MOV x0, x10
        BL f02NumeroAleatorio
        UDIV x15, x0, x10
        MSUB x15, x15, x10, x0
        // Generar columna aleatoria
        MOV x0, x11
        BL f02NumeroAleatorio
        UDIV x16, x0, x11
        MSUB x16, x16, x11, x0
        // Calcular offset: 2 * (fila * columnas + columna)
        MUL x17, x15, x11
        ADD x17, x17, x16
        LSL x17, x17, #1
        ADD x18, x13, x17
        // Verificar si ya hay mina
        LDRB w19, [x18]
        CMP w19, #1
        ADD x20, x20, #1   // incrementar intentos
        BEQ minas_loop // Si ya hay mina, repetir
        // Colocar mina
        MOV w19, #1
        STRB w19, [x18]
        ADD x14, x14, #1
        ADD x20, x20, #1   // incrementar intentos
        B minas_loop
minas_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f03ImprimirTablero
// Imprime el estado actual del tablero como matriz de sublistas
// Usa FilasSel y ColumnasSel
// -------------------------------------------------

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
        // Recorrer columnas y construir la cadena dinámicamente
        MOV x6, #0        // columna actual
        MOV x7, #0        // índice en cadena
        B .col_loop_start
.col_loop:
        ADD x6, x6, #1
.col_loop_start:
        CMP x6, x21
        B.GE .cadena_fin
        // Calcular offset de celda
        LDR x12, =TableroPtr
        LDR x12, [x12]
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
        BEQ .set_bandera
        CMP w16, w17        // ¿descubierta?
        BEQ .set_descubierta
        B .add_symbol
.set_bandera:
        MOV w22, w26      // símbolo bandera
        B .add_symbol
.set_descubierta:
        CMP w15, #1        // ¿mina?
        BEQ .set_mina
        // Calcular número de minas cercanas
        MOV x27, x4        // fila
        MOV x28, x6        // columna
        MOV x0, x27
        MOV x1, x28
        BL f12ContarMinasCercanas
        CMP x0, #0
        BEQ .set_vacia
        // Convertir número a carácter ASCII ('1'..'8')
        ADD w22, w0, #'0'
        B .add_symbol
.set_vacia:
        LDR x30, =Espacio
        LDRB w22, [x30]    // símbolo espacio
        B .add_symbol
.set_mina:
        MOV w22, w24      // símbolo mina
        B .add_symbol
.add_symbol:
        STRB w22, [x3, x7] // símbolo
        ADD x7, x7, #1
        MOV w23, #' '
        STRB w23, [x3, x7] // espacio
        ADD x7, x7, #1
        STRB w23, [x3, x7] // segundo espacio
        ADD x7, x7, #1
        B .col_loop
.cadena_fin:
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
