#include "main.h"
#include "mef.h"

#include "modules/display.h"
#include "modules/motor.h"
#include "modules/rfid.h"
#include "leds.h"

#define RFID_PERIODO      10  // 8 x 20 ms = 200 ms
#define VOLUMEN_PERIODO   3   // 3 x 20 ms =  60 ms
 
static volatile bool_t flagMEF = FALSE;
uint8_t contRFID = 0;
uint8_t contVolumen = 0;

// Callback del SysTick (1 ms)
static void tickHook(void *param)
{
    static uint8_t cont = 0;
    (void)param;
 
    tareaMotor();
 
    if (++cont >= MEF_TICK_MS) {
        cont = 0;
        flagMEF = TRUE;
    }
}

int main(void)
{
    boardConfig();

    uartConfig(UART_USB, 115200);   // para el reproductor
    i2cInit(I2C0, 100000);          // para la pantalla
    spiConfig(SPI0);                // para el lector RFID
    
    displayInit();
    rfidInit();
    motorInit();
    neopixel_init();

    mefInit();

    tickCallbackSet(tickHook, NULL);
    while (1) {
        if (flagMEF) {
            flagMEF = FALSE;
 
            if (++contRFID >= RFID_PERIODO) {
                contRFID = 0;
                tareaRFID();
            }
            if (++contVolumen >= VOLUMEN_PERIODO) {
                contVolumen = 0;
                //tareaVolumen();
            }
 
            mefActualizar();

            tareaPantalla();
        }
    }
    return 0;
}

 