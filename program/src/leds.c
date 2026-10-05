#include "main.h"
#include "sapi.h"
#include "chip.h"
#include <stdint.h>

/* Cantidad de LEDs */
#define NUM_LEDS 22

/* GPIO utilizado */
#define NEOPIXEL_PIN GPIO2

/* Puerto y pin GPIO internos correspondientes a GPIO2.
 * GPIO2 de la EDU-CIAA corresponde al GPIO5[1].
 */
#define NEOPIXEL_GPIO_PORT 5
#define NEOPIXEL_GPIO_PIN  1

/* ---------------------------------------------------------
 * Funciones
 * --------------------------------------------------------- */

static void enviar_bit(uint8_t bit);
static void enviar_led(uint8_t verde, uint8_t rojo, uint8_t azul);
static void reset_neopixel(void);


/* ---------------------------------------------------------
 * MAIN
 * --------------------------------------------------------- */

int main3(void)
{
    boardConfig();

    /* Configuramos GPIO2 como salida */
    gpioInit(NEOPIXEL_PIN, GPIO_OUTPUT);

    /* Comenzamos con la salida en LOW */
    Chip_GPIO_SetPinState(
        LPC_GPIO_PORT,
        NEOPIXEL_GPIO_PORT,
        NEOPIXEL_GPIO_PIN,
        false
    );

    uint8_t desplazamiento = 0;

    while (TRUE)
    {
        /*
         * Enviamos los 22 LEDs.
         *
         * El desplazamiento hace que el degradado
         * se vaya moviendo por toda la tira.
         */
        for (uint8_t i = 0; i < NUM_LEDS; i++)
        {
            uint8_t posicion =
                (i + desplazamiento) % NUM_LEDS;

            uint8_t rojo;
            uint8_t verde;
            uint8_t azul;

            /*
             * Degradado:
             *
             * 0 - 7   : rojo -> amarillo
             * 8 - 15  : amarillo -> verde
             * 16 - 21 : verde -> azul
             */

            if (posicion < 8)
            {
                rojo = 255;
                verde = posicion * 32;
                azul = 0;
            }
            else if (posicion < 16)
            {
                rojo = 255 - (posicion - 8) * 32;
                verde = 255;
                azul = 0;
            }
            else
            {
                rojo = 0;
                verde = 255 - (posicion - 16) * 32;
                azul = (posicion - 16) * 32;
            }

            /*
             * WS2812B recibe los colores en orden:
             * GREEN - RED - BLUE
             */
            enviar_led(verde, rojo, azul);
        }

        /*
         * Más de 50 us en LOW indica al WS2812B
         * que debe actualizar los LEDs.
         */
        reset_neopixel();

        desplazamiento++;

        if (desplazamiento >= NUM_LEDS)
        {
            desplazamiento = 0;
        }

        /*
         * Velocidad del movimiento.
         */
        delay(20);
    }
}


/* ---------------------------------------------------------
 * enviar_bit()
 *
 * WS2812B:
 *
 * Bit 1:
 * HIGH ~0,8 us
 * LOW  ~0,45 us
 *
 * Bit 0:
 * HIGH ~0,4 us
 * LOW  ~0,85 us
 *
 * El LPC4337 funciona mucho más rápido que el Mega,
 * por eso necesitamos generar estos tiempos mediante
 * instrucciones NOP.
 * --------------------------------------------------------- */

static void enviar_bit(uint8_t bit)
{
    if (bit)
    {
        /* HIGH */
        Chip_GPIO_SetPinState(
            LPC_GPIO_PORT,
            NEOPIXEL_GPIO_PORT,
            NEOPIXEL_GPIO_PIN,
            true
        );

        /*
         * Ajuste temporal.
         */
        __asm volatile (
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
        );

        /* LOW */
        Chip_GPIO_SetPinState(
            LPC_GPIO_PORT,
            NEOPIXEL_GPIO_PORT,
            NEOPIXEL_GPIO_PIN,
            false
        );

        __asm volatile (
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
        );
    }
    else
    {
        /* HIGH */
        Chip_GPIO_SetPinState(
            LPC_GPIO_PORT,
            NEOPIXEL_GPIO_PORT,
            NEOPIXEL_GPIO_PIN,
            true
        );

        /*
         * HIGH corto.
         */
        __asm volatile (
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
        );

        /* LOW */
        Chip_GPIO_SetPinState(
            LPC_GPIO_PORT,
            NEOPIXEL_GPIO_PORT,
            NEOPIXEL_GPIO_PIN,
            false
        );

        /*
         * LOW largo.
         */
        __asm volatile (
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
            "nop\n"
        );
    }
}


/* ---------------------------------------------------------
 * enviar_led()
 *
 * Cada WS2812B recibe 24 bits:
 *
 * GGGGGGGG RRRRRRRR BBBBBBBB
 * --------------------------------------------------------- */

static void enviar_led(uint8_t verde,
                       uint8_t rojo,
                       uint8_t azul)
{
    uint8_t i;

    /* VERDE */
    for (i = 0; i < 8; i++)
    {
        enviar_bit(
            (verde >> (7 - i)) & 1
        );
    }

    /* ROJO */
    for (i = 0; i < 8; i++)
    {
        enviar_bit(
            (rojo >> (7 - i)) & 1
        );
    }

    /* AZUL */
    for (i = 0; i < 8; i++)
    {
        enviar_bit(
            (azul >> (7 - i)) & 1
        );
    }
}


/* ---------------------------------------------------------
 * reset_neopixel()
 *
 * El WS2812B necesita aproximadamente 50 us en LOW
 * para tomar los datos recibidos y actualizar los LEDs.
 * --------------------------------------------------------- */

static void reset_neopixel(void)
{
    Chip_GPIO_SetPinState(
        LPC_GPIO_PORT,
        NEOPIXEL_GPIO_PORT,
        NEOPIXEL_GPIO_PIN,
        false
    );

    delayInaccurateUs(60);
}