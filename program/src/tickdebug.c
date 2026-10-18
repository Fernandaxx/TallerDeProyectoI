/*
 * tickdebug.c - Depuracion de la base de tiempo de la MEF
 * Ver tickdebug.h para el uso.
 */
#include "tickdebug.h"

#ifdef TICK_DEBUG

#include "mef.h"
#include <stdio.h>
#include <string.h>

#define TD_PIN_BLOQUE   GPIO3     /* P2-34 (reserva, libre en el prototipo) */
#define TD_PIN_PANT     GPIO4     /* P2-33 (reserva, libre en el prototipo) */

/* Mismo orden que mefEstado_t */
static const char *const nombres[] = {
    "INICIO", "ESPERA", "IDENTIFICANDO", "REPRODUCIENDO",
    "FIN_PISTA", "NO_REGISTRADO", "CONFIGURACION", "ERROR"
};
#define TD_N_ESTADOS   ((int)(sizeof(nombres) / sizeof(nombres[0])))

typedef struct {
    int      estado;
    uint32_t ticks;        /* bloques de tick ejecutados en el estado        */
    uint32_t largos;       /* bloques que duraron mas que MEF_TICK_MS        */
    uint32_t maxBloque;    /* bloque mas largo [ms]                          */
    uint32_t maxPant;      /* tareaPantalla() mas larga [ms]                 */
    tick_t   tEntrada;     /* instante de entrada al estado [ms]             */
    uint32_t tReal;        /* duracion real del estado [ms] (solo en snap)   */
} tdEstado_t;

static tdEstado_t    cur  = { .estado = -1 };
static tdEstado_t    snap;
static volatile bool_t pendiente = FALSE;

static tick_t tBloque;
static tick_t tPant;

void tickDebugInit(void)
{
    gpioInit(TD_PIN_BLOQUE, GPIO_OUTPUT);
    gpioInit(TD_PIN_PANT,   GPIO_OUTPUT);
    gpioWrite(TD_PIN_BLOQUE, OFF);
    gpioWrite(TD_PIN_PANT,   OFF);
    uartConfig(UART_USB, 115200);
    uartWriteString(UART_USB, "[TD] debug de ticks activo\r\n");
}

void tickDebugBloqueInicio(void)
{
    tBloque = tickRead();
    gpioToggle(TD_PIN_BLOQUE);
}

void tickDebugPantallaInicio(void)
{
    tPant = tickRead();
    gpioWrite(TD_PIN_PANT, ON);
}

void tickDebugPantallaFin(void)
{
    uint32_t dur = (uint32_t)(tickRead() - tPant);
    gpioWrite(TD_PIN_PANT, OFF);
    if (dur > cur.maxPant) {
        cur.maxPant = dur;
    }
}

/* Llamar al final del bloque, con el estado de la MEF DESPUES de mefTick().
 * El ultimo bloque de un estado (el que dispara la transicion) se cuenta
 * todavia en el estado viejo. */
void tickDebugBloqueFin(int estado)
{
    tick_t   ahora = tickRead();
    uint32_t dur   = (uint32_t)(ahora - tBloque);

    cur.ticks++;
    if (dur > cur.maxBloque) {
        cur.maxBloque = dur;
    }
    if (dur > MEF_TICK_MS) {
        cur.largos++;
    }

    if (estado != cur.estado) {
        if (cur.estado >= 0) {                 /* cerrar el estado anterior */
            snap        = cur;
            snap.tReal  = (uint32_t)(ahora - cur.tEntrada);
            pendiente   = TRUE;
        }
        memset(&cur, 0, sizeof(cur));          /* abrir el nuevo */
        cur.estado   = estado;
        cur.tEntrada = ahora;
    }
}

/* Llamar en la parte libre del lazo (fuera del bloque de tick): el print por
 * UART bloquea unos ms y no debe contarse como tiempo del estado. */
void tickDebugReporte(void)
{
    char buf[160];

    if (!pendiente) {
        return;
    }
    tdEstado_t s = snap;
    pendiente = FALSE;

    int32_t perdidos = (int32_t)(s.tReal / MEF_TICK_MS) - (int32_t)s.ticks;
    const char *nom  = (s.estado >= 0 && s.estado < TD_N_ESTADOS)
                       ? nombres[s.estado] : "?";

    snprintf(buf, sizeof(buf),
             "[TD] %-14s ticks=%lu real=%lu ms (ideal %lu) perdidos~%ld "
             "maxBloque=%lu ms maxPant=%lu ms largos=%lu\r\n",
             nom,
             (unsigned long)s.ticks,
             (unsigned long)s.tReal,
             (unsigned long)(s.ticks * MEF_TICK_MS),
             (long)perdidos,
             (unsigned long)s.maxBloque,
             (unsigned long)s.maxPant,
             (unsigned long)s.largos);
    uartWriteString(UART_USB, buf);

    cur.tEntrada = tickRead();                 /* no contar el tiempo del print */
}

#endif /* TICK_DEBUG */