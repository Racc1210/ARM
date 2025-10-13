// =====================================
// tablero.s - Lógica del tablero de buscaminas
// =====================================

// -------------------------------------------------
// Declaraciones globales
// -------------------------------------------------
        .global f01InicializarTablero
        .global f02ColocarMinasAleatorias
        .global f03ImprimirTablero
        .global f04DescubrirCelda
        .global f05ColocarBandera
        .global f06DescubrirCascada
        .global f07ContarMinasCercanas
        .global f08Victoria
        .global f09Derrota
        .global f10VerificarVictoria
        .global f11RevelarTodasMinas
        .global TableroPtr
        .global BufferSimbolo
        .global JuegoTerminado

// -------------------------------------------------
// Dependencias externas
// -------------------------------------------------
        .extern FilasSel
        .extern ColumnasSel
        .extern MinasSel
        .extern f01ImprimirCadena
        .extern f02NumeroAleatorio
        .extern f05LimpiarPantalla
        .extern ESTADO_OCULTA
        .extern ESTADO_DESCUBIERTA
        .extern ESTADO_BANDERA
        .extern MensajeVictoria
        .extern LargoMensajeVictoriaVal
        .extern MensajeDerrota
        .extern LargoMensajeDerrotaVal
        .extern SimboloVacio, SimboloMina, SimboloBandera, Espacio

// -------------------------------------------------
// Sección de datos no inicializados
// -------------------------------------------------
        .section .bss
TableroPtr:     .skip 8    // Puntero dinámico al tablero
BufferSimbolo:  .skip 8    // Buffer auxiliar
JuegoTerminado: .skip 8    // Bandera de fin de juego

// -------------------------------------------------
// f01InicializarTablero
// Inicializa todas las celdas: mina=0, estado=0
// Usa FilasSel y ColumnasSel
// -------------------------------------------------
        .section .text
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
        BLT f01error  // si es menor, falló
        // Guardar dirección base en TableroPtr
        LDR x14, =TableroPtr
        STR x13, [x14]
        // Inicializar tablero dinámico
        MOV x3, #0         // fila
f01for01:
        CMP x3, x10
        B.GE f01inicializado
        MOV x4, #0         // columna
f01for02:
        CMP x4, x11
        B.GE f01nextfila
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
        B f01for02
f01nextfila:
        ADD x3, x3, #1
        B f01for01
f01inicializado:
         // Colocar minas aleatorias
         BL f02ColocarMinasAleatorias
        ldp x29, x30, [sp], 16
        RET
f01error:
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
f02minasloop:
        CMP x14, x12
        B.GE f02fin
        CMP x20, x21
        B.GE f02fin      // Si se exceden los intentos, salir
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
        BEQ f02minasloop // Si ya hay mina, repetir
        // Colocar mina
        MOV w19, #1
        STRB w19, [x18]
        ADD x14, x14, #1
        ADD x20, x20, #1   // incrementar intentos
        B f02minasloop
f02fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f03ImprimirTablero
// Imprime el tablero con códigos ANSI visuales
// Limpia pantalla antes de mostrar
// -------------------------------------------------
f03ImprimirTablero:
        stp x29, x30, [sp, -64]!  // Alineación a 16 bytes
        mov x29, sp
        
        // Limpiar pantalla antes de imprimir
        BL f05LimpiarPantalla
        
        // Obtener cantidad de filas y columnas
        LDR x10, =FilasSel
        LDR x20, [x10]      // x20 = filas
        LDR x11, =ColumnasSel  
        LDR x21, [x11]      // x21 = columnas
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f03fin
        
        // Recorrer filas
        MOV x4, #0         // fila actual
        
f03filaloop:
        CMP x4, x20
        B.GE f03fin
        
        // Recorrer columnas de la fila actual
        MOV x6, #0        // columna actual
        
f03colloop:
        CMP x6, x21
        B.GE f03endrow
        
        // Calcular offset de celda: 2 * (fila * columnas + columna)
        MUL x13, x4, x21
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        // Leer estado de la celda
        LDRB w16, [x14, #1]  // estado
        
        // Determinar símbolo según estado
        MOV w22, #'#'        // por defecto: oculta (estado 0)
        
        CMP w16, #2          // ESTADO_BANDERA = 2
        BEQ f03bandera
        
        CMP w16, #1          // ESTADO_DESCUBIERTA = 1  
        BEQ f03descubierta
        B f03char
        
f03bandera:
        MOV w22, #'!'
        B f03char
        
f03descubierta:
        // Leer si tiene mina
        LDRB w15, [x14]      // mina
        CMP w15, #1
        BEQ f03mina
        
        // No tiene mina - contar minas cercanas
        // Guardar registros antes de llamar función
        stp x4, x6, [sp, #16]
        stp x12, x20, [sp, #32]
        str x21, [sp, #48]
        
        MOV x0, x4    // fila
        MOV x1, x6    // columna
        BL f07ContarMinasCercanas
        
        // Restaurar registros
        ldp x4, x6, [sp, #16]
        ldp x12, x20, [sp, #32]
        ldr x21, [sp, #48]
        
        // Determinar símbolo según cantidad de minas
        CMP x0, #0
        BEQ f03vacia
        
        // Convertir número a carácter ASCII ('1'..'8')
        ADD w22, w0, #'0'
        B f03char
        
f03mina:
        MOV w22, #'@'
        B f03char

f03vacia:
        MOV w22, #'_'
        
f03char:
        // Guardar registros en posiciones alineadas
        stp x4, x6, [sp, #16]
        stp x12, x20, [sp, #32]
        str x21, [sp, #48]
        
        // Imprimir símbolo usando posición alineada del stack
        STRB w22, [sp, #56]
        MOV x8, #64          // syscall write
        MOV x0, #1           // stdout
        ADD x1, sp, #56      // buffer alineado en stack
        MOV x2, #1           // 1 carácter
        SVC #0
        
        // Imprimir espacio
        MOV w23, #' '
        STRB w23, [sp, #56]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #56
        MOV x2, #1
        SVC #0
        
        // Restaurar registros
        ldp x4, x6, [sp, #16]
        ldp x12, x20, [sp, #32]
        ldr x21, [sp, #48]
        
        // Siguiente columna
        ADD x6, x6, #1
        B f03colloop
        
f03endrow:
        // Imprimir nueva línea
        MOV w24, #10  // '\n'
        STRB w24, [sp, #56]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #56
        MOV x2, #1
        SVC #0
        
        // Siguiente fila
        ADD x4, x4, #1
        B f03filaloop

f03fin:
        ldp x29, x30, [sp], 64
        RET

// -------------------------------------------------
// f04DescubrirCelda
// Descubre la celda en (fila, columna)
// Entrada: x0 = fila, x1 = columna
// Modifica el estado a DESCUBIERTA si no tiene bandera
// -------------------------------------------------
f04DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f04fin
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        // Verificar límites
        CMP x0, #0
        BLT f04fin
        CMP x0, x10
        BGE f04fin
        CMP x1, #0
        BLT f04fin
        CMP x1, x11
        BGE f04fin
        
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
        BEQ f04fin // Si tiene bandera, no descubrir
        
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        CMP w15, w17
        BEQ f04fin // Si ya está descubierta, no hacer nada
        
        // Guardar coordenadas para usar después
        MOV x20, x0  // fila
        MOV x21, x1  // columna
        
        // Contar minas cercanas
        BL f07ContarMinasCercanas
        MOV x22, x0  // guardar cantidad de minas cercanas
        
        // Marcar como descubierta
        STRB w17, [x14, #1]
        
        // Verificar si la celda tiene mina
        LDRB w23, [x14]      // leer byte de mina
        CMP w23, #1
        BNE f04nomina
        // Si tiene mina, revelar todas las minas, imprimir tablero y mostrar derrota
        BL f11RevelarTodasMinas
        BL f03ImprimirTablero
        BL f09Derrota
        B f04fin
f04nomina:
        // Si no hay minas cercanas, activar cascada
        CMP x22, #0
        BNE f04checkvictoria
        
        // Llamar a cascada
        MOV x0, x20  // restaurar fila
        MOV x1, x21  // restaurar columna
        BL f06DescubrirCascada
        
f04checkvictoria:
        // Verificar si el jugador ganó
        BL f10VerificarVictoria
        CMP x0, #1
        BNE f04fin
        // Si ganó, imprimir tablero y mostrar victoria
        BL f03ImprimirTablero
        BL f08Victoria
        
f04fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f05ColocarBandera
// Coloca o quita bandera en (fila, columna)
// Entrada: x0 = fila, x1 = columna
// Si está oculta, pone bandera; si tiene bandera, la quita
// -------------------------------------------------
f05ColocarBandera:
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
        BEQ f05quitarbandera
        // Si está oculta, poner bandera
        LDR x17, =ESTADO_OCULTA
        LDR w17, [x17]
        CMP w15, w17
        BEQ f05ponerbandera
        B f05fin
f05ponerbandera:
        STRB w16, [x14, #1]
        B f05fin
f05quitarbandera:
        LDR x18, =ESTADO_OCULTA
        LDR w18, [x18]
        STRB w18, [x14, #1]
f05fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f06DescubrirCascada
// VERSION RECURSIVA - Revela celdas adyacentes con 0 minas cercanas
// Entrada: x0 = fila, x1 = columna
// -------------------------------------------------
f06DescubrirCascada:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f06fin
        
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
        BLT f06fin
        CMP x20, x10
        BGE f06fin
        CMP x21, #0
        BLT f06fin
        CMP x21, x11
        BGE f06fin
        
        // Revelar los 8 vecinos inmediatos con recursión
        
        // Arriba-izquierda (fila-1, col-1)
        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f06revealsingle
        
        // Arriba (fila-1, col)
        SUB x0, x20, #1
        MOV x1, x21
        BL f06revealsingle
        
        // Arriba-derecha (fila-1, col+1)
        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f06revealsingle
        
        // Izquierda (fila, col-1)
        MOV x0, x20
        SUB x1, x21, #1
        BL f06revealsingle
        
        // Derecha (fila, col+1)
        MOV x0, x20
        ADD x1, x21, #1
        BL f06revealsingle
        
        // Abajo-izquierda (fila+1, col-1)
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f06revealsingle
        
        // Abajo (fila+1, col)
        ADD x0, x20, #1
        MOV x1, x21
        BL f06revealsingle
        
        // Abajo-derecha (fila+1, col+1)
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f06revealsingle
        
f06fin:
        ldp x29, x30, [sp], 16
        RET

// Función auxiliar RECURSIVA para revelar una sola celda
// Entrada: x0=fila, x1=columna
f06revealsingle:
        stp x29, x30, [sp, -96]!  // Frame grande para recursión segura
        mov x29, sp
        
        // Guardar coordenadas de entrada PRIMERO
        stp x0, x1, [sp, #16]      // fila, columna
        
        // RECARGAR configuración FRESCA en cada llamada (crítico para recursión)
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =TableroPtr
        LDR x12, [x12]
        
        // Guardar configuración
        stp x10, x11, [sp, #32]
        str x12, [sp, #48]
        
        // Recuperar coordenadas para verificar
        ldp x0, x1, [sp, #16]
        
        // Verificar límites
        CMP x0, #0
        BLT f06revealend
        CMP x0, x10
        BGE f06revealend
        CMP x1, #0
        BLT f06revealend
        CMP x1, x11
        BGE f06revealend
        
        // Calcular offset
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        
        // Leer estado actual
        LDRB w4, [x3, #1]
        
        // ⚠️ PREVENCIÓN DE BUCLE INFINITO:
        // Solo procesar celdas que estén OCULTAS
        CMP w4, #0              // ESTADO_OCULTA = 0
        BNE f06revealend
        
        // Leer si tiene mina
        LDRB w5, [x3]
        CMP w5, #1              // ¿Tiene mina?
        BEQ f06revealend  // Si tiene mina, NO revelar
        
        // Marcar como descubierta ANTES de continuar
        MOV w6, #1              // ESTADO_DESCUBIERTA = 1
        STRB w6, [x3, #1]
        
        // Contar minas cercanas para decidir si continuar cascada
        // Guardar coordenadas actuales
        ldp x0, x1, [sp, #16]
        
        BL f07ContarMinasCercanas
        MOV x7, x0              // guardar resultado
        
        // Restaurar coordenadas
        ldp x0, x1, [sp, #16]
        
        // Si tiene minas cercanas, ya la revelamos, no continuar
        CMP x7, #0
        BNE f06revealend
        
        // Si llegamos aquí, tiene 0 minas cercanas
        // Guardar coordenadas en posiciones seguras del stack
        str x0, [sp, #56]  // fila actual
        str x1, [sp, #64]  // columna actual
        
        // ✨ CASCADA RECURSIVA - Llamar a los 8 vecinos
        
        // Arriba-izquierda (fila-1, col-1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        SUB x1, x1, #1
        BL f06revealsingle
        
        // Arriba (fila-1, col)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        BL f06revealsingle
        
        // Arriba-derecha (fila-1, col+1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        ADD x1, x1, #1
        BL f06revealsingle
        
        // Izquierda (fila, col-1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x1, x1, #1
        BL f06revealsingle
        
        // Derecha (fila, col+1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x1, x1, #1
        BL f06revealsingle
        
        // Abajo-izquierda (fila+1, col-1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        SUB x1, x1, #1
        BL f06revealsingle
        
        // Abajo (fila+1, col)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        BL f06revealsingle
        
        // Abajo-derecha (fila+1, col+1)
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        ADD x1, x1, #1
        BL f06revealsingle
        
f06revealend:
        ldp x29, x30, [sp], 96
        RET

// -------------------------------------------------
// f07ContarMinasCercanas
// Cuenta minas cercanas con verificaciones robustas
// Entrada: x0 = fila, x1 = columna
// Salida: x0 = cantidad de minas cercanas
// -------------------------------------------------
f07ContarMinasCercanas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f07error
        
        // Guardar parámetros originales
        MOV x20, x0  // fila original
        MOV x21, x1  // columna original
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        // Verificar que las coordenadas estén en rango
        CMP x20, #0
        BLT f07error
        CMP x20, x10
        BGE f07error
        CMP x21, #0
        BLT f07error
        CMP x21, x11
        BGE f07error
        
        MOV x22, #0 // contador de minas
        
        // Revisar las 8 direcciones
        // Arriba-izquierda (fila-1, col-1)
        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        // Arriba (fila-1, col)
        SUB x0, x20, #1
        MOV x1, x21
        BL f07checksingle
        ADD x22, x22, x0
        
        // Arriba-derecha (fila-1, col+1)
        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        // Izquierda (fila, col-1)
        MOV x0, x20
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        // Derecha (fila, col+1)
        MOV x0, x20
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        // Abajo-izquierda (fila+1, col-1)
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        // Abajo (fila+1, col)
        ADD x0, x20, #1
        MOV x1, x21
        BL f07checksingle
        ADD x22, x22, x0
        
        // Abajo-derecha (fila+1, col+1)
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        MOV x0, x22  // retornar contador
        ldp x29, x30, [sp], 16
        RET

f07error:
        MOV x0, #0  // retornar 0 si hay error
        ldp x29, x30, [sp], 16
        RET

// Función auxiliar que verifica una sola celda
// Entrada: x0=fila, x1=columna
// Salida: x0=1 si hay mina, 0 si no
f07checksingle:
        // Verificar límites
        CMP x0, #0
        BLT f07nomine
        CMP x0, x10
        BGE f07nomine
        CMP x1, #0
        BLT f07nomine
        CMP x1, x11
        BGE f07nomine
        
        // Calcular offset y leer mina
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        LDRB w4, [x3]  // leer byte de mina
        
        // Retornar 1 si hay mina, 0 si no
        CMP w4, #1
        BEQ f07hasmine
        
f07nomine:
        MOV x0, #0
        RET
        
f07hasmine:
        MOV x0, #1
        RET

// -------------------------------------------------
// f08Victoria
// Muestra mensaje de victoria y retorna al menú principal
// -------------------------------------------------
f08Victoria:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Imprimir mensaje de victoria
        LDR x1, =MensajeVictoria
        LDR x2, =LargoMensajeVictoriaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        // Establecer bandera de juego terminado
        LDR x0, =JuegoTerminado
        MOV x1, #1
        STR x1, [x0]
        // Retornar (el flujo continuará en main.s y volverá al menú)
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f09Derrota
// Muestra mensaje de derrota y retorna al menú principal
// -------------------------------------------------
f09Derrota:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Imprimir mensaje de derrota
        LDR x1, =MensajeDerrota
        LDR x2, =LargoMensajeDerrotaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        // Establecer bandera de juego terminado
        LDR x0, =JuegoTerminado
        MOV x1, #1
        STR x1, [x0]
        // Retornar (el flujo continuará en main.s y volverá al menú)
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f10VerificarVictoria
// Verifica si todas las celdas sin mina están descubiertas
// Salida: x0 = 1 si ganó, 0 si no
// -------------------------------------------------
f10VerificarVictoria:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f10error
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        MOV x4, #0         // fila
f10filaloop:
        CMP x4, x10
        B.GE f10si
        MOV x6, #0         // columna
f10colloop:
        CMP x6, x11
        B.GE f10nextfila
        
        // Calcular offset de celda
        MUL x13, x4, x11
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        // Leer mina y estado
        LDRB w15, [x14]      // mina
        LDRB w16, [x14, #1]  // estado
        
        // Si NO tiene mina Y NO está descubierta, no ha ganado
        CMP w15, #1
        BEQ f10nextcol  // si tiene mina, saltarla
        
        // No tiene mina, verificar si está descubierta
        CMP w16, #1  // ESTADO_DESCUBIERTA = 1
        BNE f10no  // si no está descubierta, no ganó
        
f10nextcol:
        ADD x6, x6, #1
        B f10colloop
        
f10nextfila:
        ADD x4, x4, #1
        B f10filaloop
        
f10si:
        MOV x0, #1  // ganó
        ldp x29, x30, [sp], 16
        RET
        
f10no:
        MOV x0, #0  // no ganó
        ldp x29, x30, [sp], 16
        RET
        
f10error:
        MOV x0, #0
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f11RevelarTodasMinas
// Recorre el tablero y marca como descubiertas todas las minas
// -------------------------------------------------
f11RevelarTodasMinas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f11fin
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        MOV x4, #0         // fila
f11filaloop:
        CMP x4, x10
        B.GE f11fin
        MOV x6, #0         // columna
f11colloop:
        CMP x6, x11
        B.GE f11nextfila
        // Calcular offset de celda: 2 * (fila * columnas + columna)
        MUL x13, x4, x11
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        LDRB w15, [x14]      // leer byte de mina
        CMP w15, #1
        BNE f11nextcol
        // Si hay mina, marcar como descubierta
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        STRB w17, [x14, #1]
f11nextcol:
        ADD x6, x6, #1
        B f11colloop
f11nextfila:
        ADD x4, x4, #1
        B f11filaloop
f11fin:
        ldp x29, x30, [sp], 16
        RET
