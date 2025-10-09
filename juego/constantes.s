        .section .data

// ============================
// Mensaje de bienvenida y salida
// ============================

        .global Bienvenida, LargoBienvenidaVal
        .global MensajeSalir, LargoMensajeSalirVal

Bienvenida:
    .asciz "==============================\nBIENVENIDO A BUSCAMINAS ARM64\n==============================\n"
LargoBienvenidaVal: .quad 0

MensajeSalir:
    .asciz "\nSaliendo del juego...\n"
LargoMensajeSalirVal: .quad 0

// ============================
// Menú principal
// ============================

        .global Menu, LargoMenuVal
        .global MensajeErrorSeleccion, LargoMensajeErrorSeleccionVal

Menu:
    .asciz "==============================\nSELECCIONE DIFICULTAD\n==============================\n1. Principiante (8x8, 10 minas)\n2. Intermedio   (16x16, 40 minas)\n3. Experto      (30x16, 99 minas)\n4. Personalizada\n5. Salir\n==============================\nOpción: "
LargoMenuVal: .quad 0

MensajeErrorSeleccion:
    .asciz "\nOpción inválida. Intente de nuevo.\n"
LargoMensajeErrorSeleccionVal: .quad 0

// ============================
// Configuración personalizada
// ============================

        .global MensajeFilas, LargoMensajeFilasVal
        .global MensajeColumnas, LargoMensajeColumnasVal
        .global MensajeMinas, LargoMensajeMinasVal
        .global MensajeErrorCantidadFilas, LargoMensajeErrorCantidadFilasVal
        .global MensajeErrorCantidadColumnas, LargoMensajeErrorCantidadColumnasVal
        .global MensajeErrorCantidadMinas, LargoMensajeErrorCantidadMinasVal

MensajeFilas:
    .asciz "Ingrese filas (8-30): "
LargoMensajeFilasVal: .quad 0

MensajeColumnas:
    .asciz "Ingrese columnas (8-24): "
LargoMensajeColumnasVal: .quad 0

MensajeMinas:
    .asciz "Ingrese cantidad de minas: "
LargoMensajeMinasVal: .quad 0

MensajeErrorCantidadFilas:
    .asciz "\nLa cantidad de filas no está en el rango (8-30).\n"
LargoMensajeErrorCantidadFilasVal: .quad 0

MensajeErrorCantidadColumnas:
    .asciz "\nLa cantidad de columnas no está en el rango (8-24).\n"
LargoMensajeErrorCantidadColumnasVal: .quad 0

MensajeErrorCantidadMinas:
    .asciz "\nLa cantidad de minas no debe ser mayor a (filas-1 * columnas-1).\n"
LargoMensajeErrorCantidadMinasVal: .quad 0

// ============================
// Menú de acciones en partida
// ============================

        .global MenuAccion, LargoMenuAccionVal
        .global MensajeFila, LargoMensajeFilaVal
        .global MensajeColumna, LargoMensajeColumnaVal

MenuAccion:
    .asciz "\n1. Descubrir celda\n2. Colocar/Quitar bandera\n3. Volver al menu\nOpcion: "
LargoMenuAccionVal: .quad 0

MensajeFila:
    .asciz "Fila: "
LargoMensajeFilaVal: .quad 0

MensajeColumna:
    .asciz "Columna: "
LargoMensajeColumnaVal: .quad 0

// ============================
// Mensajes de fin de juego
// ============================

        .global MensajeDerrota, LargoMensajeDerrotaVal
        .global MensajeVictoria, LargoMensajeVictoriaVal

MensajeDerrota:
    .asciz "\nBOOM! Has pisado una mina. Juego terminado.\n"
LargoMensajeDerrotaVal: .quad 0

MensajeVictoria:
    .asciz "\nFelicidades, has despejado todo el tablero. ¡Victoria!\n"
LargoMensajeVictoriaVal: .quad 0

// ============================
// Símbolos del tablero
// ============================

        .global SimboloVacio, LargoSimboloVacioVal
        .global SimboloMina, LargoSimboloMinaVal
        .global SimboloBandera, LargoSimboloBanderaVal
        .global NuevaLinea, LargoNuevaLineaVal

SimboloVacio:
    .asciz "#"
LargoSimboloVacioVal: .quad 0

SimboloMina:
    .asciz "@"
LargoSimboloMinaVal: .quad 0

SimboloBandera:
    .asciz "!"
LargoSimboloBanderaVal: .quad 

NuevaLinea:
    .asciz "\n"
LargoNuevaLineaVal: .quad 0
