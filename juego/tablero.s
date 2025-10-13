// Declaraciones globales
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


// Dependencias externas
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


.section .bss
TableroPtr:     .skip 8    
BufferSimbolo:  .skip 8    
JuegoTerminado: .skip 8    


.section .text
f01InicializarTablero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]      
        LDR x11, =ColumnasSel
        LDR x11, [x11]      
        
        MUL x12, x10, x11
        LSL x12, x12, #1
        
        MOV x8, #214      
        MOV x0, #0        
        SVC #0
        MOV x13, x0       
        ADD x0, x13, x12  
        MOV x8, #214     
        SVC #0
        
        CMP x0, x13       
        BLT f01error  
        
        LDR x14, =TableroPtr
        STR x13, [x14]
        
        MOV x3, #0         
f01bucle_filas:
        CMP x3, x10
        B.GE f01inicializado
        MOV x4, #0         
f01bucle_columnas:
        CMP x4, x11
        B.GE f01siguiente_fila
        MUL x15, x3, x11
        ADD x15, x15, x4
        LSL x15, x15, #1
        LDR x16, =TableroPtr
        LDR x16, [x16]
        ADD x17, x16, x15
        MOV w18, #0        
        STRB w18, [x17]
        MOV w18, #0        
        STRB w18, [x17, #1]
        ADD x4, x4, #1
        B f01bucle_columnas
f01siguiente_fila:
        ADD x3, x3, #1
        B f01bucle_filas
f01inicializado:
        
        BL f02ColocarMinasAleatorias
        ldp x29, x30, [sp], 16
        RET
f01error:

        MOV x0, #1       
        MOV x8, #93       
        SVC #0


f02ColocarMinasAleatorias:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x10, =FilasSel
        LDR x10, [x10]      
        LDR x11, =ColumnasSel
        LDR x11, [x11]      
        LDR x12, =MinasSel
        LDR x12, [x12]     
        LDR x13, =TableroPtr
        LDR x13, [x13]      
        MOV x14, #0         
        MOV x20, #0         
        MOV x21, #10000     
f02bucle_minas:
        CMP x14, x12
        B.GE f02fin
        CMP x20, x21
        B.GE f02fin      
        
        MOV x0, x10
        BL f02NumeroAleatorio
        UDIV x15, x0, x10
        MSUB x15, x15, x10, x0
        
        MOV x0, x11
        BL f02NumeroAleatorio
        UDIV x16, x0, x11
        MSUB x16, x16, x11, x0
        
        MUL x17, x15, x11
        ADD x17, x17, x16
        LSL x17, x17, #1
        ADD x18, x13, x17
        
        LDRB w19, [x18]
        CMP w19, #1
        ADD x20, x20, #1  
        BEQ f02bucle_minas 
        
        MOV w19, #1
        STRB w19, [x18]
        ADD x14, x14, #1
        ADD x20, x20, #1   
        B f02bucle_minas
f02fin:
        ldp x29, x30, [sp], 16
        RET


f03ImprimirTablero:
        stp x29, x30, [sp, -64]!  
        mov x29, sp
        
        BL f05LimpiarPantalla
        
        LDR x10, =FilasSel
        LDR x20, [x10]      
        LDR x11, =ColumnasSel  
        LDR x21, [x11]      
        
        
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f03fin
        
        
        MOV x4, #0         
        
f03bucle_filas:
        CMP x4, x20
        B.GE f03fin
        
        
        MOV x6, #0        
        
f03bucle_columnas:
        CMP x6, x21
        B.GE f03fin_fila
        

        MUL x13, x4, x21
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        
        LDRB w16, [x14, #1]  
        
        MOV w22, #'#'       
        
        CMP w16, #2          
        BEQ f03bandera
        
        CMP w16, #1         
        BEQ f03descubierta
        B f03imprimir_caracter
        
f03bandera:
        MOV w22, #'!'
        B f03imprimir_caracter
        
f03descubierta:
        LDRB w15, [x14]      
        CMP w15, #1
        BEQ f03mina
        
        
        stp x4, x6, [sp, #16]
        stp x12, x20, [sp, #32]
        str x21, [sp, #48]
        
        MOV x0, x4    
        MOV x1, x6    
        BL f07ContarMinasCercanas
        
        
        ldp x4, x6, [sp, #16]
        ldp x12, x20, [sp, #32]
        ldr x21, [sp, #48]
        
        
        CMP x0, #0
        BEQ f03vacia
        
        
        ADD w22, w0, #'0'
        B f03imprimir_caracter
        
f03mina:
        MOV w22, #'@'
        B f03imprimir_caracter

f03vacia:
        MOV w22, #'_'
        
f03imprimir_caracter:
        
        stp x4, x6, [sp, #16]
        stp x12, x20, [sp, #32]
        str x21, [sp, #48]
        
        
        STRB w22, [sp, #56]
        MOV x8, #64          
        MOV x0, #1           
        ADD x1, sp, #56      
        MOV x2, #1           
        SVC #0
        
        
        MOV w23, #' '
        STRB w23, [sp, #56]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #56
        MOV x2, #1
        SVC #0
        

        ldp x4, x6, [sp, #16]
        ldp x12, x20, [sp, #32]
        ldr x21, [sp, #48]
        
        
        ADD x6, x6, #1
        B f03bucle_columnas
        
f03fin_fila:
        
        MOV w24, #10  
        STRB w24, [sp, #56]
        MOV x8, #64
        MOV x0, #1
        ADD x1, sp, #56
        MOV x2, #1
        SVC #0
        
       
        ADD x4, x4, #1
        B f03bucle_filas

f03fin:
        ldp x29, x30, [sp], 64
        RET


f04DescubrirCelda:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f04fin
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        
        CMP x0, #0
        BLT f04fin
        CMP x0, x10
        BGE f04fin
        CMP x1, #0
        BLT f04fin
        CMP x1, x11
        BGE f04fin
        
        
        MUL x13, x0, x11
        ADD x13, x13, x1
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        
        LDRB w15, [x14, #1]
        LDR x16, =ESTADO_BANDERA
        LDR w16, [x16]
        CMP w15, w16
        BEQ f04fin 
        
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        CMP w15, w17
        BEQ f04fin 
        
        MOV x20, x0  
        MOV x21, x1  
        
 
        BL f07ContarMinasCercanas
        MOV x22, x0  
        
        STRB w17, [x14, #1]
        
        LDRB w23, [x14]      
        CMP w23, #1
        BNE f04sin_mina
        BL f11RevelarTodasMinas
        BL f03ImprimirTablero
        BL f09Derrota
        B f04fin
f04sin_mina:
        
        CMP x22, #0
        BNE f04verificar_victoria
        
        
        MOV x0, x20  
        MOV x1, x21  
        BL f06DescubrirCascada
        
f04verificar_victoria:
        
        BL f10VerificarVictoria
        CMP x0, #1
        BNE f04fin
        
        BL f03ImprimirTablero
        BL f08Victoria
        
f04fin:
        ldp x29, x30, [sp], 16
        RET


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
        BEQ f05quitar_bandera
        
        LDR x17, =ESTADO_OCULTA
        LDR w17, [x17]
        CMP w15, w17
        BEQ f05poner_bandera
        B f05fin
f05poner_bandera:
        STRB w16, [x14, #1]
        B f05fin
f05quitar_bandera:
        LDR x18, =ESTADO_OCULTA
        LDR w18, [x18]
        STRB w18, [x14, #1]
f05fin:
        ldp x29, x30, [sp], 16
        RET

f06DescubrirCascada:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f06fin
        
        
        LDR x10, =FilasSel
        LDR x10, [x10]      
        LDR x11, =ColumnasSel
        LDR x11, [x11]      
        
        
        MOV x20, x0  
        MOV x21, x1  
        
        
        CMP x20, #0
        BLT f06fin
        CMP x20, x10
        BGE f06fin
        CMP x21, #0
        BLT f06fin
        CMP x21, x11
        BGE f06fin
        
        
        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f06revelar_celda
        
        SUB x0, x20, #1
        MOV x1, x21
        BL f06revelar_celda
        

        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f06revelar_celda
        
  
        MOV x0, x20
        SUB x1, x21, #1
        BL f06revelar_celda
        
        MOV x0, x20
        ADD x1, x21, #1
        BL f06revelar_celda
        
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f06revelar_celda
        
        
        ADD x0, x20, #1
        MOV x1, x21
        BL f06revelar_celda
        
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f06revelar_celda
        
f06fin:
        ldp x29, x30, [sp], 16
        RET


f06revelar_celda:
        stp x29, x30, [sp, -96]!  
        mov x29, sp
        

        stp x0, x1, [sp, #16]      
        
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        LDR x12, =TableroPtr
        LDR x12, [x12]
        
        
        stp x10, x11, [sp, #32]
        str x12, [sp, #48]
        
        
        ldp x0, x1, [sp, #16]
        
        
        CMP x0, #0
        BLT f06revealend
        CMP x0, x10
        BGE f06revealend
        CMP x1, #0
        BLT f06revealend
        CMP x1, x11
        BGE f06revealend
        
       
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        
        
        LDRB w4, [x3, #1]
        
        
        CMP w4, #0              
        BNE f06revelar_fin
        
        
        LDRB w5, [x3]
        CMP w5, #1              
        BEQ f06revelar_fin  
        
        
        MOV w6, #1              
        STRB w6, [x3, #1]
        
        
        ldp x0, x1, [sp, #16]
        
        BL f07ContarMinasCercanas
        MOV x7, x0              
        
        ldp x0, x1, [sp, #16]
        
        
        CMP x7, #0
        BNE f06revelar_fin
        
        str x0, [sp, #56] 
        str x1, [sp, #64]  
        
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        SUB x1, x1, #1
        BL f06revelar_celda
        
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        BL f06revelar_celda
        
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x0, x0, #1
        ADD x1, x1, #1
        BL f06revelar_celda
        
       
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        SUB x1, x1, #1
        BL f06revelar_celda
        
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x1, x1, #1
        BL f06revelar_celda
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        SUB x1, x1, #1
        BL f06revelar_celda
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        BL f06revelar_celda
        
        ldr x0, [sp, #56]
        ldr x1, [sp, #64]
        ADD x0, x0, #1
        ADD x1, x1, #1
        BL f06revelar_celda
        
f06revelar_fin:
        ldp x29, x30, [sp], 96
        RET


f07ContarMinasCercanas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        LDR x12, =TableroPtr
        LDR x12, [x12]
        CMP x12, #0
        BEQ f07error
        
        MOV x20, x0 
        MOV x21, x1  
        
        LDR x10, =FilasSel
        LDR x10, [x10]
        LDR x11, =ColumnasSel
        LDR x11, [x11]
        
        CMP x20, #0
        BLT f07error
        CMP x20, x10
        BGE f07error
        CMP x21, #0
        BLT f07error
        CMP x21, x11
        BGE f07error
        
        MOV x22, #0
        

        SUB x0, x20, #1
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        SUB x0, x20, #1
        MOV x1, x21
        BL f07checksingle
        ADD x22, x22, x0
        

        SUB x0, x20, #1
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        MOV x0, x20
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        MOV x0, x20
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        ADD x0, x20, #1
        SUB x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        ADD x0, x20, #1
        MOV x1, x21
        BL f07checksingle
        ADD x22, x22, x0
        
        ADD x0, x20, #1
        ADD x1, x21, #1
        BL f07checksingle
        ADD x22, x22, x0
        
        MOV x0, x22 
        ldp x29, x30, [sp], 16
        RET

f07error:
        MOV x0, #0  
        ldp x29, x30, [sp], 16
        RET


f07checksingle:
        CMP x0, #0
        BLT f07sin_mina
        CMP x0, x10
        BGE f07sin_mina
        CMP x1, #0
        BLT f07sin_mina
        CMP x1, x11
        BGE f07sin_mina
        
        MUL x2, x0, x11
        ADD x2, x2, x1
        LSL x2, x2, #1
        ADD x3, x12, x2
        LDRB w4, [x3]  
        
        CMP w4, #1
        BEQ f07tiene_mina
        
f07sin_mina:
        MOV x0, #0
        RET
        
f07tiene_mina:
        MOV x0, #1
        RET


f08Victoria:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =MensajeVictoria
        LDR x2, =LargoMensajeVictoriaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        LDR x0, =JuegoTerminado
        MOV x1, #1
        STR x1, [x0]
        ldp x29, x30, [sp], 16
        RET


f09Derrota:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =MensajeDerrota
        LDR x2, =LargoMensajeDerrotaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        LDR x0, =JuegoTerminado
        MOV x1, #1
        STR x1, [x0]
        ldp x29, x30, [sp], 16
        RET


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
        
        MOV x4, #0         
f10bucle_filas:
        CMP x4, x10
        B.GE f10victoria
        MOV x6, #0         
f10bucle_columnas:
        CMP x6, x11
        B.GE f10siguiente_fila
        
        MUL x13, x4, x11
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        
        LDRB w15, [x14]     
        LDRB w16, [x14, #1]  
        
        CMP w15, #1
        BEQ f10siguiente_columna  
        
        CMP w16, #1  
        BNE f10sin_victoria 
        
f10siguiente_columna:
        ADD x6, x6, #1
        B f10bucle_columnas
        
f10siguiente_fila:
        ADD x4, x4, #1
        B f10bucle_filas
        
f10victoria:
        MOV x0, #1  
        ldp x29, x30, [sp], 16
        RET
        
f10sin_victoria:
        MOV x0, #0  
        ldp x29, x30, [sp], 16
        RET
        
f10error:
        MOV x0, #0
        ldp x29, x30, [sp], 16
        RET


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
        MOV x4, #0         
f11bucle_filas:
        CMP x4, x10
        B.GE f11fin
        MOV x6, #0         
f11bucle_columnas:
        CMP x6, x11
        B.GE f11siguiente_fila
        MUL x13, x4, x11
        ADD x13, x13, x6
        LSL x13, x13, #1
        ADD x14, x12, x13
        LDRB w15, [x14]      
        CMP w15, #1
        BNE f11siguiente_columna
        LDR x17, =ESTADO_DESCUBIERTA
        LDR w17, [x17]
        STRB w17, [x14, #1]
f11siguiente_columna:
        ADD x6, x6, #1
        B f11bucle_columnas
f11siguiente_fila:
        ADD x4, x4, #1
        B f11bucle_filas
f11fin:
        ldp x29, x30, [sp], 16
        RET
