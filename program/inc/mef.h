#ifndef MEF_H_
#define MEF_H_

#include "main.h"

#include "modules/display.h"
#include "modules/motor.h"
#include "modules/rfid.h"

#define MEF_TICK_MS 20 // 20 ms 

typedef enum {
    MEF_INICIO,
    MEF_ESPERA,
    MEF_IDENTIFICANDO,
    MEF_REPRODUCIENDO,
    MEF_FIN_PISTA,
    MEF_NO_REGISTRADO,
    MEF_CONFIGURACION,
    MEF_ERROR
} state_t;

int mefEstado(void);
void mefInit(void);
void cambiarEstado(state_t estado);
void mefActualizar();

#endif