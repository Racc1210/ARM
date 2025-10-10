        .section .text
        .global f01ConfigurarYJugar
        .global f02BucleJuego

        // Dependencias de IO y utilidades
        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        // Dependencias de tablero
        .extern f01InicializarTablero
        .extern f02ColocarMinas
        .extern f03ImprimirTablero
        .extern f04DescubrirCelda
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
        // Print valores de filas y columnas
        ADR x1, debug_msg_filas
        MOV x2, #14
        BL f01ImprimirCadena
        MOV x0, x0        // filas en x0
        BL print_decimal
        ADR x1, debug_msg_columnas
        MOV x2, #17
        BL f01ImprimirCadena
        MOV x0, x1        // columnas en x0
        BL print_decimal
        // Rutina para imprimir número decimal en x0
        .section .text
print_decimal:
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
        .section .rodata
debug_msg_filas:
        .asciz "FILAS: "
debug_msg_columnas:
        .asciz "COLUMNAS: "
        .section .text
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x13, =FilasSel
        LDR x0, [x13]
        LDR x14, =ColumnasSel
        LDR x1, [x14]
        LDR x15, =MinasSel
        LDR x2, [x15]

        // Print antes de inicializar tablero
        ADR x1, debug_msg_tablero
        MOV x2, #22
        BL f01ImprimirCadena
        BL f01InicializarTablero
        // Print después de inicializar tablero
        ADR x1, debug_msg_post_tablero
        MOV x2, #27
        BL f01ImprimirCadena
        BL f02ColocarMinas
        // Print después de colocar minas
        ADR x1, debug_msg_post_minas
        MOV x2, #25
        BL f01ImprimirCadena
        BL f02BucleJuego
        // Print después de bucle juego
        ADR x1, debug_msg_post_bucle
        MOV x2, #25
        BL f01ImprimirCadena
        ldp x29, x30, [sp], 16
        RET

        .section .rodata
debug_msg_tablero:
        .asciz "ANTES INICIALIZAR TABLERO\n"
debug_msg_post_tablero:
        .asciz "DESPUES INICIALIZAR TABLERO\n"
debug_msg_post_minas:
        .asciz "DESPUES COLOCAR MINAS\n"
debug_msg_post_bucle:
        .asciz "DESPUES BUCLE JUEGO\n"
        .section .text


f02BucleJuego:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Print debug: INICIO JUEGO
        ADR x1, inicio_juego_msg
        MOV x2, #13
        BL f01ImprimirCadena

        .section .rodata
inicio_juego_msg:
        .asciz "INICIO JUEGO\n"
        .section .text
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

        // descubrir celda
        MOV x0, x10
        MOV x1, x11
        MOV x2, x20
        MOV x3, x21
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

        // colocar bandera
        MOV x0, x10
        MOV x1, x11
        MOV x2, x20
        MOV x3, x21
        BL f07ColocarBandera

        B f02BucleJuego
