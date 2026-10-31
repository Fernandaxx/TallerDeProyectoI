#include "modules/eeprom.h"

#define EE_ADDR      0x50
#define EE_PAGINA    64

#define FORZAR_CARGA 0 // Borra la tabla y la vuelve a cargar

static const tag_t tabla[] = {
    { .uid = {0x04,0x7E,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 1, .r = 255, .g = 160, .b =  20, .artista = "Olivia Rodrigo", .cancion = "stupid song" },
    { .uid = {0x04,0x86,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 2, .r =  40, .g = 120, .b = 255, .artista = "Olivia Rodrigo", .cancion = "u + me = <3" },
    { .uid = {0x04,0x7D,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 3, .r =  60, .g = 200, .b =  80, .artista = "Olivia Rodrigo", .cancion = "purple" },
    { .uid = {0x04,0x81,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 4, .r = 255, .g =  60, .b =  60, .artista = "Olivia Rodrigo", .cancion = "good 4 u" },
    { .uid = {0x04,0x7F,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 5, .r = 128, .g =  60, .b = 180, .artista = "Olivia Rodrigo", .cancion = "vampire" },
};
#define N_INICIAL (sizeof(tabla) / sizeof(tabla[0]))

static uint16_t dirTag(uint16_t i){
    return i * sizeof(tag_t);
}

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

// Deja los MAX_TAGS registros en 0xFF (vacios)
static void eepromBorrarTabla(void){
    uint8_t vacio[sizeof(tag_t)];
    memset(vacio , 0xFF , sizeof(vacio));

    for (uint16_t i = 0; i < MAX_TAGS; i++){
        eepromEscribir(dirTag(i) , vacio , sizeof(vacio));
    }
}

void eepromCargarInicial(void){
    uint8_t primero = 0xFF;

    eepromLeer(dirTag(0) , &primero , 1);
    if (!FORZAR_CARGA && primero != 0xFF) return;   // ya cargada

    if (FORZAR_CARGA) eepromBorrarTabla();          // saca restos del formato anterior

    for (uint16_t i = 0; i < N_INICIAL && i < MAX_TAGS; i++){
        eepromEscribir(dirTag(i) , (const uint8_t *) &tabla[i] , sizeof(tag_t));
    }
}

// Devuelve el indice o -1. Corta en el primer registro vacio.
int16_t eepromBuscarTag(const uint8_t *uid , uint8_t size , tag_t *t){
    uint8_t uidPad[UID_LEN] = {0};
    uint8_t uidLeido[UID_LEN];

    if (size > UID_LEN) return -1;
    memcpy(uidPad , uid , size);        // un UID de 4 bytes queda rellenado con ceros

    for (uint16_t i = 0; i < MAX_TAGS; i++){
        if (!eepromLeer(dirTag(i) , uidLeido , UID_LEN)) return -1;
        if (uidLeido[0] == 0xFF) return -1;                      // fin de la tabla

        if (memcmp(uidLeido , uidPad , UID_LEN) == 0){
            if (!eepromLeer(dirTag(i) , (uint8_t *) t , sizeof(tag_t))) return -1;
            t->artista[ARTISTA_LEN - 1] = '\0';
            t->cancion[CANCION_LEN - 1] = '\0';
            return i;
        }
    }
    return -1;
}