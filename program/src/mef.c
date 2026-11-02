#include "mef.h"
#include "modules/display.h"
#include "modules/reproductor.h"
#include "modules/efectos.h"
#include "modules/biblioteca.h"
#include "modules/rfid.h"

#define MS_A_TICKS(ms)          ((ms) / MEF_TICK_MS)

state_t state;
static uint16_t ticksEnEstado;

static tag_t tagActual;

static bool_t identificarDisco(void)
{
    rfidUid_t uid;
    rfidObtenerUID(&uid);
    return bibliotecaBuscar(uid.bytes, uid.size, &tagActual) >= 0;
}

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
        displayInit();
        uiMostrar(UI_INICIO);

        reproductorInit();
        rfidInit();
        efectosInit();

        reproductorDetener();
        efectosApagar();
        break;

    case MEF_ESPERA:
        uiMostrar(UI_ESPERA);
        reproductorDetener();
        efectosApagar();
        break;

    case MEF_IDENTIFICANDO:
        reproductorPista(tagActual.pista);
        efectosApagar();
        break;

    case MEF_REPRODUCIENDO:
        uiActualizarTextos(tagActual.artista, tagActual.cancion);
        uiMostrar(UI_REPRODUCIENDO);
        efectosEncender(tagActual.r >> 4, tagActual.g >> 4, tagActual.b >> 4);
        break;

    case MEF_FIN_PISTA:
        uiMostrar(UI_FIN_PISTA);
        reproductorDetener();
        efectosApagar();
        break;

    case MEF_NO_REGISTRADO:
        uiMostrar(UI_NO_REGISTRADO);
        reproductorDetener();
        efectosApagar();
        break;

    case MEF_CONFIGURACION:
        uiMostrar(UI_CONFIG);
        reproductorDetener();
        efectosApagar();
        break;

    case MEF_ERROR:
        uiMostrar(UI_ERROR);
        reproductorDetener();
        efectosApagar();
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
            if (ticksEnEstado>=250) cambiarEstado(MEF_ESPERA);
            break;

        case MEF_ESPERA:
            if (rfidCambioDisco()) cambiarEstado(MEF_IDENTIFICANDO);
            break;

        case MEF_IDENTIFICANDO:
            if (identificarDisco()){
                if (ticksEnEstado>=25) cambiarEstado(MEF_REPRODUCIENDO); // da 50ms para que el reproductor ponga BUSY en bajo
            } else {
                cambiarEstado(MEF_NO_REGISTRADO);
            }
            break;

        case MEF_REPRODUCIENDO:
            if (!rfidHayDisco()) cambiarEstado(MEF_ESPERA);
            else if (reproductorFinPista()) cambiarEstado(MEF_FIN_PISTA);
            break;

        case MEF_FIN_PISTA:
            if (rfidCambioDisco()) cambiarEstado(identificarDisco() ? MEF_IDENTIFICANDO : MEF_NO_REGISTRADO);
            else if (ticksEnEstado>=250) cambiarEstado(MEF_ESPERA);
            break;

        case MEF_NO_REGISTRADO:
            if (!rfidHayDisco()) cambiarEstado(MEF_ESPERA);
            else if (rfidCambioDisco()) cambiarEstado(identificarDisco() ? MEF_IDENTIFICANDO : MEF_NO_REGISTRADO);
            break;

        case MEF_CONFIGURACION:
            break;

        case MEF_ERROR:
            if (ticksEnEstado>=250) cambiarEstado(MEF_INICIO);
            break;
        }
}