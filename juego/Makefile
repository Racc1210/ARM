# Makefile para proyecto Buscaminas ARM64

AS=as
LD=ld
ASFLAGS=
LDFLAGS=

SRC=main.s logica.s tablero.s utilidades.s io.s constantes.s
OBJ=$(SRC:.s=.o)

BIN=juego

all: $(BIN)

$(BIN): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f $(OBJ) $(BIN)

rebuild: clean all

run: $(BIN)
	./$(BIN)

play: rebuild run

.PHONY: all clean rebuild run play
