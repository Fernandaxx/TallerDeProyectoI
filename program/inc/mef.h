#ifndef _MEF_H_
#define _MEF_H_

#include "main.h"

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

extern state_t state;

int mefEstado(void);
void mefInit(void);
void cambiarEstado(state_t estado);
void mefActualizar();

#endif