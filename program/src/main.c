/*
 * Base de tiempo:
 *   - SysTick de 1 ms (sAPI). Su callback corre en la ISR y solo hace dos
 *     cosas cortas: avanzar el paso del motor y, cada MEF_TICK_MS, levantar
 *     el flag que dispara el "tick de la MEF".
 *   - El tick de la MEF se atiende en el lazo principal (fuera de la ISR).
 *
 * En cada tick de la MEF, en este orden:
 *   1) tareas periodicas de ENTRADA (RFID, volumen), con su periodo en ticks
 *   2) mefTick(): transiciones y salidas
 *   3) tareaPantalla(): una pagina de la pantalla
 * La pantalla va despues de la MEF para que un uiMostrar() hecho por la MEF
 * se empiece a dibujar en ese mismo tick.
 */
 
#include "main.h"
#include "u8g2.h"
#include "mef.h"
#include "tickdebug.h"
#include "modules/display.h"

#define RFID_PERIODO_TICKS      8      /* 8 x 20 ms = 160 ms */
#define VOLUMEN_PERIODO_TICKS   3      /* 3 x 20 ms =  60 ms */
 
static volatile bool_t   flagMEF = FALSE;
uint8_t contRFID    = 0;
uint8_t contVolumen = 0;

// Callback del SysTick (1 ms, corre en la ISR)
static void tickHook(void *param)
{
    static uint8_t cont = 0;
    (void)param;
 
    //motorISR(); //avanza un paso el motor si corresponde (solo GPIO)
 
    if (++cont >= MEF_TICK_MS) {
        cont = 0;
        flagMEF = TRUE;
    }
}

int main(void)
{
    boardConfig();
    i2cInit(I2C0, 100000); // para la pantalla
    
    displayInit();
    mefInit();

    tickCallbackSet(tickHook, NULL);
    while (1) {
        if (flagMEF) {
            flagMEF = FALSE;
 
            // Tareas periodicas
            if (++contRFID >= RFID_PERIODO_TICKS) {
                contRFID = 0;
                //tareaRFID();
            }
            if (++contVolumen >= VOLUMEN_PERIODO_TICKS) {
                contVolumen = 0;
                //tareaVolumen();
            }
 
            mefActualizar();

            tareaPantalla();
        }

        //tareaReproductor(); // procesar la UART del DFPlayer sin bloquear afuera del tick
       
    }
    return 0;
}

 