#ifndef MOTOR_H
#define MOTOR_H

#include "main.h"

#define MOTOR_IN1 GPIO5
#define MOTOR_IN2 GPIO6
#define MOTOR_IN3 GPIO7
#define MOTOR_IN4 GPIO8

#define MOTOR_STEPS_PER_REV 4096u // half-steps por vuelta del eje de salida (aprox.)

typedef enum { 
    MOTOR_CW,
    MOTOR_CCW
} motorDir_t;

void    tareaMotor(void);   
void    motorInit(void);   
void    motorEncender(motorDir_t dir);
void    motorApagar(void);

#endif