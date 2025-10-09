        .section .bss
        .global  FilasSel
        .global  ColumnasSel
        .global  MinasSel
        .global  OpcionSel
FilasSel:    .skip 8
ColumnasSel: .skip 8
MinasSel:    .skip 8
OpcionSel:      .skip 8

        .section .text
        // Rutina para calcular y guardar el largo de cada mensaje automáticamente
        // Debe llamarse al inicio de _start
        // Requiere: .extern f05LongitudCadena

        calcular_largos_mensajes:
                // Bienvenida
                ldr x1, =Bienvenida
                bl f05LongitudCadena
                ldr x2, =LargoBienvenidaVal
                str x0, [x2]
                // Menu
                ldr x1, =Menu
                bl f05LongitudCadena
                ldr x2, =LargoMenuVal
                str x0, [x2]
                // MensajeSalir
                ldr x1, =MensajeSalir
                bl f05LongitudCadena
                ldr x2, =LargoMensajeSalirVal
                str x0, [x2]
                // MensajeErrorSeleccion
                ldr x1, =MensajeErrorSeleccion
                bl f05LongitudCadena
                ldr x2, =LargoMensajeErrorSeleccionVal
                str x0, [x2]
                // MensajeFilas
                ldr x1, =MensajeFilas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeFilasVal
                str x0, [x2]
                // MensajeColumnas
                ldr x1, =MensajeColumnas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeColumnasVal
                str x0, [x2]
                // MensajeMinas
                ldr x1, =MensajeMinas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeMinasVal
                str x0, [x2]
                // MensajeErrorCantidadFilas
                ldr x1, =MensajeErrorCantidadFilas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeErrorCantidadFilasVal
                str x0, [x2]
                // MensajeErrorCantidadColumnas
                ldr x1, =MensajeErrorCantidadColumnas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeErrorCantidadColumnasVal
                str x0, [x2]
                // MensajeErrorCantidadMinas
                ldr x1, =MensajeErrorCantidadMinas
                bl f05LongitudCadena
                ldr x2, =LargoMensajeErrorCantidadMinasVal
                str x0, [x2]
                // MenuAccion
                ldr x1, =MenuAccion
                bl f05LongitudCadena
                ldr x2, =LargoMenuAccionVal
                str x0, [x2]
                // MensajeFila
                ldr x1, =MensajeFila
                bl f05LongitudCadena
                ldr x2, =LargoMensajeFilaVal
                str x0, [x2]
                // MensajeColumna
                ldr x1, =MensajeColumna
                bl f05LongitudCadena
                ldr x2, =LargoMensajeColumnaVal
                str x0, [x2]
                // MensajeDerrota
                ldr x1, =MensajeDerrota
                bl f05LongitudCadena
                ldr x2, =LargoMensajeDerrotaVal
                str x0, [x2]
                // MensajeVictoria
                ldr x1, =MensajeVictoria
                bl f05LongitudCadena
                ldr x2, =LargoMensajeVictoriaVal
                str x0, [x2]
                // SimboloVacio
                ldr x1, =SimboloVacio
                bl f05LongitudCadena
                ldr x2, =LargoSimboloVacioVal
                str x0, [x2]
                // SimboloMina
                ldr x1, =SimboloMina
                bl f05LongitudCadena
                ldr x2, =LargoSimboloMinaVal
                str x0, [x2]
                // SimboloBandera
                ldr x1, =SimboloBandera
                bl f05LongitudCadena
                ldr x2, =LargoSimboloBanderaVal
                str x0, [x2]
                // NuevaLinea
                ldr x1, =NuevaLinea
                bl f05LongitudCadena
                ldr x2, =LargoNuevaLineaVal
                str x0, [x2]
                ret
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
        BL calcular_largos_mensajes
        BL f01IniciarPrograma
        BL f02MenuPrincipal
        ldp x29, x30, [sp], 16
        RET

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
        B f12GuardarConfig

f05Intermedio:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #16
        MOV x1, #16
        MOV x2, #40
        B f12GuardarConfig

f06Experto:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, #30
        MOV x1, #16
        MOV x2, #99
        B f12GuardarConfig

f07Personalizada:
        stp x29, x30, [sp, -16]!
        mov x29, sp
f08LeerFilas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
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
        BNE f09FilasOK

        LDR x1, =MensajeErrorCantidadFilas
        LDR x2, =LargoMensajeErrorCantidadFilasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f08LeerFilas

f09FilasOK:
        stp x29, x30, [sp, -16]!
        mov x29, sp
f09LeerColumnas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
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
        BNE f10ColumnasOK

        LDR x1, =MensajeErrorCantidadColumnas
        LDR x2, =LargoMensajeErrorCantidadColumnasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f09LeerColumnas

f10ColumnasOK:
        stp x29, x30, [sp, -16]!
        mov x29, sp
f10LeerMinas:
        stp x29, x30, [sp, -16]!
        mov x29, sp
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
        BNE f11MinasOK

        LDR x1, =MensajeErrorCantidadMinas
        LDR x2, =LargoMensajeErrorCantidadMinasVal
        LDR x2, [x2]
        BL f01ImprimirCadena
        B f10LeerMinas

f11MinasOK:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        MOV x0, x10
        MOV x1, x11
        MOV x2, x12
        B f12GuardarConfig

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
        B f02MenuPrincipal
