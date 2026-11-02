#include "modules/efectos.h"

static volatile uint8_t  encendidos = 0;
static volatile uint16_t periodoMotor = 2;
static volatile uint16_t contadorMotor = 0;

void efectosInit() {
    motorInit();
    neopixelInit();
}

void efectosEncender(uint8_t r, uint8_t g, uint8_t b) {
    motorEncender(MOTOR_CW);
    neopixelMostrar(r, g, b);
}

void efectosApagar() {
    motorApagar();
    neopixelMostrar(0, 0, 0);
}

void tareaMotor() {
   if (!encendidos) return;
   if (++contadorMotor >= periodoMotor) {
      contadorMotor = 0;
      motorPaso();
   }
}