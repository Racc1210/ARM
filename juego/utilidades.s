// ******  Datos administrativos  *******************
// Nombre del archivo: utilidades.s
// Tipo de archivo: Código fuente ensamblador ARM64
// Proyecto: Buscaminas
// Autor: Roymar Castillo
// Empresa: ITCR
// ******  Descripción  ******************************
// Funciones auxiliares: conversión ASCII a número,
// generador de números aleatorios, lectura de entrada
// numérica del usuario y validación de rangos.
// ******  Versión  **********************************
// 01 | 2025-10-13 | Roymar Castillo - Versión final
// ***************************************************

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
Semilla: .quad 123456789   // Semilla para generador aleatorio


// Sección de datos no inicializados
.section .bss
BufferLectura: .skip 8     // Buffer temporal para lectura de entrada


.section .text

// ******  Nombre  ***********************************
// f01AsciiANumero
// ******  Descripción  ******************************
// Convierte una cadena ASCII a un número entero.
// Procesa dígitos hasta encontrar fin de cadena
// o salto de línea.
// ******  Retorno  **********************************
// x0: Número entero resultante
// ******  Entradas  *********************************
// x1: Dirección de la cadena ASCII
// x2: Longitud máxima a procesar
// ******  Errores  **********************************
// Ninguno
// ***************************************************
f01AsciiANumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x3, x2              // x3 = Longitud máxima
        MOV x0, #0              // x0 = Resultado acumulado
        MOV x4, #0              // x4 = Índice actual

f01bucle_conversion:
        CMP x4, x3
        B.GE f01fin
        LDRB w5, [x1, x4]       // w5 = Caracter actual
        CMP w5, #10             // Verificar salto de línea
        BEQ f01fin
        SUB w5, w5, #'0'        // Convertir ASCII a dígito
        MOV x6, #10
        MUL x0, x0, x6          // Multiplicar resultado por 10
        ADD x0, x0, x5          // Sumar nuevo dígito
        ADD x4, x4, #1
        B f01bucle_conversion

f01fin:
        ldp x29, x30, [sp], 16
        RET


// ******  Nombre  ***********************************
// f02NumeroAleatorio
// ******  Descripción  ******************************
// Genera un número pseudo-aleatorio en el rango
// [0, max) usando un generador congruencial lineal.
// Actualiza la semilla global automáticamente.
// ******  Retorno  **********************************
// x0: Número aleatorio en rango [0, max)
// ******  Entradas  *********************************
// x0: Valor máximo (no inclusivo)
// ******  Errores  **********************************
// Si max <= 0, retorna 0
// ***************************************************
f02NumeroAleatorio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x1, x0              // x1 = Valor máximo
        CMP x1, #0              // Validar rango
        BLE f02rango_invalido
        
        LDR x2, =Semilla
        LDR x3, [x2]            // x3 = Semilla actual
        LDR x4, =6364136223846793005  // Constante multiplicadora
        MUL x3, x3, x4
        EOR x3, x3, x4
        ADD x3, x3, #1
        STR x3, [x2]            // Guardar nueva semilla
        

        LSR x0, x3, #16         // Descartar bits bajos
        UDIV x5, x0, x1         // División para obtener residuo
        MSUB x0, x5, x1, x0     // x0 = x0 - (x5 * x1), módulo
        
        ldp x29, x30, [sp], 16
        RET

f02rango_invalido:
        MOV x0, #0              // Retornar 0 si rango inválido
        ldp x29, x30, [sp], 16
        RET


// ******  Nombre  ***********************************
// f03LeerNumero
// ******  Descripción  ******************************
// Lee un número desde la entrada estándar.
// Utiliza buffer temporal para almacenar entrada
// y luego la convierte a entero.
// ******  Retorno  **********************************
// x0: Número entero leído
// ******  Entradas  *********************************
// Ninguna (lee desde stdin)
// ******  Errores  **********************************
// Ninguno
// ***************************************************
f03LeerNumero:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        

        LDR x1, =BufferLectura  // x1 = Dirección del buffer
        MOV x2, #4              // x2 = Tamaño máximo
        BL f02LeerCadena
        
        LDR x1, =BufferLectura  // x1 = Dirección del buffer
        MOV x2, #4              // x2 = Longitud a convertir
        BL f01AsciiANumero
        
        ldp x29, x30, [sp], 16
        RET


// ******  Nombre  ***********************************
// f04ValidarRango
// ******  Descripción  ******************************
// Valida si un valor se encuentra dentro de un
// rango inclusivo [min, max].
// ******  Retorno  **********************************
// x0: 1 si está en rango, 0 si está fuera
// ******  Entradas  *********************************
// x0: Valor a validar
// x1: Valor mínimo (inclusivo)
// x2: Valor máximo (inclusivo)
// ******  Errores  **********************************
// Ninguno
// ***************************************************
f04ValidarRango:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        
       
        CMP x0, x1              // Comparar con mínimo
        BLT f04fuera_de_rango
        
        
        CMP x0, x2              // Comparar con máximo
        BGT f04fuera_de_rango
        
        
        MOV x0, #1              // Retornar 1 (en rango)
        ldp x29, x30, [sp], 16
        RET

f04fuera_de_rango:
        MOV x0, #0              // Retornar 0 (fuera de rango)
        ldp x29, x30, [sp], 16
        RET


// ******  Nombre  ***********************************
// f05LimpiarPantalla
// ******  Descripción  ******************************
// Limpia la pantalla usando secuencias de escape
// ANSI. Envía ESC[2J (limpiar) y ESC[H (cursor
// a inicio).
// ******  Retorno  **********************************
// Ninguno
// ******  Entradas  *********************************
// Ninguna
// ******  Errores  **********************************
// Ninguno
// ***************************************************
f05LimpiarPantalla:
        stp x29, x30, [sp, -32]!
        mov x29, sp
        
        MOV w0, #27             // ESC
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
        
        MOV x8, #64             // Syscall write
        MOV x0, #1              // File descriptor stdout
        ADD x1, sp, #16         // x1 = Dirección secuencia ANSI
        MOV x2, #7              // x2 = Longitud secuencia
        SVC #0
        
        ldp x29, x30, [sp], 32
        RET
