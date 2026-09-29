= Análisis de requerimientos


== Requerimientos funcionales de hardware

=== Primarios

1. El sistema debe utilizar la placa EDU-CIAA-NXP como unidad central de control.

2. Debe incorporar un lector MFRC522 para identificar etiquetas RFID/NFC mediante comunicación SPI.

3. Debe incorporar un módulo DFPlayer Mini para reproducir archivos de audio almacenados en una tarjeta microSD y comunicarse con la EDU-CIAA mediante UART.

4. Debe incorporar un amplificador PAM8403 y un parlante compatible para la reproducción del audio.

5. Debe incorporar una pantalla OLED comunicada mediante I²C para mostrar información del sistema.

6. El sistema debe contar con una alimentación de 5 V y disponer de los niveles de tensión necesarios para los módulos que trabajen a 3,3 V, manteniendo una masa común.

7. Los módulos externos deben integrarse mediante una placa tipo poncho (PBC) compatible con los conectores de expansión de la EDU-CIAA-NXP.

// TODO: confirmar RF-HW 6 según se decida usar o no la línea TX del DFPlayer (detección de fin de pista).
=== Secundarios

8. Podrá incorporarse un motor paso a paso 28BYJ-48 con controlador ULN2003 para hacer girar el disco durante la reproducción.

9. Podrá incorporarse una memoria EEPROM externa comunicada mediante I²C para almacenar las asociaciones entre etiquetas y canciones.

10. La placa de conexión deberá prever las conexiones necesarias para incorporar los módulos secundarios sin requerir un rediseño completo.


== Requerimientos funcionales de software

=== Primarios

1. El sistema debe detectar una etiqueta RFID/NFC y obtener su identificador único.

2. Cada identificador registrado debe estar asociado a una canción o conjunto de canciones almacenadas en la tarjeta microSD.

3. Al detectar una etiqueta registrada, el sistema debe iniciar la reproducción del contenido asociado.

4. El sistema debe mostrar en la pantalla OLED el estado del sistema y la información de la pista en reproducción.

5. Ante una etiqueta no registrada, el sistema no debe iniciar ninguna reproducción y debe informar dicha condición al usuario.

6. El sistema debe gestionar de forma no bloqueante la lectura del RFID y la actualización de la pantalla, manteniendo la responsividad.


=== Secundarios

7. El sistema podrá controlar el giro del motor de manera coordinada con la reproducción de audio.

8. Podrá incorporarse un modo de configuración que permita asociar una etiqueta RFID/NFC a una canción sin modificar el código del programa.

9. Las asociaciones realizadas podrán almacenarse en una memoria EEPROM para conservarse después de apagar o reiniciar el sistema.

10. Podrán incorporarse controles físicos para funciones básicas como pausa, cambio de pista o ajuste de volumen.


== Requerimientos no funcionales

1. El desarrollo deberá realizarse utilizando la plataforma EDU-CIAA-NXP.

2. El hardware debe diseñarse de forma modular, permitiendo probar los distintos módulos de manera individual antes de realizar la integración completa.

3. La placa tipo poncho no deberá superar las dimensiones generales de la EDU-CIAA-NXP.

4. La alimentación deberá respetar las tensiones de funcionamiento de cada módulo y mantener una masa común entre todos los componentes.

5. Las funciones principales del sistema deberán ser ensayadas y validadas tanto de manera individual como durante la integración final.

6. Los diseños de hardware y software, las modificaciones realizadas y los resultados de los ensayos deberán quedar documentados en los informes del proyecto.

7. El desarrollo deberá ajustarse a las fechas establecidas en el cronograma de la cátedra.
