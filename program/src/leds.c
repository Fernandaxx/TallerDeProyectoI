#include "leds.h"

/* Tiempos WS2812B en ciclos del contador DWT (se calculan en neopixel_init).
 * Nominales: T0H = 0.40 us, T1H = 0.80 us, periodo de bit = 1.25 us. */
static uint32_t cyc_t0h, cyc_t1h, cyc_bit, cyc_latch;

/* Registro del GPIO (1 byte) del pin de datos: escribir es UNA instruccion */
static volatile uint8_t *neo_reg;

#define NEO_LINEA_ALTA()  (*neo_reg = 0)   /* GPIO en 0 -> Q1 cortado -> R10 sube la linea a 5 V */
#define NEO_LINEA_BAJA()  (*neo_reg = 1)   /* GPIO en 1 -> Q1 conduce -> linea a 0 V */

static inline void wait_until(uint32_t t0, uint32_t cycles)
{
    while ((DWT->CYCCNT - t0) < cycles) { }
}

/* Averigua a que puerto/bit del LPC4337 corresponde NEO_PIN: lo escribe en
 * OFF y en ON con sAPI y ve que salida configurada cambio. */
static uint8_t ubicar_pin(void)
{
    uint32_t a[8], b[8], diff;
    uint8_t p, k;

    gpioWrite(NEO_PIN, OFF);
    for (p = 0; p < 8; p++) a[p] = LPC_GPIO_PORT->PIN[p];
    gpioWrite(NEO_PIN, ON);
    for (p = 0; p < 8; p++) b[p] = LPC_GPIO_PORT->PIN[p];

    for (p = 0; p < 8; p++) {
        diff = (a[p] ^ b[p]) & LPC_GPIO_PORT->DIR[p];   /* solo salidas */
        for (k = 0; k < 32; k++) {
            if (diff & (1UL << k)) {
                neo_reg = &LPC_GPIO_PORT->B[p][k];
                return 1;
            }
        }
    }
    return 0;
}

uint8_t neopixel_init(void)
{
    uint32_t mhz;

    gpioConfig(NEO_PIN, GPIO_OUTPUT);
    gpioWrite(NEO_PIN, ON);                 /* reposo: linea en 0 V */

    if (!ubicar_pin()) return 0;
    NEO_LINEA_BAJA();

    /* Contador de ciclos del Cortex-M4 */
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CYCCNT = 0;
    DWT->CTRL  |= DWT_CTRL_CYCCNTENA_Msk;

    mhz       = SystemCoreClock / 1000000UL;   /* 204 con la EDU-CIAA */
    cyc_t0h   = (mhz * 400UL)  / 1000UL;
    cyc_t1h   = (mhz * 800UL)  / 1000UL;
    cyc_bit   = (mhz * 1250UL) / 1000UL;
    cyc_latch = mhz * 60UL;                    /* 60 us */
    neopixel_set_color(0,0,0);

    return 1;
}

static inline void send_bit(uint8_t one)
{
    uint32_t t0 = DWT->CYCCNT;

    NEO_LINEA_ALTA();
    wait_until(t0, one ? cyc_t1h : cyc_t0h);
    NEO_LINEA_BAJA();
    wait_until(t0, cyc_bit);
}

static void send_byte(uint8_t byte)
{
    int8_t i;
    for (i = 7; i >= 0; i--) {
        send_bit((byte >> i) & 0x01);
    }
}

/* Un LED (protocolo GRB) */
void neopixel_set_color(uint8_t r, uint8_t g, uint8_t b)
{
    send_byte(g);
    send_byte(r);
    send_byte(b);
}

/* Tira completa con un color uniforme */
void neopixel_show_all(uint8_t r, uint8_t g, uint8_t b)
{
    uint32_t t0;
    uint16_t i;

    __disable_irq();                           /* ~0.7 ms con 22 LEDs */
    for (i = 0; i < NUM_LEDS; i++) {
        neopixel_set_color(r, g, b);
    }
    NEO_LINEA_BAJA();                          /* reposo */
    __enable_irq();

    t0 = DWT->CYCCNT;
    wait_until(t0, cyc_latch);                 /* latch > 50 us */
}