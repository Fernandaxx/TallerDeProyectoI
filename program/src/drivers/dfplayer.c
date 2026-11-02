#include "drivers/dfplayer.h"

static void mp3EnviarComando(uint8_t comando , uint16_t parametro){
    uint8_t trama[10];

    uint8_t paramH = (parametro >> 8) & 0xFF;
    uint8_t paramL = parametro & 0xFF;

    uint16_t suma = 0xFF + 0x06 + comando
        + 0x00 + paramH + paramL;

    uint16_t checksum = (uint16_t) (0 - suma);

    trama[0] = 0x7E;
    trama[1] = 0xFF;
    trama[2] = 0x06;
    trama[3] = comando;
    trama[4] = 0x00;       // Sin respuesta solicitada
    trama[5] = paramH;
    trama[6] = paramL;
    trama[7] = (checksum >> 8) & 0xFF;
    trama[8] = checksum & 0xFF;
    trama[9] = 0xEF;

    uartWriteByteArray(MP3_UART , trama , 10);
    delay(100);
}

void mp3Init(void){
    // Esperar a que el modulo inicialice la microSD
    delay(1500);

    mp3Volumen(20);

    mp3EnviarComando(0x19 , 1);   // sin repeticion de pista
    mp3EnviarComando(0x11 , 0);   // sin repeticion global
}

void mp3Reproducir(uint16_t pista){
    //mp3EnviarComando(0x03 , pista);
    mp3EnviarComando(0x0F , ((uint16_t) 1 << 8) | pista);
}

void mp3Detener(void){
    mp3EnviarComando(0x16 , 0);
}

/*void mp3Siguiente(void){
    mp3EnviarComando(0x01 , 0);
}

void mp3Anterior(void){
    mp3EnviarComando(0x02 , 0);
}*/

void mp3Pausar(void){
    mp3EnviarComando(0x0E , 0);
}

void mp3Continuar(void){
    mp3EnviarComando(0x0D , 0);
}

void mp3Volumen(uint8_t volumen){
    if (volumen > 30) volumen = 30;

    mp3EnviarComando(0x06 , volumen);
}
