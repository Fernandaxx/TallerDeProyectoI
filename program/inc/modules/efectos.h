#ifndef EFECTOS_H
#define EFECTOS_H

#include "main.h"
#include "drivers/motor.h"
#include "drivers/neopixel.h"

void efectosInit(void);
void efectosEncender(uint8_t r, uint8_t g, uint8_t b);
void efectosApagar(void);
void tareaMotor(void);

#endif