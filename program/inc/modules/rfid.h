#ifndef RFID_H
#define RFID_H

#include "main.h"
#include "drivers/rc522.h"

typedef struct {
    uint8_t size; // 4 o 7
    uint8_t bytes[7];
} rfidUid_t;

#define RFID_FALLOS_RETIRO   3 // ~0,6s
 
void   rfidInit(void);
void   tareaRFID(void);

bool_t rfidHayDisco(void);             
bool_t rfidCambioDisco(void);
void   rfidObtenerUID(rfidUid_t *uid);

#endif


 