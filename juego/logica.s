        .section .text
        .global f01ConfigurarYJugar
        .global f02BucleJuego

        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        .extern f01InicializarTablero
        .extern f02ColocarMinas
        .extern f03ImprimirTablero
        .extern f04DescubrirCelda
        .extern f05Derrota
        .extern f06Victoria
        .extern f07ColocarBandera

        .extern FilasSel
        .extern ColumnasSel
        .extern MinasSel

        .extern MenuAccion, LargoMenuAccion
        .extern MensajeFila, LargoMensajeFila
        .extern MensajeColumna, LargoMensajeColumna


f01ConfigurarYJugar:
        LDR x13, =FilasSel
        LDR x0, [x13]
        LDR x14, =ColumnasSel
        LDR x1, [x14]
        LDR x15, =MinasSel
        LDR x2, [x15]

        BL f01InicializarTablero
        BL f02ColocarMinas
        B f02BucleJuego


f02BucleJuego:
        LDR x20, =FilasSel
        LDR x20, [x20]
        LDR x21, =ColumnasSel
        LDR x21, [x21]

        BL f03ImprimirTablero

        LDR x1, =MenuAccion
        MOV x2, #LargoMenuAccion
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x9, x0

        CMP x9, #1
        BEQ f03AccionDescubrir   
        CMP x9, #2
        BEQ f04AccionBandera     
        CMP x9, #3
        RET                      
        B f02BucleJuego


f03AccionDescubrir:
        LDR x1, =MensajeFila
        MOV x2, #LargoMensajeFila
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir   

        
        LDR x1, =MensajeColumna
        MOV x2, #LargoMensajeColumna
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f03AccionDescubrir  

        
        MOV x0, x10
        MOV x1, x11
        MOV x2, x20
        MOV x3, x21
        BL f04DescubrirCelda

       
        MOV x0, x20
        MOV x1, x21
        BL f06Victoria

        B f02BucleJuego


f04AccionBandera:
        LDR x1, =MensajeFila
        MOV x2, #LargoMensajeFila
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        
        MOV x0, x10
        MOV x1, #1
        MOV x2, x20
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera

        LDR x1, =MensajeColumna
        MOV x2, #LargoMensajeColumna
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        
        MOV x0, x11
        MOV x1, #1
        MOV x2, x21
        BL f04ValidarRango
        CMP x0, #0
        BEQ f04AccionBandera

        
        MOV x0, x10
        MOV x1, x11
        MOV x2, x20
        MOV x3, x21
        BL f07ColocarBandera

        B f02BucleJuego
