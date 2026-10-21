#ifndef RC522_H
#define RC522_H

#include "main.h"

#define RC522_SPI     SPI0
#define RC522_CS_PIN  GPIO0
#define RC522_RST_PIN GPIO1

/* ---- Registros ---- */
#define CommandReg      0x01
#define ComIrqReg       0x04
#define DivIrqReg       0x05
#define ErrorReg        0x06
#define FIFODataReg     0x09
#define FIFOLevelReg    0x0A
#define ControlReg      0x0C
#define BitFramingReg   0x0D
#define CollReg         0x0E
#define ModeReg         0x11
#define TxControlReg    0x14
#define TxASKReg        0x15
#define CRCResultRegH   0x21
#define CRCResultRegL   0x22
#define RFCfgReg        0x26
#define TModeReg        0x2A
#define TPrescalerReg   0x2B
#define TReloadRegH     0x2C
#define TReloadRegL     0x2D
#define VersionReg      0x37

/* ---- Comandos ---- */
#define RC522_CMD_IDLE        0x00
#define RC522_CMD_CALCCRC     0x03
#define RC522_CMD_TRANSCEIVE  0x0C
#define RC522_CMD_SOFTRESET   0x0F

/* ---- Comandos ISO14443A ---- */
#define PICC_WUPA       0x52
#define PICC_HLTA       0x50
#define PICC_SEL_CL1    0x93
#define PICC_SEL_CL2    0x95
#define PICC_SEL_CL3    0x97

typedef enum {
   RC522_OK,
   RC522_NOTAG,
   RC522_COLLISION,
   RC522_ERROR
} rc522Status_t;

typedef struct {
   uint8_t size;     // 4 o 7
   uint8_t bytes[7];
   uint8_t sak;
} rc522Uid_t;

void rc522_init(void);
uint8_t rc522_version(void);          /* 0x91/0x92 = OK */
rc522Status_t rc522_read_uid(rc522Uid_t *uid);

#endif