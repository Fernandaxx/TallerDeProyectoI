#include "modules/rfid.h"
 
static bool_t presente = FALSE;
static bool_t nuevo    = FALSE;
static uint8_t fallos   = 0;
static rfidUid_t uidActual;
 
static bool_t uidIgual(const rfidUid_t *a, const rfidUid_t *b)
{
    return (a->size == b->size) && (memcmp(a->bytes, b->bytes, a->size) == 0);
}

void rfidInit(void)
{
    rc522_init();
    presente = FALSE;
    nuevo = FALSE;
    fallos = 0;
}

void tareaRFID(void)
{
    rfidUid_t uid;
    rc522Uid_t u;

    if (rc522_read_uid(&u) == RC522_OK && u.size > 0 && u.size <= sizeof(uid.bytes)) {
        memset(&uid, 0, sizeof(uid));
        uid.size = u.size;
        memcpy(uid.bytes, u.bytes, u.size);
        fallos = 0;
 
        if (!presente) { // hay disco
            presente  = TRUE;
            uidActual = uid;
            nuevo     = TRUE;
        } else if (!uidIgual(&uid, &uidActual)) { // cambió el disco
            uidActual = uid;
            nuevo     = TRUE;
        }
    } else if (presente) { // si no lee nada pero presente estaba en true
        if (++fallos >= RFID_FALLOS_RETIRO) {
            presente = FALSE;
            nuevo    = FALSE;
            fallos   = 0;
        }
    }
}
 

bool_t rfidHayDisco(void)
{
    return presente;
}
 
bool_t rfidCambioDisco(void)
{
    if (nuevo && presente) {
        nuevo = FALSE;
        return TRUE;
    }
    return FALSE;
}
 
void rfidObtenerUID(rfidUid_t *uid)
{
    *uid = uidActual;
}