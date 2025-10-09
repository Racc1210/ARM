        .section .data

Bienvenida:
        .asciz "\n==============================\n" \
               "  BIENVENIDO A BUSCAMINAS ARM64\n" \
               "==============================\n\n"
BienvenidaFinal:
LargoBienvenida = BienvenidaFinal - Bienvenida

Menu:
        .asciz "==============================\n" \
               "   SELECCIONE DIFICULTAD\n" \
               "==============================\n" \
               "1. Principiante (8x8, 10 minas)\n" \
               "2. Intermedio   (16x16, 40 minas)\n" \
               "3. Experto      (30x16, 99 minas)\n" \
               "4. Personalizada\n" \
               "5. Salir\n" \
               "==============================\n" \
               "Opción: "
MenuFinal:
LargoMenu = MenuFinal - Menu

MensajeFilas:     .asciz "Ingrese filas (8-30): "
MensajeFilasFinal:
LargoMensajeFilas = MensajeFilasFinal - MensajeFilas

MensajeColumnas:  .asciz "Ingrese columnas (8-24): "
MensajeColumnasFinal:
LargoMensajeColumnas = MensajeColumnasFinal - MensajeColumnas

MensajeMinas:     .asciz "Ingrese cantidad de minas: "
MensajeMinasFinal:
LargoMensajeMinas = MensajeMinasFinal - MensajeMinas

MensajeSalir:     .asciz "\nSaliendo del juego...\n"
MensajeSalirFinal:
LargoMensajeSalir = MensajeSalirFinal - MensajeSalir

MensajeErrorSeleccion: .asciz "\nOpción inválida. Intente de nuevo.\n"
MensajeErrorSeleccionFinal:
LargoMensajeErrorSeleccion = MensajeErrorSeleccionFinal - MensajeErrorSeleccion

MensajeErrorCantidadColumnas: .asciz "\nLa cantidad de columnas que quieres agregar no forma parte del rango (8-24).\n"
MensajeErrorCantidadColumnasFinal:
LargoMensajeErrorCantidadColumnas = MensajeErrorCantidadColumnasFinal - MensajeErrorCantidadColumnas

MensajeErrorCantidadFilas: .asciz "\nLa cantidad de filas que quieres agregar no forma parte del rango (8-30).\n"
MensajeErrorCantidadFilasFinal:
LargoMensajeErrorCantidadFilas = MensajeErrorCantidadFilasFinal - MensajeErrorCantidadFilas

MensajeErrorCantidadMinas: .asciz "\nLa cantidad de minas no debe de ser mayor a filas-1 * columnas-1\n"
MensajeErrorCantidadMinasFinal:
LargoMensajeErrorCantidadMinas = MensajeErrorCantidadMinasFinal - MensajeErrorCantidadMinas

Fin: .asciz "\nGracias por jugar. Fin del juego.\n"
FinFinal:
LargoFin = FinFinal - Fin

Buffer:    .skip 8

        .section .text
        .global _start

        // io.s
        .extern f01ImprimirCadena
        .extern f02LeerCadena

        // utilidades.s
        .extern f01AsciiANumero
        .extern f03LeerNumero
        .extern f04ValidarRango

        // tablero.s
        .extern f01InicializarTablero
        .extern f03ImprimirTablero

_start:
        BL f01IniciarPrograma
        BL f02MenuPrincipal

f01IniciarPrograma:
        LDR     x1, =Bienvenida
        MOV     x2, #LargoBienvenida
        BL f01ImprimirCadena
        RET

f02MenuPrincipal:
        LDR     x1, =Menu
        MOV     x2, #LargoMenu
        BL f01ImprimirCadena

        BL f03LeerNumero
        MOV x9, x0

        CMP  x9, #5
        BEQ  f04SalirPrograma
        BL f05ProcesarEleccion

        BL f01InicializarTablero
        BL f03ImprimirTablero

        BL f03BucleJuego
        B f02MenuPrincipal

f03BucleJuego:
        LDR     x1, =Fin
        MOV     x2, #LargoFin
        BL f01ImprimirCadena
        RET

f04SalirPrograma:
        LDR x1, =MensajeSalir
        MOV x2, #LargoMensajeSalir
        BL f01ImprimirCadena
        MOV     x0, #0
        MOV     x8, #93
        SVC     #0

f05ProcesarEleccion:
        CMP x9, #1
        BEQ f05ProcesarEleccion_Principiante

        CMP x9, #2
        BEQ f05ProcesarEleccion_Intermedio

        CMP x9, #3
        BEQ f05ProcesarEleccion_Experto

        CMP x9, #4
        BEQ f05ProcesarEleccion_Personalizada

        LDR x1, =MensajeErrorSeleccion
        MOV x2, #LargoMensajeErrorSeleccion
        BL f01ImprimirCadena
        B f02MenuPrincipal

f05ProcesarEleccion_Principiante:
        MOV x0, #8
        MOV x1, #8
        MOV x2, #10
        RET

f05ProcesarEleccion_Intermedio:
        MOV x0, #16
        MOV x1, #16
        MOV x2, #40
        RET

f05ProcesarEleccion_Experto:
        MOV x0, #30
        MOV x1, #16
        MOV x2, #99
        RET

f05ProcesarEleccion_Personalizada:
f05PersonalizadaLeerFilas:
        LDR x1, =MensajeFilas
        MOV x2, #LargoMensajeFilas
        BL f03LeerNumero
        MOV x10, x0

        MOV x0, x10
        MOV x1, #8
        MOV x2, #30
        BL f04ValidarRango
        CMP x0, #0
        BNE f05PersonalizadaFilasOK

        LDR x1, =MensajeErrorCantidadFilas
        MOV x2, #LargoMensajeErrorCantidadFilas
        BL f01ImprimirCadena
        B f05PersonalizadaLeerFilas

f05PersonalizadaFilasOK:
f05PersonalizadaLeerColumnas:
        LDR x1, =MensajeColumnas
        MOV x2, #LargoMensajeColumnas
        BL f03LeerNumero
        MOV x11, x0

        MOV x0, x11
        MOV x1, #8
        MOV x2, #24
        BL f04ValidarRango
        CMP x0, #0
        BNE f05PersonalizadaColumnasOK

        LDR x1, =MensajeErrorCantidadColumnas
        MOV x2, #LargoMensajeErrorCantidadColumnas
        BL f01ImprimirCadena
        B f05PersonalizadaLeerColumnas

f05PersonalizadaColumnasOK:
f05PersonalizadaLeerMinas:
        LDR x1, =MensajeMinas
        MOV x2, #LargoMensajeMinas
        BL f03LeerNumero
        MOV x12, x0

        MOV x0, x12
        MOV x1, #1
        MUL x2, x10, x11
        SUB x2, x2, #1
        BL f04ValidarRango
        CMP x0, #0
        BNE f05PersonalizadaMinasOK

        LDR x1, =MensajeErrorCantidadMinas
        MOV x2, #LargoMensajeErrorCantidadMinas
        BL f01ImprimirCadena
        B f05PersonalizadaLeerMinas

f05PersonalizadaMinasOK:
        MOV x0, x10
        MOV x1, x11
        MOV x2, x12
        RET
