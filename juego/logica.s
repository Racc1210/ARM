        .section .text
        .global f01ConfigurarYJugar
        .global f02BucleJuego

        // Dependencias de IO y utilidades
        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        // Dependencias de tablero
        .extern f01InicializarTablero
        .extern f03ImprimirTablero_NUEVA
        .extern f08DescubrirCelda
        .extern f05Derrota
        .extern f06Victoria
        .extern f07ColocarBandera

        // Variables globales de configuración
        .extern FilasSel
        .extern ColumnasSel
        .extern MinasSel

        // Mensajes y longitudes (valores) de constantes.s
        .extern MenuAccion
        .extern LargoMenuAccionVal
        .extern MensajeFila
        .extern LargoMensajeFilaVal
        .extern MensajeColumna
        .extern LargoMensajeColumnaVal


f01ConfigurarYJugar:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Los parámetros x0, x1, x2 ya están configurados en main.s
        LDR x13, =FilasSel
        LDR x0, [x13]
        LDR x14, =ColumnasSel
        LDR x1, [x14]
        LDR x15, =MinasSel
        LDR x2, [x15]
        
        BL f01InicializarTablero
        BL f02BucleJuego
        
        ldp x29, x30, [sp], 16
        RET


f02BucleJuego:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Cargar dimensiones del tablero
        LDR x20, =FilasSel
        LDR x20, [x20]
        LDR x21, =ColumnasSel
        LDR x21, [x21]

f02BucleJuego_loop:
        // Imprimir tablero
        BL f03ImprimirTablero_NUEVA
        
        // Mostrar menú de acciones
        LDR x1, =MenuAccion
        LDR x2, =LargoMenuAccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        
        // Leer opción del usuario - TEMPORALMENTE COMENTADO PARA DEBUGGING
        // BL f03LeerNumero
        MOV x9, #3  // Simular opción de salir para testing
        
        // Procesar opción
        CMP x9, #1
        BEQ f03AccionDescubrir
        CMP x9, #2
        BEQ f04AccionBandera
        CMP x9, #3
        BEQ f02BucleJuego_salir
        
        // Opción inválida, repetir
        B f02BucleJuego_loop

f02BucleJuego_salir:
        ldp x29, x30, [sp], 16
        RET


f03AccionDescubrir:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
f03AccionDescubrir_leer_fila:
        // Leer fila
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        // Validar fila
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir_leer_fila   // Si inválida, repetir
        SUB x10, x10, #1                   // Convertir a índice base 0

f03AccionDescubrir_leer_columna:
        // Leer columna
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        // Validar columna
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir_leer_columna  // Si inválida, repetir
        SUB x11, x11, #1                     // Convertir a índice base 0

        // Descubrir celda
        MOV x0, x10
        MOV x1, x11
        BL f08DescubrirCelda
        
        // Verificar si el juego terminó (derrota o victoria se manejan en f08DescubrirCelda)
        
        ldp x29, x30, [sp], 16
        B f02BucleJuego_loop


f04AccionBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
f04AccionBandera_leer_fila:
        // Leer fila
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        // Validar fila
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera_leer_fila
        SUB x10, x10, #1

f04AccionBandera_leer_columna:
        // Leer columna
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        // Validar columna
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera_leer_columna
        SUB x11, x11, #1

        // Colocar/quitar bandera
        MOV x0, x10
        MOV x1, x11
        BL f07ColocarBandera

        ldp x29, x30, [sp], 16
        B f02BucleJuego_loop
