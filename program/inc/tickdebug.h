/*
 * tickdebug.h - Depuracion de la base de tiempo de la MEF
 *
 * Mide, para cada estado de la MEF:
 *   - cuantos ticks se ejecutaron y cuanto tiempo REAL tardo el estado
 *   - cuantos ticks se perdieron (real / MEF_TICK_MS - ticks)
 *   - el bloque de tick mas largo y la tarea de pantalla mas larga
 *
 * Al cambiar de estado imprime una linea por UART_USB (115200 8N1).
 * Ademas maneja dos pines para el analizador logico:
 *   GPIO3 (P2-34): se invierte al comenzar cada bloque de tick
 *                  (periodo observado = 2 x duracion real del tick)
 *   GPIO4 (P2-33): en alto mientras corre tareaPantalla()
 *
 * Se activa definiendo TICK_DEBUG (aca abajo o con -DTICK_DEBUG en el
 * Makefile). Si no esta definido, todos los macros se compilan a nada.
 */
#ifndef TICKDEBUG_H
#define TICKDEBUG_H

#include "sapi.h"

#define TICK_DEBUG        /* comentar esta linea para desactivar el debug */

#ifdef TICK_DEBUG

void tickDebugInit(void);
void tickDebugBloqueInicio(void);
void tickDebugBloqueFin(int estado);
void tickDebugPantallaInicio(void);
void tickDebugPantallaFin(void);
void tickDebugReporte(void);

#define TD_INIT()               tickDebugInit()
#define TD_BLOQUE_INICIO()      tickDebugBloqueInicio()
#define TD_BLOQUE_FIN(est)      tickDebugBloqueFin(est)
#define TD_PANTALLA_INICIO()    tickDebugPantallaInicio()
#define TD_PANTALLA_FIN()       tickDebugPantallaFin()
#define TD_REPORTE()            tickDebugReporte()

#else

#define TD_INIT()               ((void)0)
#define TD_BLOQUE_INICIO()      ((void)0)
#define TD_BLOQUE_FIN(est)      ((void)0)
#define TD_PANTALLA_INICIO()    ((void)0)
#define TD_PANTALLA_FIN()       ((void)0)
#define TD_REPORTE()            ((void)0)

#endif

#endif /* TICKDEBUG_H */