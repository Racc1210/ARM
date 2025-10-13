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
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f08DescubrirCelda_fin
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        // Verificar límites
        CMP x0, #0
        BLT f08DescubrirCelda_fin
        CMP x0, x10
        BGE f08DescubrirCelda_fin
        CMP x1, #0
        BLT f08DescubrirCelda_fin
        CMP x1, x11
        BGE f08DescubrirCelda_fin
        
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
        CMP w15, w17
        BEQ f08DescubrirCelda_fin // Si ya está descubierta, no hacer nada
        
        // Guardar coordenadas para usar después
        MOV x20, x0  // fila
        MOV x21, x1  // columna
        
        // Contar minas cercanas
        BL f12ContarMinasCercanas
        MOV x22, x0  // guardar cantidad de minas cercanas
        
        // Marcar como descubierta
        STRB w17, [x14, #1]
        
        // Si no hay minas cercanas, activar cascada
        CMP x22, #0
        BNE f08DescubrirCelda_fin
        
        // Llamar a cascada
        MOV x0, x20  // restaurar fila
        MOV x1, x21  // restaurar columna
        BL f11DescubrirCascada
        
f08DescubrirCelda_fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f11DescubrirCascada
// VERSION SIMPLIFICADA Y SEGURA - Solo revela vecinos inmediatos
// Entrada: x0 = fila, x1 = columna
// -------------------------------------------------
f11DescubrirCascada:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f11_fin
        
        // Obtener configuración del tablero
        LDR x10, =FilasSel
        LDR x10, [x10]      // x10 = filas
        LDR x11, =ColumnasSel
        LDR x11, [x11]      // x11 = columnas
        
        // Guardar coordenadas originales
        MOV x20, x0  // fila original
        MOV x21, x1  // columna original
        
        // Verificar límites de la celda original
        CMP x20, #0
        BLT f11_fin
        CMP x20, x10
        BGE f11_fin
        CMP x21, #0
        BLT f11_fin
        CMP x21, x11
        BGE f11_fin
        
        // Revelar solo los 8 vecinos inmediatos sin recursión
        // Llamar a función auxiliar para cada dirección
        
        // Arriba-izquierda
        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f11_reveal_single_cell
        
        // Arriba
        MOV x0, x20
        SUB x1, x21, #1
        BL f11_reveal_single_cell
        
        // Arriba-derecha
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f11_reveal_single_cell
        
        // Izquierda
        SUB x0, x20, #1
        MOV x1, x21
        BL f11_reveal_single_cell
        
        // Derecha
        ADD x0, x20, #1
        MOV x1, x21
        BL f11_reveal_single_cell
        
        // Abajo-izquierda
        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f11_reveal_single_cell
        
        // Abajo
        MOV x0, x20
        ADD x1, x21, #1
        BL f11_reveal_single_cell
        
        // Abajo-derecha
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f11_reveal_single_cell
        
f11_fin:
        ldp x29, x30, [sp], 16
        RET

// Función auxiliar para revelar una sola celda
// Entrada: x0=fila, x1=columna
f11_reveal_single_cell:
        // Verificar límites
        CMP x0, #0
        BLT f11_reveal_end
        CMP x0, x10
        BGE f11_reveal_end
        CMP x1, #0
        BLT f11_reveal_end
        CMP x1, x11
        BGE f11_reveal_end
        
        // Calcular offset
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        
        // Leer estado
        LDRB w4, [x3, #1]
        
        // Solo procesar celdas ocultas
        LDR x5, =ESTADO_OCULTA
        LDR w5, [x5]
        CMP w4, w5
        BNE f11_reveal_end
        
        // Marcar como descubierta
        LDR x6, =ESTADO_DESCUBIERTA
        LDR w6, [x6]
        STRB w6, [x3, #1]
        
f11_reveal_end:
        RET

// -------------------------------------------------
// f12ContarMinasCercanas
// VERSION SEGURA - Cuenta minas cercanas con verificaciones robustas
// Entrada: x0 = fila, x1 = columna
// Salida: x0 = cantidad de minas cercanas
// -------------------------------------------------
f12ContarMinasCercanas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f12_error
        
        // Guardar parámetros originales
        MOV x20, x0  // fila original
        MOV x21, x1  // columna original
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        // Verificar que las coordenadas estén en rango
        CMP x20, #0
        BLT f12_error
        CMP x20, x10
        BGE f12_error
        CMP x21, #0
        BLT f12_error
        CMP x21, x11
        BGE f12_error
        
        MOV x22, #0 // contador de minas
        
        // Revisar solo las 8 direcciones válidas
        // Arriba-izquierda (-1,-1)
        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Arriba (0,-1)
        MOV x0, x20
        SUB x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Arriba-derecha (1,-1)
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Izquierda (-1,0)
        SUB x0, x20, #1
        MOV x1, x21
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Derecha (1,0)
        ADD x0, x20, #1
        MOV x1, x21
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Abajo-izquierda (-1,1)
        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Abajo (0,1)
        MOV x0, x20
        ADD x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        // Abajo-derecha (1,1)
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f12_check_single_cell
        ADD x22, x22, x0
        
        MOV x0, x22  // retornar contador
        ldp x29, x30, [sp], 16
        RET

f12_error:
        MOV x0, #0  // retornar 0 si hay error
        ldp x29, x30, [sp], 16
        RET

// Función auxiliar que verifica una sola celda
// Entrada: x0=fila, x1=columna
// Salida: x0=1 si hay mina, 0 si no
f12_check_single_cell:
        // Verificar límites
        CMP x0, #0
        BLT f12_cell_no_mine
        CMP x0, x10
        BGE f12_cell_no_mine
        CMP x1, #0
        BLT f12_cell_no_mine
        CMP x1, x11
        BGE f12_cell_no_mine
        
        // Calcular offset y leer mina
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        LDRB w4, [x3]  // leer byte de mina
        
        // Retornar 1 si hay mina, 0 si no
        CMP w4, #1
        BEQ f12_cell_has_mine
        
f12_cell_no_mine:
        MOV x0, #0
        RET
        
f12_cell_has_mine:
        MOV x0, #1
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
        .extern MinasSel
        .extern f02NumeroAleatorio
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
        // Verificar que brk fue exitoso
        CMP x0, x13       // ¿la nueva dirección es >= la antigua?
        BLT init_tablero_error  // si es menor, falló
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

init_tablero_error:
        // Error en reserva de memoria - salir del programa
        MOV x0, #1        // código de error
        MOV x8, #93       // syscall exit
        SVC #0
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
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Reservar buffer local para 2 dígitos hex
        SUB sp, sp, #8
        MOV x1, x0
        LSR x2, x1, #4
        AND x2, x2, #0xF
        ADD x2, x2, #'0'
        CMP x2, #'9'
        BLE .phb_ok1
        ADD x2, x2, #7
.phb_ok1:
        STRB w2, [sp]
        AND x2, x1, #0xF
        ADD x2, x2, #'0'
        CMP x2, #'9'
        BLE .phb_ok2
        ADD x2, x2, #7
.phb_ok2:
        STRB w2, [sp, #1]
        // Imprimir los 2 caracteres
        MOV x8, #64
        MOV x0, #1
        MOV x1, sp
        MOV x2, #2
        SVC #0
        ADD sp, sp, #8
        ldp x29, x30, [sp], 16
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
