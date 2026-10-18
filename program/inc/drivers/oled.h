#ifndef _OLED_H_
#define _OLED_H_

#include "main.h"
#include "u8x8.h"
#include "sapi_i2c.h"
#include "u8g2.h"

#define U8X8_I2C_BUFFER_SIZE 32

void oledInit(u8g2_t *u8g2);
uint8_t u8x8_gpio_and_delay_ciaa(u8x8_t *u8x8, uint8_t msg, uint8_t arg_int, void *arg_ptr);
uint8_t u8x8_byte_ciaa_hw_i2c(u8x8_t *u8x8, uint8_t msg, uint8_t arg_int, void *arg_ptr);

#endif