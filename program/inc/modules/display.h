#ifndef _DISPLAY_H_
#define _DISPLAY_H_

#include "main.h"
#include "drivers/oled.h"
#include "u8g2.h"

#define DISPLAY_WIDTH 128
#define DISPLAY_HEIGHT 64

#ifndef DISC_CX
#define DISC_CX      100
#endif
#ifndef DISC_CY
#define DISC_CY      38
#endif
#ifndef DEG2RAD
#define DEG2RAD      0.01745329252f
#endif
 
#define UI_TEXTO_MAX   28
#define ANGLE_STEP     10
#define ANIMATION_FRAMES  14
 
typedef enum {
    UI_INICIO = 0,
    UI_ESPERA,
    UI_REPRODUCIENDO,
    UI_FIN_PISTA,
    UI_NO_REGISTRADO,
    UI_CONFIG,
    UI_ERROR
} uiPantalla_t;
 
void displayInit(void);
 
void uiMostrar(uiPantalla_t p);
 
void tareaPantalla(void);
 
#endif
