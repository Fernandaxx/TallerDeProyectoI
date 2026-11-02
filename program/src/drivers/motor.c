#include "drivers/motor.h"

static const uint8_t seq[8] = { 0x1, 0x3, 0x2, 0x6, 0x4, 0xC, 0x8, 0x9 };

static uint8_t paso = 1; // 1 = half-step, 2 = full-step
static uint8_t fase = 0;
static int8_t sentido = 1;

static void salidas(uint8_t v) {
   gpioWrite(MOTOR_IN1, (v & 0x1) ? ON : OFF);
   gpioWrite(MOTOR_IN2, (v & 0x2) ? ON : OFF);
   gpioWrite(MOTOR_IN3, (v & 0x4) ? ON : OFF);
   gpioWrite(MOTOR_IN4, (v & 0x8) ? ON : OFF);
}

static void motorSetFullstep(uint8_t fullstep) {
   paso = fullstep ? 2 : 1;
   if (fullstep) fase |= 0x01; // queda en un estado impar (dos bobinas)
}

void motorInit(void) {
   gpioConfig(MOTOR_IN1, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN2, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN3, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN4, GPIO_OUTPUT);
   motorSetFullstep(1);
   salidas(0);
}

void motorEncender(motorDir_t dir) {
   sentido  = (dir == MOTOR_CW) ? 1 : -1;
}

void motorApagar(void) {
   salidas(0);
}

void motorPaso() {
   fase = (fase + sentido * paso) & 0x07;
   salidas(seq[fase]);
}