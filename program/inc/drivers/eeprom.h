#include "main.h"

#define UID_LEN      7
#define MAX_TAGS     64
#define ARTISTA_LEN  20
#define CANCION_LEN  28

typedef struct {
    uint8_t     uid[UID_LEN]; 
    uint8_t     pista;
    uint8_t     r, g, b;
    char artista[ARTISTA_LEN];
    char cancion[CANCION_LEN];
    uint8_t reservado[5]; //relleno a 64 bytes
} tag_t;

bool_t  eepromLeer(uint16_t dir , uint8_t *dst , uint16_t n);
bool_t  eepromEscribir(uint16_t dir , const uint8_t *src , uint16_t n);
void    eepromCargarInicial(void);
int16_t eepromBuscarTag(const uint8_t *uid , uint8_t size , tag_t *t);