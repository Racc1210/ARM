        .section .data

SimboloVacio:     .asciz "#"
SimboloVacioFinal:
LargoSimboloVacio = SimboloVacioFinal - SimboloVacio

SimboloMina:      .asciz "@"
SimboloMinaFinal:
LargoSimboloMina = SimboloMinaFinal - SimboloMina

SimboloBandera:   .asciz "!"
SimboloBanderaFinal:
LargoSimboloBandera = SimboloBanderaFinal - SimboloBandera

NuevaLinea:       .asciz "\n"
NuevaLineaFinal:
LargoNuevaLinea = NuevaLineaFinal - NuevaLinea

MensajeDerrota: .asciz "\nBOOM! Has pisado una mina. Juego terminado.\n"
MensajeDerrotaFinal:
LargoMensajeDerrota = MensajeDerrotaFinal - MensajeDerrota

MensajeVictoria: .asciz "\n🎉 Felicidades, has despejado todo el tablero. ¡Victoria!\n"
MensajeVictoriaFinal:
LargoMensajeVictoria = MensajeVictoriaFinal - MensajeVictoria

Tablero:
        .skip 720

        .section .text
        .global f01InicializarTablero
        .global f02ColocarMinas
        .global f03ImprimirTablero
        .global f04DescubrirCelda
        .global f05Derrota
        .global f06Victoria
        .global f07ColocarBandera

        .extern f01ImprimirCadena
        .extern f02NumeroAleatorio

        


f01InicializarTablero:
        MOV x3, #0
        MUL x4, x0, x1
        LDR x5, =Tablero
        MOV w6, #'#'
f01InicializarTablero_loop:
        CMP x3, x4
        B.GE f01InicializarTablero_fin
        STRB w6, [x5, x3]
        ADD x3, x3, #1
        B f01InicializarTablero_loop
f01InicializarTablero_fin:
        RET

f02ColocarMinas:
        MUL x3, x0, x1
        MOV x4, x2
        LDR x5, =Tablero
f02ColocarMinas_loop:
        CMP x4, #0
        BEQ f02ColocarMinas_fin
        BL f02NumeroAleatorio
        UDIV x7, x0, x3
        MSUB x6, x7, x3, x0
        ADD x8, x5, x6
        LDRB w9, [x8]
        CMP w9, #'@'
        BEQ f02ColocarMinas_loop
        MOV w9, #'@'
        STRB w9, [x8]
        SUB x4, x4, #1
        B f02ColocarMinas_loop
f02ColocarMinas_fin:
        RET

f03ImprimirTablero:
        MOV x3, #0
        LDR x5, =Tablero


f03ImprimirTablero_filas:
        CMP x3, x0
        B.GE f03ImprimirTablero_fin
        MOV x4, #0



f03ImprimirTablero_columnas:
        CMP x4, x1
        B.GE f03ImprimirTablero_nuevaLinea
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        LDRB w8, [x7]
        ADD x1, x5, x6
        MOV x2, #1
        BL f01ImprimirCadena
        ADD x4, x4, #1
        B f03ImprimirTablero_columnas
f03ImprimirTablero_nuevaLinea:
        LDR x1, =NuevaLinea
        MOV x2, #LargoNuevaLinea
        BL f01ImprimirCadena
        ADD x3, x3, #1
        B f03ImprimirTablero_filas
f03ImprimirTablero_fin:
        RET

f04DescubrirCelda:
        MUL x4, x0, x3
        ADD x4, x4, x1
        LDR x5, =Tablero
        ADD x6, x5, x4
        LDRB w7, [x6]
        CMP w7, #'@'
        BEQ f04DescubrirCelda_mina
        CMP w7, #'#'
        BNE f04DescubrirCelda_fin
        MOV x8, #0
        MOV x9, #-1
f04DescubrirCelda_loopFila:
        CMP x9, #1
        BGT f04DescubrirCelda_guardar
        MOV x10, #-1
f04DescubrirCelda_loopCol:
        CMP x10, #1
        BGT f04DescubrirCelda_nextFila
        ADD x11, x0, x9
        ADD x12, x1, x10
        CMP x11, #0
        BLT f04DescubrirCelda_skip
        CMP x11, x2
        BGE f04DescubrirCelda_skip
        CMP x12, #0
        BLT f04DescubrirCelda_skip
        CMP x12, x3
        BGE f04DescubrirCelda_skip
        MUL x13, x11, x3
        ADD x13, x13, x12
        ADD x14, x5, x13
        LDRB w15, [x14]
        CMP w15, #'@'
        BNE f04DescubrirCelda_skip
        ADD x8, x8, #1
f04DescubrirCelda_skip:
        ADD x10, x10, #1
        B f04DescubrirCelda_loopCol
f04DescubrirCelda_nextFila:
        ADD x9, x9, #1
        B f04DescubrirCelda_loopFila
f04DescubrirCelda_guardar:
        CMP x8, #0
        BEQ f04DescubrirCelda_expandir
        ADD w7, w8, #'0'
        STRB w7, [x6]
        B f04DescubrirCelda_fin
f04DescubrirCelda_expandir:
        MOV w7, #'0'
        STRB w7, [x6]
        MOV x9, #-1
f04DescubrirCelda_expandFila:
        CMP x9, #1
        BGT f04DescubrirCelda_fin
        MOV x10, #-1
f04DescubrirCelda_expandCol:
        CMP x10, #1
        BGT f04DescubrirCelda_nextExpandFila
        ADD x11, x0, x9
        ADD x12, x1, x10
        CMP x11, #0
        BLT f04DescubrirCelda_skipExpand
        CMP x11, x2
        BGE f04DescubrirCelda_skipExpand
        CMP x12, #0
        BLT f04DescubrirCelda_skipExpand
        CMP x12, x3
        BGE f04DescubrirCelda_skipExpand
        MOV x0, x11
        MOV x1, x12
        MOV x2, x2
        MOV x3, x3
        BL f04DescubrirCelda
f04DescubrirCelda_skipExpand:
        ADD x10, x10, #1
        B f04DescubrirCelda_expandCol
f04DescubrirCelda_nextExpandFila:
        ADD x9, x9, #1
        B f04DescubrirCelda_expandFila
f04DescubrirCelda_mina:
        MOV x0, x2
        MOV x1, x3
        BL f05Derrota
f04DescubrirCelda_fin:
        RET

f05Derrota:
        LDR x1, =MensajeDerrota
        MOV x2, #LargoMensajeDerrota
        BL f01ImprimirCadena
        MOV x3, #0
        LDR x5, =Tablero
f05Derrota_filas:
        CMP x3, x0
        B.GE f05Derrota_fin
        MOV x4, #0
f05Derrota_columnas:
        CMP x4, x1
        B.GE f05Derrota_nuevaLinea
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        LDRB w8, [x7]
        CMP w8, #'@'
        BNE f05Derrota_imprimirCelda
        LDR x1, =SimboloMina
        MOV x2, #LargoSimboloMina
        BL f01ImprimirCadena
        B f05Derrota_nextCol
f05Derrota_imprimirCelda:
        ADD x1, x5, x6
        MOV x2, #1
        BL f01ImprimirCadena
f05Derrota_nextCol:
        ADD x4, x4, #1
        B f05Derrota_columnas
f05Derrota_nuevaLinea:
        L
         .section .data



    

f06Victoria:
        MOV x3, #0              // fila
        LDR x5, =Tablero

f06Victoria_filas:
        CMP x3, x0
        B.GE f06Victoria_ganar
        MOV x4, #0
f06Victoria_columnas:
        CMP x4, x1
        B.GE f06Victoria_nextFila
        MUL x6, x3, x1
        ADD x6, x6, x4
        ADD x7, x5, x6
        LDRB w8, [x7]
        CMP w8, #'#'
        BNE f06Victoria_nextCol
        // si hay un '#' aún, verificar si es mina
        CMP w8, #'@'
        BEQ f06Victoria_nextCol
        // hay una celda oculta no mina → no victoria
        RET
f06Victoria_nextCol:
        ADD x4, x4, #1
        B f06Victoria_columnas
f06Victoria_nextFila:
        ADD x3, x3, #1
        B f06Victoria_filas

f06Victoria_ganar:
        LDR x1, =MensajeVictoria
        MOV x2, #LargoMensajeVictoria
        BL f01ImprimirCadena
        MOV x0, #0
        MOV x8, #93
        SVC #0



f07ColocarBandera:
        MUL x4, x0, x3
        ADD x4, x4, x1
        LDR x5, =Tablero
        ADD x6, x5, x4
        LDRB w7, [x6]

        // si está oculta (#) → poner bandera (!)
        CMP w7, #'#'
        BNE f07ColocarBandera_checkFlag
        MOV w7, #'!'
        STRB w7, [x6]
        RET

f07ColocarBandera_checkFlag:
        // si ya hay bandera (!) → quitarla y volver a ocultar (#)
        CMP w7, #'!'
        BNE f07ColocarBandera_fin
        MOV w7, #'#'
        STRB w7, [x6]

f07ColocarBandera_fin:
        RET
