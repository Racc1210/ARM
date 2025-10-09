        .section .data

        // Mensajes globales y sus longitudes
        .global Bienvenida, BienvenidaFinal, LargoBienvenida
        .global MensajeSalir, MensajeSalirFinal, LargoMensajeSalir

        .global Menu, MenuFinal, LargoMenu
        .global MensajeErrorSeleccion, MensajeErrorSeleccionFinal, LargoMensajeErrorSeleccion

        .global MensajeFilas, MensajeFilasFinal, LargoMensajeFilas
        .global MensajeColumnas, MensajeColumnasFinal, LargoMensajeColumnas
        .global MensajeMinas, MensajeMinasFinal, LargoMensajeMinas
        .global MensajeErrorCantidadFilas, MensajeErrorCantidadFilasFinal, LargoMensajeErrorCantidadFilas
        .global MensajeErrorCantidadColumnas, MensajeErrorCantidadColumnasFinal, LargoMensajeErrorCantidadColumnas
        .global MensajeErrorCantidadMinas, MensajeErrorCantidadMinasFinal, LargoMensajeErrorCantidadMinas

        .global MenuAccion, MenuAccionFinal, LargoMenuAccion
        .global MensajeFila, MensajeFilaFinal, LargoMensajeFila
        .global MensajeColumna, MensajeColumnaFinal, LargoMensajeColumna

        .global MensajeDerrota, MensajeDerrotaFinal, LargoMensajeDerrota
        .global MensajeVictoria, MensajeVictoriaFinal, LargoMensajeVictoria

        .global SimboloVacio, SimboloVacioFinal, LargoSimboloVacio
        .global SimboloMina, SimboloMinaFinal, LargoSimboloMina
        .global SimboloBandera, SimboloBanderaFinal, LargoSimboloBandera
        .global NuevaLinea, NuevaLineaFinal, LargoNuevaLinea

Bienvenida:
        .asciz "\n==============================\n \
                BIENVENIDO A BUSCAMINAS ARM64\n \
                ==============================\n\n"
BienvenidaFinal:
LargoBienvenida = BienvenidaFinal - Bienvenida

MensajeSalir:
        .asciz "\nSaliendo del juego...\n"
MensajeSalirFinal:
LargoMensajeSalir = MensajeSalirFinal - MensajeSalir

// ============================
// Menú principal
// ============================

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

MensajeErrorSeleccion:
        .asciz "\nOpción inválida. Intente de nuevo.\n"
MensajeErrorSeleccionFinal:
LargoMensajeErrorSeleccion = MensajeErrorSeleccionFinal - MensajeErrorSeleccion

// ============================
// Configuración personalizada
// ============================

MensajeFilas:
        .asciz "Ingrese filas (8-30): "
MensajeFilasFinal:
LargoMensajeFilas = MensajeFilasFinal - MensajeFilas

MensajeColumnas:
        .asciz "Ingrese columnas (8-24): "
MensajeColumnasFinal:
LargoMensajeColumnas = MensajeColumnasFinal - MensajeColumnas

MensajeMinas:
        .asciz "Ingrese cantidad de minas: "
MensajeMinasFinal:
LargoMensajeMinas = MensajeMinasFinal - MensajeMinas

MensajeErrorCantidadFilas:
        .asciz "\nLa cantidad de filas no está en el rango (8-30).\n"
MensajeErrorCantidadFilasFinal:
LargoMensajeErrorCantidadFilas = MensajeErrorCantidadFilasFinal - MensajeErrorCantidadFilas

MensajeErrorCantidadColumnas:
        .asciz "\nLa cantidad de columnas no está en el rango (8-24).\n"
MensajeErrorCantidadColumnasFinal:
LargoMensajeErrorCantidadColumnas = MensajeErrorCantidadColumnasFinal - MensajeErrorCantidadColumnas

MensajeErrorCantidadMinas:
        .asciz "\nLa cantidad de minas no debe ser mayor a (filas-1 * columnas-1).\n"
MensajeErrorCantidadMinasFinal:
LargoMensajeErrorCantidadMinas = MensajeErrorCantidadMinasFinal - MensajeErrorCantidadMinas

// ============================
// Menú de acciones en partida
// ============================

MenuAccion:
        .asciz "\n1. Descubrir celda\n \
                2. Colocar/Quitar bandera\n \
                3. Volver al menú\n \
                Opción: "
MenuAccionFinal:
LargoMenuAccion = MenuAccionFinal - MenuAccion

MensajeFila:
        .asciz "Fila: "
MensajeFilaFinal:
LargoMensajeFila = MensajeFilaFinal - MensajeFila

MensajeColumna:
        .asciz "Columna: "
MensajeColumnaFinal:
LargoMensajeColumna = MensajeColumnaFinal - MensajeColumna

// ============================
// Mensajes de fin de juego
// ============================

MensajeDerrota:
        .asciz "\nBOOM! Has pisado una mina. Juego terminado.\n"
MensajeDerrotaFinal:
LargoMensajeDerrota = MensajeDerrotaFinal - MensajeDerrota

MensajeVictoria:
        .asciz "\nFelicidades, has despejado todo el tablero. ¡Victoria!\n"
MensajeVictoriaFinal:
LargoMensajeVictoria = MensajeVictoriaFinal - MensajeVictoria

// ============================
// Símbolos del tablero
// ============================

SimboloVacio:
        .asciz "#"
SimboloVacioFinal:
LargoSimboloVacio = SimboloVacioFinal - SimboloVacio

SimboloMina:
        .asciz "@"
SimboloMinaFinal:
LargoSimboloMina = SimboloMinaFinal - SimboloMina

SimboloBandera:
        .asciz "!"
SimboloBanderaFinal:
LargoSimboloBandera = SimboloBanderaFinal - SimboloBandera

NuevaLinea:
        .asciz "\n"
NuevaLineaFinal:
LargoNuevaLinea = NuevaLineaFinal - NuevaLinea
