
# Opciones de compilacion
VERBOSE=n
OPT=g
USE_NANO=y
SEMIHOST=n
USE_FPU=y

# Bibliotecas
USE_LPCOPEN=y
USE_SAPI=y
LOAD_INRAM=n

# Libreria u8g2
INCLUDES += -Ilibs/u8g2/csrc
SRC += $(wildcard libs/u8g2/csrc/*.c)
