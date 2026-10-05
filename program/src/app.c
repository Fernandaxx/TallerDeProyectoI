#include "app.h"
#include "sapi.h"

int main( void )
{
   // Inicializar y configurar la plataforma
   boardConfig();

   bool_t buttonValue = OFF;
   bool_t ledValue    = OFF;
   tick_t timeCount   = 0;

   while( true ) {
      delay( 100 );  /* Retardo bloqueante durante 100ms */    
      timeCount++;      
      
      if( timeCount == 100 ){ // 100ms * 100 = 10s
         
         while( TRUE ) {
            
            /* Si se presiona CIAA_BOARD_BUTTON, enciende el CIAA_BOARD_LED */

            // Leer pin conectado al boton.
            buttonValue = !gpioRead( CIAA_BOARD_BUTTON );
            // Invertir el valor leido, pues lee un 0 (OFF) con boton
            // presionado y 1 (ON) al liberarla.
            buttonValue = !buttonValue;
            // Escribir el valor leido en el LED correspondiente.
            gpioWrite( LEDR, buttonValue );

            /* Enviar a la salida estandar (UART_DEBUG) el estado del LED */
            
            // Leer el estado del pin conectado al led
            ledValue = gpioRead( LEDR );
            // Chequear si el valor leido es encedido
            if( ledValue == ON ) {
               // Si esta encendido mostrar por UART_USB "LED encendido."
               printf( "LED encendido.\r\n" );
            } else {
               // Si esta apagado mostrar por UART_USB "LED apagado."
               printf( "LED apagado.\r\n" );
            }
            delay( 250 );
            
         }
      } else {
         // Intercambiar el valor de CIAA_BOARD_LED
         gpioToggle(LEDR);
      }
   }

   return 0;
}
