        .section .text
        .global f01ImprimirCadena
        .global f02LeerCadena

f01ImprimirCadena:
        MOV x8, #64          // syscall write
        MOV x0, #1           // fd = 1 (stdout)
        SVC #0
        RET


f02LeerCadena:
        MOV x8, #63          
        MOV x0, #0           
        SVC #0
        RET
