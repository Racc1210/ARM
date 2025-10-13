        .extern Semilla
        .section .bss
TmpFilas:    .skip 8
TmpColumnas: .skip 8
TmpMinas:    .skip 8
        .global  FilasSel
        .global  ColumnasSel
        .global  MinasSel
        .global  OpcionSel
FilasSel:    .skip 8
ColumnasSel: .skip 8
MinasSel:    .skip 8
OpcionSel:      .skip 8

        .section .text
        .global _start

        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        .extern f01ConfigurarYJugar  

        // Mensajes y longitudes desde constantes.s
        .extern Bienvenida
        .extern LargoBienvenidaVal
        .extern Menu
        .extern LargoMenuVal
        .extern MensajeSalir
        .extern LargoMensajeSalirVal
        .extern MensajeErrorSeleccion
        .extern LargoMensajeErrorSeleccionVal
        .extern MensajeFilas
        .extern LargoMensajeFilasVal
        .extern MensajeColumnas
        .extern LargoMensajeColumnasVal
        .extern MensajeMinas
        .extern LargoMensajeMinasVal
        .extern MensajeErrorCantidadFilas
        .extern LargoMensajeErrorCantidadFilasVal
        .extern MensajeErrorCantidadColumnas
        .extern LargoMensajeErrorCantidadColumnasVal
        .extern MensajeErrorCantidadMinas
        .extern LargoMensajeErrorCantidadMinasVal

_start:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        // Inicializar temporales y configuración a cero
        // Inicializar semilla aleatoria con el PID del proceso
        MOV x8, #172 // syscall getpid
        SVC #0
        LDR x3, =Semilla
        STR x0, [x3]
        LDR x1, =TmpFilas
        MOV x0, #0
        STR x0, [x1]
        LDR x1, =TmpColumnas
        MOV x0, #0
        STR x0, [x1]
        LDR x1, =TmpMinas
        MOV x0, #0
        STR x0, [x1]
        LDR x1, =FilasSel
        MOV x0, #0
        STR x0, [x1]
        LDR x1, =ColumnasSel
        MOV x0, #0
        STR x0, [x1]
        LDR x1, =MinasSel
        MOV x0, #0
        STR x0, [x1]
        BL f01IniciarPrograma
        BL f02MenuPrincipal
        // Salir correctamente del programa
        MOV x0, #0
        MOV x8, #93     // syscall exit
        SVC #0

f01IniciarPrograma:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =Bienvenida
        LDR x2, =LargoBienvenidaVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        ldp x29, x30, [sp], 16
        RET

f02MenuPrincipal:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =Menu
        LDR x2, =LargoMenuVal
        LDR x2, [x2]
        BL f01ImprimirCadena

        // Inicializar OpcionSel a cero antes de leer
        LDR x1, =OpcionSel
        MOV x0, #0
        STR x0, [x1]
        BL f03LeerNumero
        MOV x9, x0

        CMP x9, #5
        BEQ f03SalirPrograma

        CMP x9, #1
        BEQ f04Principiante
        CMP x9, #2
        BEQ f05Intermedio
        CMP x9, #3
        BEQ f06Experto
        CMP x9, #4
        BEQ f07Personalizada

        LDR x1, =MensajeErrorSeleccion
        LDR x2, =LargoMensajeErrorSeleccionVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f02MenuPrincipal

f03SalirPrograma:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x1, =MensajeSalir
        LDR x2, =LargoMensajeSalirVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        MOV x0, #0
        MOV x8, #93
        ldp x29, x30, [sp], 16
        SVC #0

f04Principiante:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #8
        MOV x1, #8
        MOV x2, #10
        BL f12GuardarConfig
        ldp x29, x30, [sp], 16
        RET

f05Intermedio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #16
        MOV x1, #16
        MOV x2, #40
        BL f12GuardarConfig
        ldp x29, x30, [sp], 16
        RET

f06Experto:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #30
        MOV x1, #16
        MOV x2, #99
        BL f12GuardarConfig
        ldp x29, x30, [sp], 16
        RET
f07Personalizada:
        stp x29, x30, [sp, -16]!
        mov x29, sp

f08LeerFilas:
        LDR x1, =MensajeFilas
        LDR x2, =LargoMensajeFilasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0
        MOV x0, x10
        MOV x1, #8
        MOV x2, #30
        BL f04ValidarRango
        CMP x0, #0
        BEQ f08ErrorFilas
        // Si válido, guardar
        LDR x13, =TmpFilas
        STR x10, [x13]
        B f09LeerColumnas

f08ErrorFilas:
        LDR x1, =MensajeErrorCantidadFilas
        LDR x2, =LargoMensajeErrorCantidadFilasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f08LeerFilas

f09LeerColumnas:
        LDR x1, =MensajeColumnas
        LDR x2, =LargoMensajeColumnasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0
        MOV x0, x11
        MOV x1, #8
        MOV x2, #24
        BL f04ValidarRango
        CMP x0, #0
        BEQ f09ErrorColumnas
        // Si válido, guardar
        LDR x13, =TmpColumnas
        STR x11, [x13]
        B f10LeerMinas

f09ErrorColumnas:
        LDR x1, =MensajeErrorCantidadColumnas
        LDR x2, =LargoMensajeErrorCantidadColumnasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f09LeerColumnas
f10LeerMinas:

        LDR x1, =MensajeMinas
        LDR x2, =LargoMensajeMinasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x12, x0
        MOV x0, x12
        MOV x1, #1
        MUL x2, x10, x11
        SUB x2, x2, #1
        BL f04ValidarRango
        CMP x0, #0
        BEQ f10MinasError
        B f10GuardarMinas
f10GuardarMinas:
        LDR x13, =TmpMinas
        STR x12, [x13]
        B f11MinasOK
f10MinasError:
        LDR x1, =MensajeErrorCantidadMinas
        LDR x2, =LargoMensajeErrorCantidadMinasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f10LeerMinas

        LDR x1, =MensajeErrorCantidadMinas
        LDR x2, =LargoMensajeErrorCantidadMinasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f10LeerMinas

f11MinasOK:
        LDR x13, =TmpFilas
        LDR x0, [x13]
        LDR x14, =TmpColumnas
        LDR x1, [x14]
        LDR x15, =TmpMinas
        LDR x2, [x15]
        BL f12GuardarConfig
        ldp x29, x30, [sp], 16
        RET

f12GuardarConfig:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        LDR x13, =FilasSel
        STR x0, [x13]
        LDR x14, =ColumnasSel
        STR x1, [x14]
        LDR x15, =MinasSel
        STR x2, [x15]

        BL f01ConfigurarYJugar
        ldp x29, x30, [sp], 16
        RET
