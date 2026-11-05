#include "modules/biblioteca.h"
#include "drivers/eeprom.h"

#define FORZAR_CARGA 0 // Borra la tabla y la vuelve a cargar

static const tag_t tabla[] = {
    { .uid = {0x04,0x7E,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 1, .r = 255, .g = 160, .b =  20, .artista = "Olivia Rodrigo", .cancion = "stupid song" },
    { .uid = {0x04,0x86,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 2, .r =  40, .g = 120, .b = 255, .artista = "Olivia Rodrigo", .cancion = "u + me = <3" },
    { .uid = {0x04,0x7D,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 3, .r =  60, .g = 200, .b =  80, .artista = "Olivia Rodrigo", .cancion = "purple" },
    { .uid = {0x04,0x81,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 4, .r = 255, .g =  60, .b =  60, .artista = "Olivia Rodrigo", .cancion = "good 4 u" },
    { .uid = {0x04,0x7F,0xA3,0x7C,0xC3,0x2A,0x81}, .pista = 5, .r = 128, .g =  60, .b = 180, .artista = "Olivia Rodrigo", .cancion = "vampire" },
};
#define N_INICIAL (sizeof(tabla) / sizeof(tabla[0]))

static uint16_t dirTag(uint16_t i) {
    return i * sizeof(tag_t);
}

static void bibliotecaBorrar(void){ // Deja los MAX_TAGS registros en 0xFF (vacios)
    uint8_t vacio[sizeof(tag_t)];
    memset(vacio , 0xFF , sizeof(vacio));

    for (uint16_t i = 0; i < MAX_TAGS; i++){
        eepromEscribir(dirTag(i) , vacio , sizeof(vacio));
    }
}

static void bibliotecaInit(void){
    uint8_t primero = 0xFF;

    eepromLeer(dirTag(0) , &primero , 1);
    if (!FORZAR_CARGA && primero != 0xFF) return;   // ya cargada

    if (FORZAR_CARGA) bibliotecaBorrar();          // saca restos del formato anterior

    for (uint16_t i = 0; i < N_INICIAL && i < MAX_TAGS; i++){
        eepromEscribir(dirTag(i) , (const uint8_t *) &tabla[i] , sizeof(tag_t));
    }
}

// Devuelve el indice o -1. Corta en el primer registro vacio.
static int16_t bibliotecaBuscar(const uint8_t *uid , uint8_t size , tag_t *disco){
    uint8_t uidPad[UID_LEN] = {0};
    uint8_t uidLeido[UID_LEN];

    if (size > UID_LEN) return -1;
    memcpy(uidPad , uid , size);        // un UID de 4 bytes queda rellenado con ceros

    for (uint16_t i = 0; i < MAX_TAGS; i++){
        if (!eepromLeer(dirTag(i) , uidLeido , UID_LEN)) return -1;
        if (uidLeido[0] == 0xFF) return -1;                      // fin de la tabla

        if (memcmp(uidLeido , uidPad , UID_LEN) == 0){
            if (!eepromLeer(dirTag(i) , (uint8_t *) disco , sizeof(tag_t))) return -1;
            disco->artista[ARTISTA_LEN - 1] = '\0';
            disco->cancion[CANCION_LEN - 1] = '\0';
            return i;
        }
    }
    return -1;
}
