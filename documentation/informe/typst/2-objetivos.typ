= Objetivo

== Objetivo general

Desarrollar un prototipo funcional de reproductor de música interactivo que, mediante la lectura de etiquetas RFID/NFC, reproduzca pistas de audio almacenadas localmente, controlado íntegramente por la placa EDU-CIAA-NXP. De forma complementaria, y sujeto a la disponibilidad de tiempo, el prototipo incorpora un mecanismo giratorio a modo de tocadiscos y un modo de asignación de canciones con almacenamiento persistente.


== Objetivos primarios

- Identificar cada disco mediante una etiqueta RFID/NFC.

- Asociar cada disco identificado con una canción o conjunto de canciones.

- Reproducir archivos de audio almacenados localmente.

- Mostrar en una pantalla información básica sobre el estado del sistema y la reproducción.

- Integrar los distintos módulos y periféricos bajo el control de la EDU-CIAA-NXP.

- Diseñar una placa de conexión que permita integrar los componentes del sistema de forma ordenada y segura.

== Objetivos secundarios

- Incorporar un mecanismo que permita hacer girar el disco durante la reproducción, simulando el funcionamiento visual de un tocadiscos.

- Asignación configurable y persistente de canciones: incorporar un modo de configuración que permita asociar una etiqueta RFID/NFC a una canción sin modificar el código del programa, guardando dicha asociación en una memoria EEPROM externa para que persista tras el reinicio del sistema.

- Incorporar controles físicos para funciones básicas de reproducción, como pausa, cambio de pista o ajuste de volumen.

== Descripción técnico-conceptual

El sistema se organiza en torno a la placa EDU-CIAA-NXP, que funciona como unidad central de control y coordina los distintos módulos del proyecto. El lector RFID/NFC MFRC522 se comunica mediante SPI, la pantalla OLED mediante I²C y el módulo de reproducción DFPlayer Mini mediante UART. El procesamiento del audio es realizado por el propio DFPlayer Mini, mientras que la EDU-CIAA se encarga de controlar el funcionamiento general del sistema. En la @fig-bloques se presenta el diagrama en bloques del sistema a desarrollar.

El funcionamiento comienza cuando el usuario coloca un disco sobre el reproductor. El lector RFID/NFC obtiene el identificador de la etiqueta incorporada al disco y la EDU-CIAA busca la canción o lista de canciones asociada. A continuación, envía al DFPlayer Mini la orden de reproducción del archivo almacenado en la tarjeta microSD. La señal de audio se dirige al amplificador PAM8403 y posteriormente al parlante, mientras que la pantalla OLED muestra información sobre el estado de la reproducción.

Como objetivos secundarios, se contempla incorporar un motor paso a paso 28BYJ-48 con su controlador ULN2003 para hacer girar el disco mientras se reproduce la música. También se prevé una memoria EEPROM externa para almacenar las asociaciones entre las etiquetas RFID/NFC y las canciones, permitiendo conservarlas aun después de apagar o reiniciar el sistema. La EEPROM compartiría el bus I²C con la pantalla OLED.

#figure(
  image("../images/DiagramaBloques.png", width: 95%),
  caption: [Diagrama en bloques del sistema.],
  kind: image,
) <fig-bloques>

=== Alimentación del sistema

La alimentación del sistema partirá de una fuente de 5 V. Los módulos de audio y, en caso de implementarse, el motor utilizarán el dominio de 5 V, mientras que los dispositivos que trabajan con lógica de 3,3 V utilizarán el correspondiente nivel de alimentación.

La EDU-CIAA-NXP dispone de líneas de 5 V y 3,3 V en sus conectores de expansión. Todos los módulos compartirán una referencia de masa común (GND). En la @fig-alimentacion se presenta el esquema general de alimentación previsto para el sistema.

#figure(
  image("../images/DiagramaBloques2.png", width: 90%),
  caption: [Esquema general de alimentación del sistema.],
  kind: image,
) <fig-alimentacion>