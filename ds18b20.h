/*
  CodeVisionAVR C Compiler
  (C) 1998-2009 Pavel Haiduc, HP InfoTech S.R.L.

  Prototypes for Dallas Semiconductor
  DS18B20 1 Wire bus temperature sensor
  functions

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE 1 WIRE BUS IS CONNECTED AND
  THE DATA BIT USED

  EXAMPLE FOR PORTB:

    #asm
        .equ __w1_port=0x18
        .equ __w1_bit=3
    #endasm
    #include <ds18b20.h>
*/

#ifndef _DS18B20_INCLUDED_
#define _DS18B20_INCLUDED_

#include <1wire.h>

#define DS18B20_9BIT_RES 0  // 9 bit thermometer resolution
#define DS18B20_10BIT_RES 1 // 10 bit thermometer resolution
#define DS18B20_11BIT_RES 2 // 11 bit thermometer resolution
#define DS18B20_12BIT_RES 3 // 12 bit thermometer resolution

#define DS18B20_FAMILY_CODE 0x28
#define DS18B20_SEARCH_ROM_CMD 0xf0
#define DS18B20_ALARM_SEARCH_CMD 0xec

#pragma used+
extern struct __ds18b20_scratch_pad_struct
       {
       unsigned char temp_lsb,temp_msb;
       signed char   temp_high,temp_low;
       unsigned char conf_register,
                     res1,
                     res2,
                     res3,
                     crc;
       } __ds18b20_scratch_pad;

unsigned char ds18b20_select(unsigned char *addr);
unsigned char ds18b20_read_spd(unsigned char *addr);
float ds18b20_temperature(unsigned char *addr);
int ds18b20_request_temperature(unsigned char *addr);
float ds18b20_get_temperature(unsigned char *addr);
unsigned char ds18b20_init(unsigned char *addr,signed char temp_low,signed char temp_high,
unsigned char resolution);
#pragma used-

#pragma library ds18b20.lib

#endif

