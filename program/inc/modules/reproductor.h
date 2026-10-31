#ifndef REPRODUCTOR_H
#define REPRODUCTOR_H

#include "drivers/dfplayer.h"

#define BUSY_PIN        GPIO2

void reproductorInit(void);
void reproductorPista(uint8_t pista);
//void reproductorSiguiente(void);
//void reproductorAnterior(void);
//void reproductorPausaContinuar(void);
void   reproductorDetener(void);
bool_t reproductorFinPista(void);   // TRUE una sola vez al terminar la pista

#endif
