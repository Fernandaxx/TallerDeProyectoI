#include "modules/reproductor.h"

static uint8_t pausado = 0;
static uint8_t busy = 0;

void reproductorInit(void){
    gpioConfig(BUSY_PIN , GPIO_INPUT_PULLUP);
    mp3Init();
    pausado = 0;
    busy = 0;
}

void reproductorPista(uint8_t pista){
    mp3Reproducir(pista);
    pausado = 0;
    busy = 1;
}

void reproductorDetener(void){
    mp3Detener();
    pausado = 0;
    busy = 0;
}

bool_t reproductorFinPista(void)
{
    if (busy && gpioRead(BUSY_PIN) == 1) {
        busy = FALSE;
        return TRUE;
    }
    return FALSE;
}
/*
void reproductorSiguiente(void){
    mp3Siguiente();
    pausado = 0;
}

void reproductorAnterior(void){
    mp3Anterior();
    pausado = 0;
}

void reproductorPausaContinuar(void){
    if (pausado){
        mp3Continuar();
        pausado = 0;
    }
    else{
        mp3Pausar();
        pausado = 1;
    }
}*/
