# Compilador y enlazador
AS      = as
LD      = ld
ASFLAGS = --warn --fatal-warnings
LDFLAGS = 

# Archivos objeto
OBJS = main.o logica.o tablero.o utilidades.o io.o constantes.o

# Ejecutable final
TARGET = buscaminas

# Regla principal
all: $(TARGET)

# Enlazado
$(TARGET): $(OBJS)
    $(LD) -o $@ $(OBJS) $(LDFLAGS)

# Compilación de cada .s a .o
%.o: %.s
    $(AS) $(ASFLAGS) -o $@ $<


# Limpieza
clean:
    rm -f $(OBJS) $(TARGET)
