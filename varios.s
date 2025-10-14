.section .data
msg1: .asciz "Hola mundo!\n"
msg2: .asciz "12345\n"
msg3: .asciz "Test ARM64\n"

.section .text
.global _start
.extern f01ImprimirCadena

_start:
    // Imprimir msg1
    LDR x1, =msg1
    MOV x2, #12   // longitud de "Hola mundo!\n"
    BL f01ImprimirCadena
    // Imprimir msg2
    LDR x1, =msg2
    MOV x2, #6    // longitud de "12345\n"
    BL f01ImprimirCadena
    // Imprimir msg3
    LDR x1, =msg3
    MOV x2, #11   // longitud de "Test ARM64\n"
    BL f01ImprimirCadena
    // Salir
    MOV x8, #93
    SVC #0
