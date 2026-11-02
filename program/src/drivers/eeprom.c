#include "drivers/eeprom.h"

#define EE_ADDR      0x50
#define EE_PAGINA    64

bool_t eepromLeer(uint16_t dir , uint8_t *dst , uint16_t n){
    uint8_t a[2] = { dir >> 8 , dir & 0xFF };
    return i2cRead(I2C0 , EE_ADDR , a , 2 , FALSE , dst , n , TRUE);
}

// Parte la escritura en los limites de pagina (64 bytes)
bool_t eepromEscribir(uint16_t dir , const uint8_t *src , uint16_t n){
    uint8_t buf[2 + EE_PAGINA];

    while (n > 0){
        uint16_t chunk = EE_PAGINA - (dir % EE_PAGINA);
        if (chunk > n) chunk = n;

        buf[0] = dir >> 8;
        buf[1] = dir & 0xFF;
        memcpy(&buf[2] , src , chunk);

        if (!i2cWrite(I2C0 , EE_ADDR , buf , 2 + chunk , TRUE)) return FALSE;
        delay(6);                       // tiempo de escritura interno (max 5 ms)

        dir += chunk;
        src += chunk;
        n   -= chunk;
    }
    return TRUE;
}