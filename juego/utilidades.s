
.global f06CrearCadenaDinamica
f06CrearCadenaDinamica:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // x1: carácter, x2: cantidad
        // x3: dirección base del heap
        // x4: índice local
        // x5: salto de línea
        // Obtener heap actual
        MOV x8, #214      // syscall brk
        MOV x0, #0
        SVC #0
        MOV x3, x0        // x3 = base heap
        // Reservar espacio
        ADD x0, x3, x2    // x0 = base + cantidad
        ADD x0, x0, #1    // x0 = base + cantidad + 1
        MOV x8, #214      // syscall brk
        SVC #0
        // Rellenar la cadena
        MOV x4, #0        // f06CrearCadenaDinamica_loop: índice de la cadena
f06CrearCadenaDinamica_loop:
        CMP x4, x2
        B.GE f06CrearCadenaDinamica_fin
        STRB w1, [x3, x4] // Guardar carácter
        ADD x4, x4, #1
        B f06CrearCadenaDinamica_loop
f06CrearCadenaDinamica_fin:
        MOV w5, #10       // Salto de línea '\n'
        STRB w5, [x3, x2] // Añadir salto de línea
        ADD x2, x2, #1    // Longitud total
        ldp x29, x30, [sp], 16
        RET

// ============================================================================
// f07ImprimirCadenaNVeces:
// Imprime una cadena en memoria una cantidad determinada de veces
// Argumentos:
//   x3: Dirección base de la cadena
//   x2: Longitud de la cadena
//   x4: Cantidad de impresiones
// ============================================================================
.global f07ImprimirCadenaNVeces
f07ImprimirCadenaNVeces:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // x3: dirección, x2: longitud, x4: cantidad
        // x5: contador local
        MOV x5, #0        // f07ImprimirCadenaNVeces_loop: contador de impresiones
f07ImprimirCadenaNVeces_loop:
        CMP x5, x4
        B.GE f07ImprimirCadenaNVeces_fin
        MOV x8, #64       // syscall write
        MOV x0, #1        // fd: stdout
        MOV x1, x3        // buffer
        MOV x2, x2        // longitud
        SVC #0
        ADD x5, x5, #1
        B f07ImprimirCadenaNVeces_loop
f07ImprimirCadenaNVeces_fin:
        ldp x29, x30, [sp], 16
        RET
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
        
f06CrearCadenaDinamica:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // x1: carácter, x2: cantidad
        // x3: dirección base del heap
        // x4: índice local
        // x5: salto de línea
        // Obtener heap actual
        MOV x8, #214      // syscall brk
        MOV x0, #0
        SVC #0
        MOV x3, x0        // x3 = base heap
        // Reservar espacio
        ADD x0, x3, x2    // x0 = base + cantidad
        ADD x0, x0, #1    // x0 = base + cantidad + 1
        MOV x8, #214      // syscall brk
        SVC #0
        // Rellenar la cadena
        MOV x4, #0        // f06CrearCadenaDinamica_loop: índice de la cadena
f06CrearCadenaDinamica_loop:
        CMP x4, x2
        B.GE f06CrearCadenaDinamica_fin
        STRB w1, [x3, x4] // Guardar carácter
        ADD x4, x4, #1
        B f06CrearCadenaDinamica_loop
f06CrearCadenaDinamica_fin:
        MOV w5, #10       // Salto de línea '\n'
        STRB w5, [x3, x2] // Añadir salto de línea
        ADD x2, x2, #1    // Longitud total
        ldp x29, x30, [sp], 16
        RET


.global f07ImprimirCadenaNVeces
f07ImprimirCadenaNVeces:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // x3: dirección, x2: longitud, x4: cantidad
        // x5: contador local
        MOV x5, #0        // f07ImprimirCadenaNVeces_loop: contador de impresiones
f07ImprimirCadenaNVeces_loop:
        CMP x5, x4
        B.GE f07ImprimirCadenaNVeces_fin
        MOV x8, #64       // syscall write
        MOV x0, #1        // fd: stdout
        MOV x1, x3        // buffer
        MOV x2, x2        // longitud
        SVC #0
        ADD x5, x5, #1
        B f07ImprimirCadenaNVeces_loop
f07ImprimirCadenaNVeces_fin:
        ldp x29, x30, [sp], 16
        RET