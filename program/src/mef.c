#include "mef.h"
#include "modules/display.h"
#include "leds.h"

#define MS_A_TICKS(ms)          ((ms) / MEF_TICK_MS)

state_t state;
static uint16_t ticksEnEstado;


int mefEstado(void)
{
    return (int)state;
}

void mefInit(void)
{
    cambiarEstado(MEF_INICIO);
}

void cambiarEstado(state_t estado)
{
    state = estado;
    ticksEnEstado = 0;

    switch (estado) {

    case MEF_INICIO:
        uiMostrar(UI_INICIO);
        break;

    case MEF_ESPERA:
        uiMostrar(UI_ESPERA);
        break;

    case MEF_IDENTIFICANDO:
        break;

    case MEF_REPRODUCIENDO:
        uiMostrar(UI_REPRODUCIENDO);
        break;

    case MEF_FIN_PISTA:
        uiMostrar(UI_FIN_PISTA);
        break;

    case MEF_NO_REGISTRADO:
        uiMostrar(UI_NO_REGISTRADO);
        break;

    case MEF_CONFIGURACION:
        uiMostrar(UI_CONFIG);
        break;

    case MEF_ERROR:
        uiMostrar(UI_ERROR);
        break;
    }
}

void mefActualizar(void)
{
    if (ticksEnEstado < 0xFFFF) {
        ticksEnEstado++;
    }

    switch (state) {
        case MEF_INICIO:
        motorApagar();
        neopixel_show_all(0, 0, 0);
        if (ticksEnEstado>=250) cambiarEstado(MEF_ESPERA);
            break;

        case MEF_ESPERA:
        motorApagar();
        neopixel_show_all(0, 0, 0);
        if (rfidCambioDisco()) cambiarEstado(MEF_REPRODUCIENDO);
            break;

        case MEF_IDENTIFICANDO:
        motorApagar();
        neopixel_show_all(0, 0, 0);
            break;

        case MEF_REPRODUCIENDO:
        if (!rfidHayDisco()) cambiarEstado(MEF_ESPERA);
        if (ticksEnEstado>=250) cambiarEstado(MEF_FIN_PISTA);
        motorEncender(MOTOR_CW);
        neopixel_show_all(10, 0, 0);
            break;

        case MEF_FIN_PISTA:
        motorApagar();
        neopixel_show_all(0, 0, 0);
        if (rfidCambioDisco()) cambiarEstado(MEF_REPRODUCIENDO);
        if (ticksEnEstado>=250) cambiarEstado(MEF_ESPERA);
            break;

        case MEF_NO_REGISTRADO:
        motorApagar();
        neopixel_show_all(0, 0, 0);
            break;

        case MEF_CONFIGURACION:
        motorApagar();
        neopixel_show_all(0, 0, 0);
            break;

        case MEF_ERROR:
        motorApagar();
        neopixel_show_all(0, 0, 0);
        if (ticksEnEstado>=250) cambiarEstado(MEF_INICIO);
            break;
        }
}