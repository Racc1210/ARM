        .section .bss
FilasSel:    .skip 8
ColumnasSel: .skip 8
MinasSel:    .skip 8

        .section .text
        .global _start

        .extern f01ImprimirCadena
        .extern f03LeerNumero
        .extern f04ValidarRango

        .extern f01ConfigurarYJugar  

        .extern Bienvenida, LargoBienvenida
        .extern Menu, LargoMenu
        .extern MensajeSalir, LargoMensajeSalir
        .extern MensajeErrorSeleccion, LargoMensajeErrorSeleccion
        .extern MensajeFilas, LargoMensajeFilas
        .extern MensajeColumnas, LargoMensajeColumnas
        .extern MensajeMinas, LargoMensajeMinas
        .extern MensajeErrorCantidadFilas, LargoMensajeErrorCantidadFilas
        .extern MensajeErrorCantidadColumnas, LargoMensajeErrorCantidadColumnas
        .extern MensajeErrorCantidadMinas, LargoMensajeErrorCantidadMinas

_start:
        BL f01IniciarPrograma
        BL f02MenuPrincipal

f01IniciarPrograma:
        LDR x1, =Bienvenida
        MOV x2, #LargoBienvenida
        BL f01ImprimirCadena
        RET

f02MenuPrincipal:
        LDR x1, =Menu
        MOV x2, #LargoMenu
        BL f01ImprimirCadena

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
        MOV x2, #LargoMensajeErrorSeleccion
        BL f01ImprimirCadena
        B f02MenuPrincipal

f03SalirPrograma:
        LDR x1, =MensajeSalir
        MOV x2, #LargoMensajeSalir
        BL f01ImprimirCadena
        MOV x0, #0
        MOV x8, #93
        SVC #0

f04Principiante:
        MOV x0, #8
        MOV x1, #8
        MOV x2, #10
        B f12GuardarConfig

f05Intermedio:
        MOV x0, #16
        MOV x1, #16
        MOV x2, #40
        B f12GuardarConfig

f06Experto:
        MOV x0, #30
        MOV x1, #16
        MOV x2, #99
        B f12GuardarConfig



f07Personalizada:
f08LeerFilas:
        LDR x1, =MensajeFilas
        MOV x2, #LargoMensajeFilas
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x10, x0

        MOV x0, x10
        MOV x1, #8
        MOV x2, #30
        BL f04ValidarRango
        CMP x0, #0
        BNE f09FilasOK

        LDR x1, =MensajeErrorCantidadFilas
        MOV x2, #LargoMensajeErrorCantidadFilas
        BL f01ImprimirCadena
        B f08LeerFilas

f09FilasOK:
f09LeerColumnas:
        LDR x1, =MensajeColumnas
        MOV x2, #LargoMensajeColumnas
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x11, x0

        MOV x0, x11
        MOV x1, #8
        MOV x2, #24
        BL f04ValidarRango
        CMP x0, #0
        BNE f10ColumnasOK

        LDR x1, =MensajeErrorCantidadColumnas
        MOV x2, #LargoMensajeErrorCantidadColumnas
        BL f01ImprimirCadena
        B f09LeerColumnas

f10ColumnasOK:
f10LeerMinas:
        LDR x1, =MensajeMinas
        MOV x2, #LargoMensajeMinas
        BL f01ImprimirCadena
        BL f03LeerNumero
        MOV x12, x0

        MOV x0, x12
        MOV x1, #1
        MUL x2, x10, x11
        SUB x2, x2, #1
        BL f04ValidarRango
        CMP x0, #0
        BNE f11MinasOK

        LDR x1, =MensajeErrorCantidadMinas
        MOV x2, #LargoMensajeErrorCantidadMinas
        BL f01ImprimirCadena
        B f10LeerMinas

f11MinasOK:
        MOV x0, x10
        MOV x1, x11
        MOV x2, x12
        B f12GuardarConfig



f12GuardarConfig:
        LDR x13, =FilasSel
        STR x0, [x13]
        LDR x14, =ColumnasSel
        STR x1, [x14]
        LDR x15, =MinasSel
        STR x2, [x15]

        BL f01ConfigurarYJugar
        B f02MenuPrincipal
