#include "modules/motor.h"

static const uint8_t seq[8] = { 0x1, 0x3, 0x2, 0x6, 0x4, 0xC, 0x8, 0x9 };

static volatile uint8_t paso = 1; // 1 = half-step, 2 = full-step
static volatile uint8_t encendido = 0;
static volatile uint8_t fase = 0;
static volatile int8_t sentido = 1;
static volatile uint16_t periodo = 2;
static volatile uint16_t contador = 0;

static void salidas(uint8_t v)
{
   gpioWrite(MOTOR_IN1, (v & 0x1) ? ON : OFF);
   gpioWrite(MOTOR_IN2, (v & 0x2) ? ON : OFF);
   gpioWrite(MOTOR_IN3, (v & 0x4) ? ON : OFF);
   gpioWrite(MOTOR_IN4, (v & 0x8) ? ON : OFF);
}

static void motor_set_fullstep(uint8_t fullstep)
{
   paso = fullstep ? 2 : 1;
   if (fullstep) fase |= 0x01; // queda en un estado impar (dos bobinas)
}

void tareaMotor(void)
{
   if (!encendido) return;
   if (++contador >= periodo) {
      contador = 0;
      fase = (fase + sentido * paso) & 0x07;
      salidas(seq[fase]);
   }
}

void motorInit(void)
{
   gpioConfig(MOTOR_IN1, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN2, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN3, GPIO_OUTPUT);
   gpioConfig(MOTOR_IN4, GPIO_OUTPUT);
   motor_set_fullstep(1);
   salidas(0);
}

void motorEncender(motorDir_t dir)
{
   encendido  = 0;
   sentido  = (dir == MOTOR_CW) ? 1 : -1;
   contador = 0;
   encendido  = 1;
}

void motorApagar(void)
{
   encendido = 0;
   salidas(0);
}
