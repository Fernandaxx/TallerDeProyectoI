= Objetivo

== Objetivo general

Desarrollar un prototipo funcional de reproductor de música interactivo que, mediante la lectura de etiquetas RFID/NFC, reproduzca pistas de audio almacenadas localmente e incorpore un mecanismo giratorio a modo de tocadiscos, controlado íntegramente por la placa EDU-CIAA-NXP. De forma complementaria, y sujeto a la disponibilidad de tiempo, el prototipo incorpora un modo de asignación de canciones con almacenamiento persistente y secuencias lumínicas con LEDs NeoPixel.


== Objetivos primarios

- Identificar cada disco mediante una etiqueta RFID/NFC.

- Asociar cada disco identificado con una canción o conjunto de canciones.

- Reproducir archivos de audio almacenados localmente.

- Permitir ajustar el volumen mediante un control físico.

- Mostrar en una pantalla información básica sobre el estado del sistema y la reproducción.

- Integrar los distintos módulos y periféricos bajo el control de la EDU-CIAA-NXP.

- Diseñar una placa de conexión que permita integrar los componentes del sistema de forma ordenada y segura.

- Incorporar un mecanismo que permita hacer girar el disco durante la reproducción, simulando el funcionamiento visual de un tocadiscos.


== Objetivos secundarios

- Incorporar LEDs NeoPixel con secuencias preprogramadas según la canción.

- Asignación configurable y persistente de canciones: incorporar un modo de configuración que permita asociar una etiqueta RFID/NFC a una canción sin modificar el código del programa, guardando dicha asociación en una memoria EEPROM externa para que persista tras el reinicio del sistema.

- Incorporar controles físicos para funciones básicas de reproducción, como pausa, cambio de pista o ajuste de volumen.

== Descripción técnico-conceptual

El sistema se organiza en torno a la placa EDU-CIAA-NXP @ciaa_esquematico, @pernia_pinout, que funciona como unidad central de control y coordina los distintos módulos del proyecto. El lector RFID/NFC MFRC522 @nxp_mfrc522 se comunica mediante SPI, la pantalla OLED @allvision_oled, @sinowealth_sh1106 mediante I²C y el módulo de reproducción DFPlayer Mini @dfrobot_dfplayer mediante UART. El procesamiento del audio es realizado por el propio DFPlayer Mini, mientras que la EDU-CIAA se encarga de controlar el funcionamiento general del sistema. En la @fig-bloques se presenta el diagrama en bloques del sistema a desarrollar.

El funcionamiento comienza cuando el usuario coloca un disco sobre el reproductor. El lector RFID/NFC obtiene el identificador de la etiqueta incorporada al disco y la EDU-CIAA busca la canción o lista de canciones asociada. A continuación, envía al DFPlayer Mini la orden de reproducción del archivo almacenado en la tarjeta microSD. La señal de audio se dirige al amplificador PAM8403 @diodes_pam8403 y posteriormente a los parlantes, mientras que la pantalla OLED muestra información sobre el estado de la reproducción y el motor paso a paso 28BYJ-48 @kiatronics_28byj48, con su controlador ULN2003 @st_uln2003, hace girar el disco mientras se reproduce la música. El volumen se ajusta con un potenciómetro deslizante cuya posición lee el conversor analógico-digital de la EDU-CIAA.


Como objetivos secundarios, se prevé una memoria EEPROM externa 24LC256 @microchip_24lc256 para almacenar las asociaciones entre las etiquetas RFID/NFC y las canciones, permitiendo conservarlas aun después de apagar o reiniciar el sistema. La EEPROM comparte el bus I²C con la pantalla OLED. Asimismo, se contempla incorporar una tira o arreglo de LEDs NeoPixel (WS2812B) @worldsemi_ws2812b conectados a un pin GPIO de la placa para generar secuencias visuales preprogramadas acordes a la canción en reproducción.

#figure(
  image("../images/DiagramaBloquesAct.png", width: 95%),
  caption: [Diagrama en bloques del sistema.],
  kind: image,
) <fig-bloques>

=== Alimentación del sistema

La alimentación del sistema partirá de una única fuente de 5 V. Desde ese riel se alimentan el reproductor, el amplificador, el motor, la tira de LEDs y la propia EDU-CIAA-NXP, mientras que los módulos de lógica de 3,3 V (lector RFID, pantalla y EEPROM) toman la tensión del regulador de la placa a través de sus conectores de expansión @ciaa_esquematico, @pernia_pinout. Los módulos de mayor consumo no se alimentan desde los pines de la EDU-CIAA, cuyos fusibles limitan la corriente a 300 mA.

Todos los módulos comparten una referencia de masa común (GND). En la @fig-bloques2 se presenta el esquema general de alimentación del sistema, cuyo diseño se detalla en la @sec:alimentacion.
#figure(
  image("../images/EsquemaAlimentacion.png", width: 95%),
  caption: [Esquema general de alimentación del sistema.],
  kind: image,
) <fig-bloques2>
