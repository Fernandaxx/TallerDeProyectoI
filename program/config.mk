# Compile options

VERBOSE=n
OPT=g
USE_NANO=y
SEMIHOST=n
USE_FPU=y

# Libraries

USE_LPCOPEN=y
USE_SAPI=y
LOAD_INRAM=n

# Incluyo libreria u8g2, que estan en csrc en vez de src
INCLUDES += -I$(CURDIR)/libs/u8g2/csrc
SRC += $(wildcard $(CURDIR)/libs/u8g2/csrc/*.c)