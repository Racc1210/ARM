        .section .text
        .global f01ConfigurarYJugar
        .global f02BucleJuego

        // Dependencias de IO y utilidades
        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        // Dependencias de tablero
        .extern f01InicializarTablero
        .extern f03ImprimirTablero
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
        BL f03ImprimirTablero
        
        // Mostrar menú de acciones
        LDR x1, =MenuAccion
        LDR x2, =LargoMenuAccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        
        // Leer opción del usuario
        BL f03LeerNumero
        MOV x9, x0
        
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
        // x0: número a imprimir
        // buffer temporal en stack
        SUB sp, sp, #16
        MOV x1, sp
        MOV x2, #0        // contador de dígitos
        MOV x3, x0        // copia de número
        CMP x3, #0
        BNE .print_decimal_loop
        // Si es cero, imprime '0'
        MOV w4, #'0'
        STRB w4, [x1]
        ADD x2, x2, #1
        B .print_decimal_done
.print_decimal_loop:
        // Extrae dígitos en orden inverso
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
        // Invierte el buffer
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
        print_long:
            stp x29, x30, [sp, -32]!
            mov x29, sp
            // Reservar buffer local en el stack (16 bytes, ya incluido en stp)
            mov x1, sp          // x1 = buffer
            mov x2, #0          // x2 = longitud
            cmp x0, #0
            bne .pl_loop
            mov w3, #'0'
            strb w3, [x1]
            add x2, x2, #1
            b .pl_done
        .pl_loop:
            mov x3, x0
            mov x4, #10
            udiv x0, x3, x4
            msub x5, x0, x4, x3
            add w5, w5, #'0'
            strb w5, [x1, x2]
            add x2, x2, #1
            cmp x0, #0
            bne .pl_loop
        .pl_done:
            mov x3, #0
            sub x4, x2, #1
        .pl_reverse:
            cmp x3, x4
            bge .pl_print
            ldrb w5, [x1, x3]
            ldrb w6, [x1, x4]
            strb w6, [x1, x3]
            strb w5, [x1, x4]
            add x3, x3, #1
            sub x4, x4, #1
            b .pl_reverse
        .pl_print:
            mov x8, #64
            mov x0, #1
            mov x1, sp
            mov x2, x2
            svc #0
            ldr x1, =NuevaLinea
            mov x2, #1
            mov x8, #64
            mov x0, #1
            svc #0
            ldp x29, x30, [sp], 32
            ret
        .section .rodata
        .section .text
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x13, =FilasSel
        LDR x0, [x13]
        LDR x14, =ColumnasSel
        LDR x1, [x14]
        LDR x15, =MinasSel
        LDR x2, [x15]

        BL f01InicializarTablero
        // ...sin lógica de minas...
        BL f02BucleJuego
        ldp x29, x30, [sp], 16
        RET

        .section .rodata
        .section .text


f02BucleJuego:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x20, =FilasSel
        LDR x20, [x20]
        LDR x21, =ColumnasSel
        LDR x21, [x21]
        BL f03ImprimirTablero
        LDR x1, =MenuAccion
        LDR x2, =LargoMenuAccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x9, x0
        CMP x9, #1
        BEQ f03AccionDescubrir
        CMP x9, #2
        BEQ f04AccionBandera
        CMP x9, #3
        ldp x29, x30, [sp], 16
        RET
        B f02BucleJuego


f03AccionDescubrir:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // leer fila
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        // validar fila
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir   
        SUB x10, x10, #1

        // leer columna
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        // validar columna
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir  
        SUB x11, x11, #1

        // descubrir celda
        MOV x0, x10
        MOV x1, x11
        BL f04DescubrirCelda

        // verificar victoria
        MOV x0, x20
        MOV x1, x21
        BL f06Victoria

        B f02BucleJuego


f04AccionBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // leer fila
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        // validar fila
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera
        SUB x10, x10, #1

        // leer columna
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        // validar columna
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera
        SUB x11, x11, #1

        // colocar bandera
        MOV x0, x10
        MOV x1, x11
        BL f07ColocarBandera

        B f02BucleJuego
