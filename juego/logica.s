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
        .extern f04DescubrirCelda
        .extern f05ColocarBandera
        .extern f08Victoria
        .extern f09Derrota
        .extern JuegoTerminado

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
        .extern MensajeErrorSeleccion
        .extern LargoMensajeErrorSeleccionVal
        .extern MensajeErrorFila
        .extern LargoMensajeErrorFilaVal
        .extern MensajeErrorColumna
        .extern LargoMensajeErrorColumnaVal


f01ConfigurarYJugar:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        
        LDR x0, =JuegoTerminado
        MOV x1, #0
        STR x1, [x0]
        
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
        
        LDR x20, =FilasSel
        LDR x20, [x20]
        LDR x21, =ColumnasSel
        LDR x21, [x21]

f02bucle_juego:
        LDR x0, =JuegoTerminado
        LDR x1, [x0]
        CMP x1, #1
        BEQ f02salir
        
        BL f03ImprimirTablero
        
        LDR x1, =MenuAccion
        LDR x2, =LargoMenuAccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        
f02leer_opcion:
        BL f03LeerNumero
        MOV x9, x0
        
        MOV x0, x9
        MOV x1, #1
        MOV x2, #3
        BL f04ValidarRango
        CMP x0, #0
        BEQ f02opcion_invalida   
        
       
        CMP x9, #1
        BEQ f03AccionDescubrir
        CMP x9, #2
        BEQ f04AccionBandera
        CMP x9, #3
        BEQ f02salir
        
        B f02bucle_juego

f02opcion_invalida:
        LDR x1, =MensajeErrorSeleccion
        LDR x2, =LargoMensajeErrorSeleccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f02leer_opcion

f02salir:
        ldp x29, x30, [sp], 16
        RET


f03AccionDescubrir:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
f03leer_fila:
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03fila_invalida  
        SUB x10, x10, #1                      

f03leer_columna:
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03columna_invalida  
        SUB x11, x11, #1                         

        MOV x0, x10
        MOV x1, x11
        BL f04DescubrirCelda

        LDR x0, =JuegoTerminado
        LDR x1, [x0]
        CMP x1, #1
        BEQ f02salir

        ldp x29, x30, [sp], 16
        B f02bucle_juego

f03fila_invalida:
        LDR x1, =MensajeErrorFila
        LDR x2, =LargoMensajeErrorFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f03leer_fila

f03columna_invalida:
        LDR x1, =MensajeErrorColumna
        LDR x2, =LargoMensajeErrorColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f03leer_columna


f04AccionBandera:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
f04leer_fila:
        LDR x1, =MensajeFila
        LDR x2, =LargoMensajeFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04fila_invalida
        SUB x10, x10, #1

f04leer_columna:
        LDR x1, =MensajeColumna
        LDR x2, =LargoMensajeColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04columna_invalida
        SUB x11, x11, #1

        MOV x0, x10
        MOV x1, x11
        BL f05ColocarBandera

        ldp x29, x30, [sp], 16
        B f02bucle_juego

f04fila_invalida:
        LDR x1, =MensajeErrorFila
        LDR x2, =LargoMensajeErrorFilaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f04leer_fila

f04columna_invalida:
        LDR x1, =MensajeErrorColumna
        LDR x2, =LargoMensajeErrorColumnaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f04leer_columna
