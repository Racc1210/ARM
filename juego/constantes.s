        .section .data

// ============================
// Mensaje de bienvenida y salida
// ============================

        .global Bienvenida, BienvenidaFinal, LargoBienvenidaVal
        .global MensajeSalir, MensajeSalirFinal, LargoMensajeSalirVal

Bienvenida:
        .asciz "\n==============================\n \
                BIENVENIDO A BUSCAMINAS ARM64\n \
                ==============================\n\n"
BienvenidaFinal:
LargoBienvenida = BienvenidaFinal - Bienvenida
LargoBienvenidaVal: .quad LargoBienvenida

MensajeSalir:
        .asciz "\nSaliendo del juego...\n"
MensajeSalirFinal:
LargoMensajeSalir = MensajeSalirFinal - MensajeSalir
LargoMensajeSalirVal: .quad LargoMensajeSalir

// ============================
// Menú principal
// ============================

        .global Menu, MenuFinal, LargoMenuVal
        .global MensajeErrorSeleccion, MensajeErrorSeleccionFinal, LargoMensajeErrorSeleccionVal

Menu:
        .asciz "==============================\n \
                SELECCIONE DIFICULTAD\n \
                ==============================\n \
                1. Principiante (8x8, 10 minas)\n \
                2. Intermedio   (16x16, 40 minas)\n \
                3. Experto      (30x16, 99 minas)\n \
                4. Personalizada\n \
                5. Salir\n \
                ==============================\n \
                Opción: "
MenuFinal:
LargoMenu = MenuFinal - Menu
LargoMenuVal: .quad LargoMenu

MensajeErrorSeleccion:
        .asciz "\nOpción inválida. Intente de nuevo.\n"
MensajeErrorSeleccionFinal:
LargoMensajeErrorSeleccion = MensajeErrorSeleccionFinal - MensajeErrorSeleccion
LargoMensajeErrorSeleccionVal: .quad LargoMensajeErrorSeleccion

// ============================
// Configuración personalizada
// ============================

        .global MensajeFilas, MensajeFilasFinal, LargoMensajeFilasVal
        .global MensajeColumnas, MensajeColumnasFinal, LargoMensajeColumnasVal
        .global MensajeMinas, MensajeMinasFinal, LargoMensajeMinasVal
        .global MensajeErrorCantidadFilas, MensajeErrorCantidadFilasFinal, LargoMensajeErrorCantidadFilasVal
        .global MensajeErrorCantidadColumnas, MensajeErrorCantidadColumnasFinal, LargoMensajeErrorCantidadColumnasVal
        .global MensajeErrorCantidadMinas, MensajeErrorCantidadMinasFinal, LargoMensajeErrorCantidadMinasVal

MensajeFilas:
        .asciz "Ingrese filas (8-30): "
MensajeFilasFinal:
LargoMensajeFilas = MensajeFilasFinal - MensajeFilas
LargoMensajeFilasVal: .quad LargoMensajeFilas

MensajeColumnas:
        .asciz "Ingrese columnas (8-24): "
MensajeColumnasFinal:
LargoMensajeColumnas = MensajeColumnasFinal - MensajeColumnas
LargoMensajeColumnasVal: .quad LargoMensajeColumnas

MensajeMinas:
        .asciz "Ingrese cantidad de minas: "
MensajeMinasFinal:
LargoMensajeMinas = MensajeMinasFinal - MensajeMinas
LargoMensajeMinasVal: .quad LargoMensajeMinas

MensajeErrorCantidadFilas:
        .asciz "\nLa cantidad de filas no está en el rango (8-30).\n"
MensajeErrorCantidadFilasFinal:
LargoMensajeErrorCantidadFilas = MensajeErrorCantidadFilasFinal - MensajeErrorCantidadFilas
LargoMensajeErrorCantidadFilasVal: .quad LargoMensajeErrorCantidadFilas

MensajeErrorCantidadColumnas:
        .asciz "\nLa cantidad de columnas no está en el rango (8-24).\n"
MensajeErrorCantidadColumnasFinal:
LargoMensajeErrorCantidadColumnas = MensajeErrorCantidadColumnasFinal - MensajeErrorCantidadColumnas
LargoMensajeErrorCantidadColumnasVal: .quad LargoMensajeErrorCantidadColumnas

MensajeErrorCantidadMinas:
        .asciz "\nLa cantidad de minas no debe ser mayor a (filas-1 * columnas-1).\n"
MensajeErrorCantidadMinasFinal:
LargoMensajeErrorCantidadMinas = MensajeErrorCantidadMinasFinal - MensajeErrorCantidadMinas
LargoMensajeErrorCantidadMinasVal: .quad LargoMensajeErrorCantidadMinas

// ============================
// Menú de acciones en partida
// ============================

        .global MenuAccion, MenuAccionFinal, LargoMenuAccionVal
        .global MensajeFila, MensajeFilaFinal, LargoMensajeFilaVal
        .global MensajeColumna, MensajeColumnaFinal, LargoMensajeColumnaVal

MenuAccion:
        .asciz "\n1. Descubrir celda\n \
                2. Colocar/Quitar bandera\n \
                3. Volver al menú\n \
                Opción: "
MenuAccionFinal:
LargoMenuAccion = MenuAccionFinal - MenuAccion
LargoMenuAccionVal: .quad LargoMenuAccion

MensajeFila:
        .asciz "Fila: "
MensajeFilaFinal:
LargoMensajeFila = MensajeFilaFinal - MensajeFila
LargoMensajeFilaVal: .quad LargoMensajeFila

MensajeColumna:
        .asciz "Columna: "
MensajeColumnaFinal:
LargoMensajeColumna = MensajeColumnaFinal - MensajeColumna
LargoMensajeColumnaVal: .quad LargoMensajeColumna

// ============================
// Mensajes de fin de juego
// ============================

        .global MensajeDerrota, MensajeDerrotaFinal, LargoMensajeDerrotaVal
        .global MensajeVictoria, MensajeVictoriaFinal, LargoMensajeVictoriaVal

MensajeDerrota:
        .asciz "\nBOOM! Has pisado una mina. Juego terminado.\n"
MensajeDerrotaFinal:
LargoMensajeDerrota = MensajeDerrotaFinal - MensajeDerrota
LargoMensajeDerrotaVal: .quad LargoMensajeDerrota

MensajeVictoria:
        .asciz "\nFelicidades, has despejado todo el tablero. ¡Victoria!\n"
MensajeVictoriaFinal:
LargoMensajeVictoria = MensajeVictoriaFinal - MensajeVictoria
LargoMensajeVictoriaVal: .quad LargoMensajeVictoria

// ============================
// Símbolos del tablero
// ============================

        .global SimboloVacio, SimboloVacioFinal, LargoSimboloVacioVal
        .global SimboloMina, SimboloMinaFinal, LargoSimboloMinaVal
        .global SimboloBandera, SimboloBanderaFinal, LargoSimboloBanderaVal
        .global NuevaLinea, NuevaLineaFinal, LargoNuevaLineaVal

SimboloVacio:
        .asciz "#"
SimboloVacioFinal:
LargoSimboloVacio = SimboloVacioFinal - SimboloVacio
LargoSimboloVacioVal: .quad LargoSimboloVacio

SimboloMina:
        .asciz "@"
SimboloMinaFinal:
LargoSimboloMina = SimboloMinaFinal - SimboloMina
LargoSimboloMinaVal: .quad LargoSimboloMina

SimboloBandera:
        .asciz "!"
SimboloBanderaFinal:
LargoSimboloBandera = SimboloBanderaFinal - SimboloBandera
LargoSimboloBanderaVal: .quad LargoSimboloBandera

NuevaLinea:
        .asciz "\n"
NuevaLineaFinal:
LargoNuevaLinea = NuevaLineaFinal - NuevaLinea
LargoNuevaLineaVal: .quad LargoNuevaLinea
