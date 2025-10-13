// =====================================
// utilidades.s - Funciones de utilidad general
// =====================================

// -------------------------------------------------
// Declaraciones globales
// -------------------------------------------------
        .global f01AsciiANumero
        .global f02NumeroAleatorio
        .global f03LeerNumero
        .global f04ValidarRango
        .global f05LimpiarPantalla
        .global Semilla

// -------------------------------------------------
// Dependencias externas
// -------------------------------------------------
        .extern f01ImprimirCadena
        .extern f02LeerCadena

// -------------------------------------------------
// Sección de datos inicializados
// -------------------------------------------------
        .section .data
Semilla: .quad 123456789    // Semilla para generación de números aleatorios

// -------------------------------------------------
// Sección de datos no inicializados
// -------------------------------------------------
        .section .bss
BufferLectura: .skip 8      // Buffer temporal para f03LeerNumero

// -------------------------------------------------
// f01AsciiANumero
// Convierte una cadena ASCII a número entero
// Entrada: x1 = puntero a cadena, x2 = longitud máxima
// Salida: x0 = número convertido
// -------------------------------------------------
        .section .text
f01AsciiANumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x3, x2              // x3 = longitud máxima
        MOV x0, #0              // x0 = resultado (acumulador)
        MOV x4, #0              // x4 = índice

f01loop:
        CMP x4, x3
        B.GE f01fin
        LDRB w5, [x1, x4]       // Leer carácter
        CMP w5, #10             // ¿Es newline?
        BEQ f01fin
        SUB w5, w5, #'0'        // Convertir ASCII a dígito
        MOV x6, #10
        MUL x0, x0, x6          // resultado *= 10
        ADD x0, x0, x5          // resultado += dígito
        ADD x4, x4, #1
        B f01loop

f01fin:
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f02NumeroAleatorio
// Genera un número aleatorio en el rango [0, rango)
// Entrada: x0 = rango (valor máximo exclusivo)
// Salida: x0 = número aleatorio
// -------------------------------------------------
f02NumeroAleatorio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x1, x0              // Guardar rango en x1
        CMP x1, #0              // Verificar que rango > 0
        BLE f02error
        
        // Generador congruencial lineal (LCG)
        LDR x2, =Semilla
        LDR x3, [x2]
        LDR x4, =6364136223846793005
        MUL x3, x3, x4
        EOR x3, x3, x4
        ADD x3, x3, #1
        STR x3, [x2]
        
        // Obtener número en rango usando módulo
        LSR x0, x3, #16         // Usar bits más significativos
        UDIV x5, x0, x1         // x5 = x0 / rango
        MSUB x0, x5, x1, x0     // x0 = x0 % rango
        
        ldp x29, x30, [sp], 16
        RET

f02error:
        MOV x0, #0              // Retornar 0 si rango inválido
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f03LeerNumero
// Lee un número desde entrada estándar
// Salida: x0 = número leído
// -------------------------------------------------
f03LeerNumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Leer cadena en buffer
        LDR x1, =BufferLectura
        MOV x2, #4
        BL f02LeerCadena
        
        // Convertir cadena a número
        LDR x1, =BufferLectura
        MOV x2, #4
        BL f01AsciiANumero
        
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f04ValidarRango
// Valida que un número esté dentro de un rango [min, max]
// Entrada: x0 = número, x1 = mínimo, x2 = máximo
// Salida: x0 = 1 si válido, 0 si inválido
// -------------------------------------------------
f04ValidarRango:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
        // Verificar límite inferior
        CMP x0, x1
        BLT f04invalido
        
        // Verificar límite superior
        CMP x0, x2
        BGT f04invalido
        
        // Número válido
        MOV x0, #1
        ldp x29, x30, [sp], 16
        RET

f04invalido:
        MOV x0, #0
        ldp x29, x30, [sp], 16
        RET

// -------------------------------------------------
// f05LimpiarPantalla
// Limpia la consola usando secuencias ANSI
// Secuencia: \033[2J\033[H
// -------------------------------------------------
f05LimpiarPantalla:
        stp x29, x30, [sp, -32]!
        mov x29, sp
        
        // Construir secuencia ANSI en el stack
        // \033[2J = limpiar pantalla completa
        // \033[H = mover cursor a posición 0,0
        
        MOV w0, #27             // ESC (ASCII 27)
        STRB w0, [sp, #16]
        MOV w0, #'['
        STRB w0, [sp, #17]
        MOV w0, #'2'
        STRB w0, [sp, #18]
        MOV w0, #'J'
        STRB w0, [sp, #19]
        MOV w0, #27             // ESC
        STRB w0, [sp, #20]
        MOV w0, #'['
        STRB w0, [sp, #21]
        MOV w0, #'H'
        STRB w0, [sp, #22]
        
        // Escribir secuencia a stdout
        MOV x8, #64             // syscall write
        MOV x0, #1              // fd: stdout
        ADD x1, sp, #16         // buffer
        MOV x2, #7              // longitud: 7 bytes
        SVC #0
        
        ldp x29, x30, [sp], 32
        RET
