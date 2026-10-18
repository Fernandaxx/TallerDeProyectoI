#include "drivers/oled.h"

void oledInit(u8g2_t *u8g2)
{ 
  u8g2_Setup_sh1106_i2c_128x64_noname_1(
        u8g2,
        U8G2_R0,
        u8x8_byte_ciaa_hw_i2c,
        u8x8_gpio_and_delay_ciaa
    );

    u8g2_InitDisplay(u8g2);
    u8g2_SetPowerSave(u8g2, 0);
}

uint8_t u8x8_gpio_and_delay_ciaa(u8x8_t *u8x8, uint8_t msg, uint8_t arg_int, void *arg_ptr)
{
  switch(msg)
  {
    case U8X8_MSG_GPIO_AND_DELAY_INIT:	// called once during init phase of u8g2/u8x8
      break;							// can be used to setup pins
    case U8X8_MSG_DELAY_NANO:			// delay arg_int * 1 nano second
        delayInaccurateNs(arg_int);  
    break;    
    case U8X8_MSG_DELAY_100NANO:		// delay arg_int * 100 nano seconds
        delayInaccurateNs(100 * arg_int);  
    break;
    case U8X8_MSG_DELAY_10MICRO:		// delay arg_int * 10 micro seconds
        delayInaccurateUs(10 * arg_int);  
    break;
    case U8X8_MSG_DELAY_MILLI:			// delay arg_int * 1 milli second
        delayInaccurateMs(arg_int);  
    break;
    case U8X8_MSG_DELAY_I2C:				// arg_int is the I2C speed in 100KHz, e.g. 4 = 400 KHz
        if (arg_int != 0)
            delayInaccurateNs(5000 / arg_int);  // arg_int=1: delay by 5us, arg_int = 4: delay by 1.25us
            //delayInaccurateUs(5/arg_int);       
    break;

    default:
      u8x8_SetGPIOResult(u8x8, 1);			// default return value
      break;
  }
  return 1;
}

uint8_t u8x8_byte_ciaa_hw_i2c(u8x8_t *u8x8, uint8_t msg, uint8_t arg_int, void *arg_ptr)
{
    static uint8_t buffer[U8X8_I2C_BUFFER_SIZE];
    static uint8_t buf_idx = 0;

    uint8_t *data;

    switch (msg)
    {
        case U8X8_MSG_BYTE_INIT:
            break;

        case U8X8_MSG_BYTE_START_TRANSFER:
            buf_idx = 0;
            break;

        case U8X8_MSG_BYTE_SEND:
            data = (uint8_t *)arg_ptr;

            if ((uint16_t)buf_idx + arg_int > U8X8_I2C_BUFFER_SIZE)
                return 0;

            while (arg_int > 0)
            {
                buffer[buf_idx++] = *data++;
                arg_int--;
            }
            break;

        case U8X8_MSG_BYTE_END_TRANSFER:
        {
            uint8_t address = u8x8_GetI2CAddress(u8x8) >> 1;

            if (buf_idx > 0)
            {
                if (!i2cWrite(
                        I2C0,
                        address,
                        buffer,
                        buf_idx,
                        TRUE))
                {
                    return 0;
                }
            }

            buf_idx = 0;
            break;
        }

        case U8X8_MSG_BYTE_SET_DC:
            // I2C no utiliza un pin DC independiente.
            break;

        default:
            return 0;
    }

    return 1;

}