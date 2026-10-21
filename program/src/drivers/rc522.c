#include "drivers/rc522.h"

/* ================= Capa de hardware ================= */

static void cs(bool_t high)  { gpioWrite(RC522_CS_PIN,  high ? ON : OFF); } // cambia el estado de RFID_SDA
static void rst(bool_t high) { gpioWrite(RC522_RST_PIN, high ? ON : OFF); } // cambia el estado de RFID_RST

static void write_reg(uint8_t reg, uint8_t val)
{
   uint8_t buf[2];
   buf[0] = (reg << 1) & 0x7E;
   buf[1] = val;
   cs(0);
   spiWrite(RC522_SPI, buf, 2);
   cs(1);
}

static uint8_t read_reg(uint8_t reg)
{
   uint8_t addr = ((reg << 1) & 0x7E) | 0x80;
   uint8_t val = 0;
   cs(0);
   spiWrite(RC522_SPI, &addr, 1);
   spiRead(RC522_SPI, &val, 1);
   cs(1);
   return val;
}

static void set_bits(uint8_t reg, uint8_t mask)   { write_reg(reg, read_reg(reg) | mask); }
static void clear_bits(uint8_t reg, uint8_t mask) { write_reg(reg, read_reg(reg) & ~mask); }

/* ================= Logica del RC522 ================= */

void rc522_init(void)
{
   gpioConfig(RC522_CS_PIN,  GPIO_OUTPUT);
   gpioConfig(RC522_RST_PIN, GPIO_OUTPUT);
   cs(1);

   // hardware reset
   rst(0);
   delay(10);
   rst(1);
   delay(50);

   // software reset
   write_reg(CommandReg, RC522_CMD_SOFTRESET);
   delay(50);

   // Timer: TAuto, f = 6.78MHz/(2*169+1) = 20kHz, reload 400 -> ~10 ms
   write_reg(TModeReg,      0x80);
   write_reg(TPrescalerReg, 0xA9);
   write_reg(TReloadRegH,   0x01);
   write_reg(TReloadRegL,   0x90);

   write_reg(TxASKReg, 0x40);   // modulacion ASK 100%
   write_reg(ModeReg,  0x3D);   // CRC preset 0x6363  
   write_reg(RFCfgReg, 0x70);   // ganancia maxima (48 dB)

   // antena = ON
   if ((read_reg(TxControlReg) & 0x03) != 0x03) {
      set_bits(TxControlReg, 0x03);
   }
}

uint8_t rc522_version(void)
{
   return read_reg(VersionReg);
}

static rc522Status_t calc_crc(const uint8_t *data, uint8_t len, uint8_t *crc)
{
   uint8_t i, t = 90;

   write_reg(CommandReg, RC522_CMD_IDLE);
   write_reg(DivIrqReg, 0x04); // limpia CRCIRq
   write_reg(FIFOLevelReg, 0x80); // limpia FIFO
   for (i = 0; i < len; i++) write_reg(FIFODataReg, data[i]);
   write_reg(CommandReg, RC522_CMD_CALCCRC);

   while (t--) {
      if (read_reg(DivIrqReg) & 0x04) {
         write_reg(CommandReg, RC522_CMD_IDLE);
         crc[0] = read_reg(CRCResultRegL);
         crc[1] = read_reg(CRCResultRegH);
         return RC522_OK;
      }
      delay(1);
   }
   return RC522_ERROR;
}

// Envia tx[] a la etiqueta y recibe en rx[]
static rc522Status_t transceive(const uint8_t *tx, uint8_t txLen, uint8_t txBits, uint8_t *rx, uint8_t *rxLen)
{
   uint8_t i, irq = 0, err, n, t = 255;

   write_reg(CommandReg, RC522_CMD_IDLE);
   write_reg(ComIrqReg, 0x7F); // limpia IRQs
   write_reg(FIFOLevelReg, 0x80); // flush FIFO
   for (i = 0; i < txLen; i++) write_reg(FIFODataReg, tx[i]);
   write_reg(BitFramingReg, txBits & 0x07);
   write_reg(CommandReg, RC522_CMD_TRANSCEIVE);
   set_bits(BitFramingReg, 0x80); // StartSend

   while (t--) {
      irq = read_reg(ComIrqReg);
      if (irq & 0x31) break; // RxIRq | IdleIRq | TimerIRq
   }
   clear_bits(BitFramingReg, 0x80);

   if (!(irq & 0x30)) {
      return (irq & 0x01) ? RC522_NOTAG : RC522_ERROR;
   }

   err = read_reg(ErrorReg);
   if (err & 0x08) return RC522_COLLISION;
   if (err & 0x13) return RC522_ERROR; // BufferOvfl, Parity, Protocol

   if (rx) {
      n = read_reg(FIFOLevelReg);
      if (n > *rxLen) return RC522_ERROR;
      *rxLen = n;
      for (i = 0; i < n; i++) rx[i] = read_reg(FIFODataReg);
   }
   return RC522_OK;
}

// WUPA: despierta etiquetas en IDLE o HALT
static rc522Status_t wakeup(void)
{
   uint8_t cmd = PICC_WUPA;
   uint8_t atqa[2];
   uint8_t len = sizeof(atqa);
   rc522Status_t st;

   clear_bits(CollReg, 0x80); // ValuesAfterColl = 0
   st = transceive(&cmd, 1, 7, atqa, &len);
   if (st != RC522_OK) return st;
   return (len == 2) ? RC522_OK : RC522_ERROR;
}

static void halt(void)
{
   uint8_t buf[4] = { PICC_HLTA, 0x00, 0, 0 };
   if (calc_crc(buf, 2, &buf[2]) == RC522_OK) {
      transceive(buf, 4, 0, NULL, NULL); // la etiqueta no responde: es normal
   }
}

rc522Status_t rc522_read_uid(rc522Uid_t *uid)
{
   static const uint8_t sel[3] = { PICC_SEL_CL1, PICC_SEL_CL2, PICC_SEL_CL3 };
   uint8_t level, buf[9], len, bcc, i;
   rc522Status_t st;

   uid->size = 0;
   uid->sak  = 0;

   st = wakeup();
   if (st != RC522_OK) return st;

   for (level = 0; level < 3; level++) {
      // Anticolision: SEL, NVB=0x20 -> 4 bytes UID/CT + BCC
      buf[0] = sel[level];
      buf[1] = 0x20;
      len = 5;
      st = transceive(buf, 2, 0, buf + 2, &len);
      if (st != RC522_OK) return st;
      if (len != 5) return RC522_ERROR;

      bcc = buf[2] ^ buf[3] ^ buf[4] ^ buf[5];
      if (bcc != buf[6]) return RC522_ERROR;

      // SELECT: SEL, NVB=0x70, 4 bytes, BCC, CRC_A
      buf[1] = 0x70;
      if (calc_crc(buf, 7, &buf[7]) != RC522_OK) return RC522_ERROR;
      {
         uint8_t sak[3];
         uint8_t slen = sizeof(sak);
         st = transceive(buf, 9, 0, sak, &slen);
         if (st != RC522_OK) return st;
         if (slen != 3) return RC522_ERROR;
         uid->sak = sak[0];
      }

      if (uid->sak & 0x04) {
         // Cascade bit: buf[2] es 0x88 (cascade tag), UID continua
         for (i = 0; i < 3; i++) uid->bytes[uid->size++] = buf[3 + i];
      } else {
         for (i = 0; i < 4; i++) uid->bytes[uid->size++] = buf[2 + i];
         break;
      }
   }

   halt(); // para poder volver a leerla con WUPA
   return RC522_OK;
}