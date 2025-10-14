// NUEVA VERSION SIMPLE DE f03ImprimirTablero
// Imprime el tablero carácter por carácter usando solo el stack
// No usa heap dinámico para evitar corrupción de memoria

f03ImprimirTablero_NUEVA:
        stp x29, x30, [sp, -48]!  // Más espacio en stack
        mov x29, sp
        
        // Obtener cantidad de filas y columnas
        LDR x10, =FilasSel
        LDR x20, [x10]      // x20 = filas
        LDR x11, =ColumnasSel  
        LDR x21, [x11]      // x21 = columnas
        
        // Verificar que TableroPtr no sea nulo
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ nueva_print_fin
        
        // Recorrer filas
        MOV x4, #0         // fila actual
        
nueva_print_fila_loop:
        CMP x4, x20
        B.GE nueva_print_fin
        
        // Recorrer columnas de la fila actual
        MOV x6, #0        // columna actual
        
nueva_print_col_loop:
        CMP x6, x21
        B.GE nueva_print_end_row
        
        // Calcular offset de celda: 2 * (fila * columnas + columna)
        MUL x13, x4, x21
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        // Leer estado de la celda
        LDRB w16, [x14, #1]  // estado
        
        // Determinar símbolo según estado (usando constantes simples)
        MOV w22, #'#'        // por defecto: oculta (estado 0)
        
        CMP w16, #2          // ESTADO_BANDERA = 2
        BEQ nueva_print_bandera
        
        CMP w16, #1          // ESTADO_DESCUBIERTA = 1  
        BEQ nueva_print_descubierta
        B nueva_print_char
        
nueva_print_bandera:
        MOV w22, #'!'
        B nueva_print_char
        
nueva_print_descubierta:
        // Leer si tiene mina
        LDRB w15, [x14]      // mina
        CMP w15, #1
        BEQ nueva_print_mina
        
        // Si no tiene mina, mostrar espacio vacío por ahora
        MOV w22, #'_'
        B nueva_print_char
        
nueva_print_mina:
        MOV w22, #'@'
        
nueva_print_char:
        // Guardar registros que necesitamos preservar
        STR x4, [sp, #16]
        STR x6, [sp, #24] 
        STR x12, [sp, #32]
        STR x20, [sp, #40]
        
        // Imprimir símbolo usando stack temporal
        STRB w22, [sp, #8]
        MOV x8, #64          // syscall write
        MOV x0, #1           // stdout
        ADD x1, sp, #8       // buffer en stack
        MOV x2, #1           // 1 carácter
        SVC #0
        
        // Imprimir espacio
        MOV w23, #' '
        STRB w23, [sp, #8]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #8
        MOV x2, #1
        SVC #0
        
        // Restaurar registros
        LDR x4, [sp, #16]
        LDR x6, [sp, #24]
        LDR x12, [sp, #32] 
        LDR x20, [sp, #40]
        LDR x21, [x11]      // recargar columnas
        
        // Siguiente columna
        ADD x6, x6, #1
        B nueva_print_col_loop
        
nueva_print_end_row:
        // Imprimir nueva línea
        MOV w24, #10  // '\n'
        STRB w24, [sp, #8]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #8
        MOV x2, #1
        SVC #0
        
        // Siguiente fila
        ADD x4, x4, #1
        B nueva_print_fila_loop

nueva_print_fin:
        ldp x29, x30, [sp], 48
        RET