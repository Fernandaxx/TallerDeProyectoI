#include "main.h"
#include "modules/display.h"
#include "utils/sprites.h"

int main( void )
{
    boardConfig();
    i2cConfig(I2C0, 100000); // Usado por sh1106.c
    delayInaccurateMs(250); // Esperar a estabilización
    displayInit();

    displayDrawLine(10, 0, 10, 40,DISPLAY_WHITE);

   return 0;
}
