#ifndef LEDS_H_
#define LEDS_H_

#include "sapi.h"
#include <stdint.h>

#define NEO_PIN      T_FIL1       /* Pin P1-36 en EDU-CIAA (a traves del inversor 2N7000) */
#define NUM_LEDS     22           /* Cantidad de LEDs segun informe */

/* Despues de boardConfig(). Devuelve 1 si ok, 0 si no pudo ubicar el pin GPIO. */
uint8_t neopixel_init(void);
void    neopixel_set_color(uint8_t r, uint8_t g, uint8_t b);  /* un LED, SIN deshabilitar IRQ */
void    neopixel_show_all(uint8_t r, uint8_t g, uint8_t b);   /* toda la tira, color uniforme */

#endif