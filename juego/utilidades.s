        .section .data
Semilla: .quad 123456789

        .section .text
        .global f01AsciiANumero
        .global f02NumeroAleatorio
        .global f03LeerNumero
        .global f04ValidarRango
        .global f05LongitudCadena

        .extern f01ImprimirCadena
        .extern f02LeerCadena
        .extern OpcionSel

        

f01AsciiANumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV     x3, x2        
        MOV     x0, #0        
        MOV     x4, #0        

f01AsciiANumero_loop:
        CMP     x4, x3
        B.GE    f01AsciiANumero_fin
        LDRB    w5, [x1, x4]
        CMP     w5, #10       
        BEQ     f01AsciiANumero_fin
        SUB     w5, w5, #'0'  
        MOV     x6, #10
        MUL     x0, x0, x6    
        ADD     x0, x0, x5    
        ADD     x4, x4, #1
        B       f01AsciiANumero_loop

f01AsciiANumero_fin:
        ldp x29, x30, [sp], 16
        RET


f02NumeroAleatorio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR     x2, =Semilla
        LDR     x3, [x2]
        LDR     x4, =6364136223846793005   
        ADD     x3, x3, #1
        STR     x3, [x2]
        LSR     x0, x3, #33
        ldp x29, x30, [sp], 16
        RET


f03LeerNumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        BL f01ImprimirCadena
        LDR x1, =OpcionSel
        MOV x2, #4
        BL f02LeerCadena
        LDR x1, =OpcionSel
        MOV x2, #4
        BL f01AsciiANumero
        ldp x29, x30, [sp], 16
        RET


f04ValidarRango:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        CMP x0, x1
        BLT f04ValidarRango_invalido
        CMP x0, x2
        BGT f04ValidarRango_invalido
        MOV x0, #1
        ldp x29, x30, [sp], 16
        RET

f04ValidarRango_invalido:
        MOV x0, #0
        ldp x29, x30, [sp], 16
        RET


f05LongitudCadena:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #0
f05LongitudCadena_loop:
        LDRB w2, [x1, x0]
        CMP w2, #0
        BEQ f05LongitudCadena_fin
        ADD x0, x0, #1
        B f05LongitudCadena_loop
f05LongitudCadena_fin:
        ldp x29, x30, [sp], 16
        RET
