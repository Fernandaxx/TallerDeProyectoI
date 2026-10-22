
#ifndef MP3_TF_16P_H
#define MP3_TF_16P_H

#include "sapi.h"
#include <stdint.h>

void mp3Init(void);
void mp3Reproducir(uint16_t pista);
void mp3Siguiente(void);
void mp3Anterior(void);
void mp3Pausar(void);
void mp3Continuar(void);
void mp3Volumen(uint8_t volumen);

#endif
