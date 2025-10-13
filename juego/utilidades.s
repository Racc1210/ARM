// Declaraciones globales
.global f01AsciiANumero
.global f02NumeroAleatorio
.global f03LeerNumero
.global f04ValidarRango
.global f05LimpiarPantalla
.global Semilla


// Dependencias externas
.extern f01ImprimirCadena
.extern f02LeerCadena


// Sección de datos inicializados
.section .data
Semilla: .quad 123456789   


// Sección de datos no inicializados
.section .bss
BufferLectura: .skip 8      


.section .text
f01AsciiANumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x3, x2              
        MOV x0, #0             
        MOV x4, #0             

f01bucle_conversion:
        CMP x4, x3
        B.GE f01fin
        LDRB w5, [x1, x4]       
        CMP w5, #10             
        BEQ f01fin
        SUB w5, w5, #'0'        
        MOV x6, #10
        MUL x0, x0, x6          
        ADD x0, x0, x5          
        ADD x4, x4, #1
        B f01bucle_conversion

f01fin:
        ldp x29, x30, [sp], 16
        RET


f02NumeroAleatorio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x1, x0              
        CMP x1, #0              
        BLE f02rango_invalido
        
        LDR x2, =Semilla
        LDR x3, [x2]
        LDR x4, =6364136223846793005
        MUL x3, x3, x4
        EOR x3, x3, x4
        ADD x3, x3, #1
        STR x3, [x2]
        

        LSR x0, x3, #16         
        UDIV x5, x0, x1         
        MSUB x0, x5, x1, x0    
        
        ldp x29, x30, [sp], 16
        RET

f02rango_invalido:
        MOV x0, #0              
        ldp x29, x30, [sp], 16
        RET


f03LeerNumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        

        LDR x1, =BufferLectura
        MOV x2, #4
        BL f02LeerCadena
        
        LDR x1, =BufferLectura
        MOV x2, #4
        BL f01AsciiANumero
        
        ldp x29, x30, [sp], 16
        RET


f04ValidarRango:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
       
        CMP x0, x1
        BLT f04fuera_de_rango
        
        
        CMP x0, x2
        BGT f04fuera_de_rango
        
        
        MOV x0, #1
        ldp x29, x30, [sp], 16
        RET

f04fuera_de_rango:
        MOV x0, #0
        ldp x29, x30, [sp], 16
        RET


f05LimpiarPantalla:
        stp x29, x30, [sp, -32]!
        mov x29, sp
        
        MOV w0, #27             
        STRB w0, [sp, #16]
        MOV w0, #'['
        STRB w0, [sp, #17]
        MOV w0, #'2'
        STRB w0, [sp, #18]
        MOV w0, #'J'
        STRB w0, [sp, #19]
        MOV w0, #27            
        STRB w0, [sp, #20]
        MOV w0, #'['
        STRB w0, [sp, #21]
        MOV w0, #'H'
        STRB w0, [sp, #22]
        
        MOV x8, #64             
        MOV x0, #1              
        ADD x1, sp, #16         
        MOV x2, #7              
        SVC #0
        
        ldp x29, x30, [sp], 32
        RET
