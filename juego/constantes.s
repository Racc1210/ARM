.section .data

// Estados de celda del tablero
    .global ESTADO_OCULTA, ESTADO_DESCUBIERTA, ESTADO_BANDERA
ESTADO_OCULTA:      .quad 0
ESTADO_DESCUBIERTA: .quad 1
ESTADO_BANDERA:     .quad 2


// Mensaje de bienvenida y salida
.global Bienvenida, LargoBienvenidaVal
.global MensajeSalir, LargoMensajeSalirVal

Bienvenida:
    .asciz "==============================\nBIENVENIDO A BUSCAMINAS ARM64\n==============================\n"
LargoBienvenidaVal: .quad 92

MensajeSalir:
    .asciz "\nSaliendo del juego...\n"
LargoMensajeSalirVal: .quad 23

// Menú principal
.global Menu, LargoMenuVal
.global MensajeErrorSeleccion, LargoMensajeErrorSeleccionVal

Menu:
    .asciz "==============================\nSELECCIONE DIFICULTAD\n==============================\n1. Principiante (8x8, 10 minas)\n2. Intermedio   (16x16, 40 minas)\n3. Experto      (30x16, 99 minas)\n4. Personalizada\n5. Salir\n==============================\nOpción: "
LargoMenuVal: .quad 249

MensajeErrorSeleccion:
    .asciz "\nOpcion invalida. Intente de nuevo: "
LargoMensajeErrorSeleccionVal: .quad 36

// Configuración personalizada

.global MensajeFilas, LargoMensajeFilasVal
.global MensajeColumnas, LargoMensajeColumnasVal
.global MensajeMinas, LargoMensajeMinasVal
.global MensajeErrorCantidadFilas, LargoMensajeErrorCantidadFilasVal
.global MensajeErrorCantidadColumnas, LargoMensajeErrorCantidadColumnasVal
.global MensajeErrorCantidadMinas, LargoMensajeErrorCantidadMinasVal

MensajeFilas:
    .asciz "Ingrese filas (8-30): "
LargoMensajeFilasVal: .quad 22

MensajeColumnas:
    .asciz "Ingrese columnas (8-24): "
LargoMensajeColumnasVal: .quad 25

MensajeMinas:
    .asciz "Ingrese cantidad de minas: "
LargoMensajeMinasVal: .quad 27

MensajeErrorCantidadFilas:
    .asciz "\nLa cantidad de filas no está en el rango (8-30).\n"
LargoMensajeErrorCantidadFilasVal: .quad 50

MensajeErrorCantidadColumnas:
    .asciz "\nLa cantidad de columnas no está en el rango (8-24).\n"
LargoMensajeErrorCantidadColumnasVal: .quad 53

MensajeErrorCantidadMinas:
    .asciz "\nLa cantidad de minas no debe ser mayor a (filas-1 * columnas-1).\n"
LargoMensajeErrorCantidadMinasVal: .quad 66


// Menú de acciones en partida
.global MenuAccion, LargoMenuAccionVal
.global MensajeFila, LargoMensajeFilaVal
.global MensajeColumna, LargoMensajeColumnaVal
.global MensajeErrorFila, LargoMensajeErrorFilaVal
.global MensajeErrorColumna, LargoMensajeErrorColumnaVal

MenuAccion:
    .asciz "\n1. Descubrir celda\n2. Colocar/Quitar bandera\n3. Volver al menu\nOpcion: "
LargoMenuAccionVal: .quad 72

MensajeFila:
    .asciz "Fila: "
LargoMensajeFilaVal: .quad 6

MensajeColumna:
    .asciz "Columna: "
LargoMensajeColumnaVal: .quad 9

MensajeErrorFila:
    .asciz "Fila invalida. Intente de nuevo.\n"
LargoMensajeErrorFilaVal: .quad 34

MensajeErrorColumna:
    .asciz "Columna invalida. Intente de nuevo.\n"
LargoMensajeErrorColumnaVal: .quad 37


// Mensajes de fin de juego
.global MensajeDerrota, LargoMensajeDerrotaVal
.global MensajeVictoria, LargoMensajeVictoriaVal

MensajeDerrota:
    .asciz "\nBOOM! Has pisado una mina. Juego terminado.\n"
LargoMensajeDerrotaVal: .quad 45

MensajeVictoria:
    .asciz "\nFelicidades, has despejado todo el tablero. ¡Victoria!\n"
LargoMensajeVictoriaVal: .quad 57


// Símbolos del tablero
.global SimboloVacio, LargoSimboloVacioVal
.global SimboloMina, LargoSimboloMinaVal
.global SimboloBandera, LargoSimboloBanderaVal
.global NuevaLinea, LargoNuevaLineaVal
.global Espacio, LargoEspacioVal

SimboloVacio:
    .asciz "#"
LargoSimboloVacioVal: .quad 1

SimboloMina:
    .asciz "@"
LargoSimboloMinaVal: .quad 1

SimboloBandera:
    .asciz "!"
LargoSimboloBanderaVal: .quad 1

NuevaLinea:
    .asciz "\n"
LargoNuevaLineaVal: .quad 1

Espacio:
    .asciz "_"
LargoEspacioVal: .quad 1
