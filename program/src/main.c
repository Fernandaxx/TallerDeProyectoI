#include "sapi.h"
#include "modules/reproductor.h"

int main(void){
    boardConfig();

    reproductorInit();

    gpioWrite(LEDB , ON);

    while (1){
        if (gpioRead(TEC1) == OFF){
            delay(30);

            if (gpioRead(TEC1) == OFF){
                reproductorPista1();

                while (gpioRead(TEC1) == OFF){
                    delay(10);
                }
            }
        }

        if (gpioRead(TEC2) == OFF){
            delay(30);

            if (gpioRead(TEC2) == OFF){
                reproductorSiguiente();

                while (gpioRead(TEC2) == OFF){
                    delay(10);
                }
            }
        }

        if (gpioRead(TEC3) == OFF){
            delay(30);

            if (gpioRead(TEC3) == OFF){
                reproductorAnterior();

                while (gpioRead(TEC3) == OFF){
                    delay(10);
                }
            }
        }

        if (gpioRead(TEC4) == OFF){
            delay(30);

            if (gpioRead(TEC4) == OFF){
                reproductorPausaContinuar();

                while (gpioRead(TEC4) == OFF){
                    delay(10);
                }
            }
        }

        delay(10);
    }

    return 0;
}
