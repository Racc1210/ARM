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
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Print debug: entrando a f01ConfigurarYJugar
        LDR x1, =Bienvenida
        LDR x2, =LargoBienvenidaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        LDR x13, =FilasSel
        LDR x0, [x13]
        LDR x14, =ColumnasSel
        LDR x1, [x14]
        LDR x15, =MinasSel
        LDR x2, [x15]

        BL f01InicializarTablero
        BL f02ColocarMinas
        BL f02BucleJuego
        ldp x29, x30, [sp], 16
        RET


f02BucleJuego:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Print debug: entrando a f02BucleJuego
        LDR x1, =MenuAccion
        LDR x2, =LargoMenuAccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
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
