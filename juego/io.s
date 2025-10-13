.section .text
        .global f01ImprimirCadena
        .global f02LeerCadena

f01ImprimirCadena:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        mov x8, #64
        mov x0, #1          
        svc #0
        ldp x29, x30, [sp], 16
        ret


f02LeerCadena:
        stp x29, x30, [sp, -16]! 
        mov x29, sp
        MOV x8, #63          // syscall read
        MOV x0, #0           // fd: stdin
        // x1 ya contiene el buffer
        // x2 ya contiene el tamaño
        SVC #0
        ldp x29, x30, [sp], 16
        RET
