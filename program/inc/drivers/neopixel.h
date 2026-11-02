#ifndef NEOPIXEL_H_
#define NEOPIXEL_H_

#include "main.h"

#define NEO_PIN T_FIL1  //Pin P1-36
// de sapi_gpio.c -> { {4, 1}, FUNC0, {2, 1} },   //   0   CON1_36   T_FIL1 
#define NEO_GPIO_PORT  2
#define NEO_GPIO_BIT   1

#define CANT_NEOPIXEL 22          

void neopixelInit(void);
void neopixelMostrar(uint8_t r, uint8_t g, uint8_t b);

#endif