#ifndef BIBLIOTECA_H
#define BIBLIOTECA_H

#include "main.h"

#define UID_LEN      7
#define MAX_TAGS     64
#define ARTISTA_LEN  20
#define CANCION_LEN  28

typedef struct {
    uint8_t uid[UID_LEN];
    uint8_t pista;
    uint8_t r, g, b;
    char    artista[ARTISTA_LEN];
    char    cancion[CANCION_LEN];
} tag_t;

void    bibliotecaInit(void);                                   // carga inicial si la EEPROM está vacía
int16_t bibliotecaBuscar(const uint8_t *uid, uint8_t size, tag_t *disco);

#endif