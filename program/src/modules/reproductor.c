#include "modules/reproductor.h"
#include "drivers/dfplayer.h"

static uint8_t pausado = 0;

void reproductorInit(void){
    mp3Init();
    mp3Reproducir(1);
    pausado = 0;
}

void reproductorPista1(void){
    mp3Reproducir(1);
    pausado = 0;
}

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
}
