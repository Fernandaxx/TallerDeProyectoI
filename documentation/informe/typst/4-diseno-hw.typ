//#set heading(numbering: "1.1.1.1.")
= Diseño de hardware

El sistema se organiza alrededor de la EDU-CIAA-NXP, que coordina los periféricos pero no procesa audio: la decodificación de los archivos MP3 la resuelve un módulo dedicado. Sobre la EDU-CIAA se monta una placa de expansión propia (poncho) que distribuye la alimentación, aloja los componentes del circuito y concentra los conectores hacia los elementos que van montados en el gabinete (amplificador, motor, control de volumen, lector RFID, pantalla y tira de LEDs).

El diseño contempla todas las funcionalidades del proyecto. Dentro de ellas se distingue un *núcleo funcional* (lectura RFID, reproducción de audio, pantalla, control de volumen y giro del disco), que conforma el camino crítico del desarrollo y se integra en primer lugar, y un conjunto de *funcionalidades complementarias* (persistencia de las asignaciones, iluminación y botones), que se incorporan sobre ese núcleo. Todas quedan resueltas en el hardware desde esta etapa.

== Componentes a utilizar

En la @tab:modulos se resumen los módulos y componentes principales. La justificación de cada componente pasivo se desarrolla junto al módulo al que pertenece, en la @sec:interfaces. La lista completa de materiales, con el encapsulado de cada componente y la huella que le corresponde en el PCB, se encuentra en la @tab:bom del Apéndice A.

El poncho se diseña con componentes de inserción (THT), compatibles con la fabricación de la placa por el método de transferencia de tóner y atacado con ácido. El DFPlayer se enchufa sobre dos tiras de pines hembra, para poder sacarlo sin desoldar. El resto de los módulos se conecta por cable a tiras de pines macho del poncho.

#figure(
  table(
    columns: (1.4fr, 1.9fr, 1.6fr, 1.5fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Componente*], [*Código / modelo*], [*Valor / característica*], [*Formato físico*],
    table.cell(colspan: 4)[_Núcleo funcional_],
    [Placa de control], [EDU-CIAA-NXP (LPC4337JBD144)], [Cortex-M4F/M0, lógica 3,3 V], [Placa con tiras P1/P2 de 2 × 20],
    [Lector RFID/NFC], [Módulo RC522 (MFRC522)], [13,56 MHz, SPI, 3,3 V], [Módulo, tira de 8 pines],
    [Reproductor MP3], [DFPlayer Mini, clon MP3-TF-16P V3.0 (MH2024K-24SS)], [microSD, UART 9600 bps], [Módulo de 16 pines (2 × 8)],
    [Pantalla], [OLED 1,3" con controlador SH1106], [128 × 64, I2C (0x3C)], [Módulo, tira de 4 pines],
    [Amplificador], [Módulo PAM8403 con potenciómetro e interruptor], [2 × 3 W en 4 Ω, clase D], [Módulo de panel],
    [Parlantes], [—], [4 Ω / 3 W], [2 unidades],
    [Control de volumen], [Potenciómetro deslizante B10K], [10 kΩ lineal, doble pista], [Componente de panel],
    [Motor y driver], [28BYJ-48 + módulo ULN2003], [Paso a paso unipolar, 5 V], [Motor + módulo en el gabinete],
    [Fuente], [Cargador de 5 V], [5 V / 3 A], [Externo, entra por el jack J1 del poncho],
    table.cell(colspan: 4)[_Funcionalidades complementarias_],
    [EEPROM], [24LC256-I/P (Microchip)], [256 kbit, I2C (0x50)], [DIP-8],
    [Tira de LEDs], [WS2812B], [22 LEDs direccionables, 5 V], [Tira con conector de 3 hilos],
    [Adaptador de nivel], [2N7000], [MOSFET N], [TO-92],
    [Botones], [Pulsadores (a definir)], [Dos entradas], [Panel, por cable a J12],
  ),
  caption: [Módulos y componentes principales.],
) <tab:modulos>

== Interfaces eléctricas y conexiones <sec:interfaces>

Los módulos del núcleo funcional utilizan cada uno un periférico distinto del LPC4337 (SPI, I2C, UART, ADC y GPIO para el motor), todos disponibles en los conectores P1 y P2 de la EDU-CIAA, por lo que no compiten entre sí. La asignación completa de pines se resume en la @tab:pines. Se evitaron los pines rotulados para Ethernet y LCD; de los pines del teclado matricial solo se usa T_FIL1, como salida de propósito general, porque el proyecto no utiliza teclado. Algunos GPIO cambiaron respecto del Avance 1 para poder rutear el PCB sin cruces de pistas (ver @sec:pcb).

#figure(
  table(
    columns: (1.3fr, 1.6fr, 1fr, 1.8fr, 1.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Módulo*], [*Señal del módulo*], [*Pin CIAA*], [*Función en la CIAA*], [*Red en el esquemático*],
    [RFID MFRC522], [SCK], [P2-20], [SPI_SCK (SSP1)], [`SPI_SCK`],
    [], [MOSI], [P2-21], [SPI_MOSI (SSP1)], [`SPI_MOSI`],
    [], [MISO], [P2-18], [SPI_MISO (SSP1)], [`SPI_MISO`],
    [], [SDA (NSS)], [P2-31], [GPIO2], [`RFID_SDA`],
    [], [RST], [P2-29], [GPIO0], [`RFID_RST`],
    [], [3,3 V], [P2-1], [3V3], [`3V3_P2`],
    [OLED y EEPROM], [SDA], [P1-19], [I2C_SDA (I2C0)], [`I2C_SDA`],
    [], [SCL], [P1-21], [I2C_SCL (I2C0)], [`I2C_SCL`],
    [], [3,3 V], [P1-1], [3V3], [`3V3_P1`],
    [DFPlayer], [RX (vía R1)], [P1-25], [RS232_TX (USART3)], [`UART_TX`],
    [], [TX (vía R2)], [P1-23], [RS232_RX (USART3)], [`UART_RX`],
    [], [BUSY], [P2-32], [GPIO1], [`DF_BUSY`],
    [Fader], [Cursor], [P1-13], [CH1 (ADC)], [`ADC_VOL`],
    [], [Extremos], [P1-17 / P1-18], [VDDA / GNDA], [`VDDA` / `GNDA`],
    [Motor], [IN1–IN4 del ULN2003], [P2-34, 36, 38, 40], [GPIO3, GPIO5, GPIO7, GPIO8], [`MOT_IN1`–`MOT_IN4`],
    [Tira LED], [DIN (vía Q1 y R9)], [P1-36], [T_FIL1], [`NEO_DATA`],
    [Botones (J12)], [Botón 1 / botón 2], [P2-33, P2-35], [GPIO4, GPIO6], [`BTN_1` / `BTN_2`],
  ),
  caption: [Asignación de pines de la EDU-CIAA-NXP.],
) <tab:pines>

=== Conectores P1 y P2

Para representar la EDU-CIAA se utilizó el símbolo de la biblioteca de ponchos del Proyecto CIAA, que reúne P1 y P2 en un único componente de 80 pines. Los pines se tratan de la siguiente manera:

- *3V3 de P1 y de P2:* alimentan los módulos de 3,3 V en dos redes separadas (`3V3_P1` y `3V3_P2`), una por cada fusible de la placa (ver @sec:alimentacion).
- *5V de P1 y de P2:* no se utilizan, porque el poncho tiene su propio riel de 5 V.
- *GND:* siguiendo la corrección del Avance 1, no se conectan todos. Se usan tres de P1 (pines 20, 24 y 38) y uno de P2 (pin 19), cerca de los periféricos que los utilizan.
- *GNDA y VDDA:* solo se usan para el control de volumen; GNDA no se une a GND en el poncho, porque la placa ya las une a través de una ferrita.
- *Pines sin uso:* marcados como no conectados.

 #figure(
   image("../images/sch_conectores.png", width: 95%),
   caption: [Esquemático de los conectores P1 y P2.],
 ) <fig:sch-conectores>

=== Lector RFID (entrada)

Se utiliza el módulo RC522, basado en el MFRC522 de NXP, que lee el identificador (UID) de las etiquetas NFC adheridas a cada disco. En los ensayos se verificó la lectura de etiquetas NTAG, cuyo UID es de 7 bytes. El módulo se comunica por SPI, a través del periférico SSP1 expuesto en P2:

- SCK, MOSI y MISO a los pines SPI_SCK, SPI_MOSI y SPI_MISO.
- SDA (que en modo SPI cumple la función de selección, NSS) a GPIO2.
- RST a GPIO0.

La selección se maneja por GPIO porque el MFRC522 requiere que NSS vuelva a nivel alto entre tramas @nxp_mfrc522. Al encender, los GPIO de la CIAA quedan como entradas con pull-up interno @nxp_lpc43xx, lo que deja el lector deshabilitado y fuera de reset hasta que el firmware los configure, por lo que no se agregan resistencias externas. Las líneas SPI van directas, sin resistencias serie, porque ambos extremos trabajan a 3,3 V.

El lector se conecta por cables a J4, cuyos pines siguen el mismo orden que los de P2 (3V3, MISO, SCK, MOSI, SDA, RST, GND e IRQ, que queda sin conectar); ese orden permitió llevar las pistas en el PCB sin cruzarlas.

El módulo se alimenta desde `3V3_P2`. Junto al conector se colocan:

- *C5 (10 µF, cerámico):* el transmisor del MFRC522 consume típicamente 60 mA y hasta 100 mA por pulsos al generar el campo de radiofrecuencia @nxp_mfrc522; el capacitor aporta esos pulsos para que no caiga la tensión que llega desde la CIAA.
- *C4 (100 nF):* desacople de alta frecuencia.

 #figure(
   image("../images/sch_rfid.png", width: 60%),
   caption: [Esquemático del lector RFID.],
 ) <fig:sch-rfid>

=== Pantalla OLED (salida)

Para mostrar el estado del sistema y la canción en reproducción se eligió una pantalla OLED de 1,3 pulgadas y 128 × 64 píxeles con controlador SH1106 @sinowealth_sh1106. No requiere retroiluminación y su resolución alcanza para texto y gráficos simples; en los ensayos se mostró incluso una animación del disco girando junto al título y el artista. Se comunica por I2C en la dirección 0x3C:

- SDA a I2C_SDA (P1-19).
- SCL a I2C_SCL (P1-21).

Se alimenta desde `3V3_P1`, por lo que no necesita adaptación de niveles. Junto a su conector se coloca un capacitor de desacople de 100 nF (C3); los capacitores que exige el panel para su convertidor interno ya vienen montados en el módulo @allvision_oled.

 #figure(
   image("../images/sch_oled.png", width: 50%),
   caption: [Esquemático de la pantalla OLED.],
 ) <fig:sch-oled>

=== Memoria EEPROM (almacenamiento)

Para que la asignación entre etiquetas y canciones persista tras un reinicio se incorpora una EEPROM 24LC256, que comparte el bus I2C con la pantalla en la dirección 0x50 (A0, A1 y A2 a masa). Su pin WP se conecta a masa para habilitar la escritura, y se alimenta desde `3V3_P1` con un capacitor de desacople de 100 nF (C10) pegado a su pin de alimentación.

Los pines I2C0 del LPC4337 son de drenador abierto y necesitan resistencias de pull-up externas @nxp_lpc43xx. La EDU-CIAA ya las trae en la placa: R95 y R97, de 2,2 kΩ a 3,3 V @ciaa_esquematico[hoja 6]. En el Avance 1 se habían agregado otras dos en el poncho; siguiendo la corrección, se quitaron.

 #figure(
   image("../images/sch_eeprom.png", width: 45%),
   caption: [Esquemático de la memoria EEPROM.],
 ) <fig:sch-eeprom>

=== Reproductor DFPlayer (salida de audio)

La reproducción la resuelve un DFPlayer Mini (clon MP3-TF-16P), que decodifica los archivos MP3 almacenados en su propia microSD y libera al microcontrolador de esa tarea. Se controla con comandos simples por UART a 9600 bps y se conecta a la USART3 de la CIAA:

- RX del módulo a RS232_TX (P1-25), a través de R1.
- TX del módulo a RS232_RX (P1-23), a través de R2.
- BUSY a GPIO1.

Aunque el módulo se alimenta con 5 V, su puerto serie trabaja con niveles de 3,3 V @dfrobot_dfplayer. Se midieron 3,375 V en su TX en reposo, por encima de los 2,31 V (0,7 × 3,3 V) que la CIAA necesita para leer un nivel alto @nxp_lpc43xx. Por eso la conexión es directa y no se agrega un divisor resistivo en el RX de la CIAA: un divisor bajaría esa tensión y achicaría el margen. R1 y R2 (1 kΩ) limitan la corriente entre los dos pines si una de las placas queda sin alimentación. La salida BUSY indica si hay reproducción en curso; se midieron 0,061 V reproduciendo y 3,376 V en silencio (activa en bajo, lógica de 3,3 V), lo que permite conectarla directamente y detectar el fin de una canción por su flanco ascendente.

El módulo se alimenta desde el riel de 5 V; junto a él se colocan C6 (470 µF), como reserva para sus picos de consumo, y C7 (100 nF) para el desacople. Se enchufa sobre dos tiras de pines hembra, para poder sacarlo sin desoldar. Los pines IO, ADKEY y USB no se utilizan. Las salidas SPK del amplificador interno (mono) se llevan a un conector de respaldo (J5), validado en los ensayos.

 #figure(
   image("../images/sch_dfplayer.png", width: 75%),
   caption: [Esquemático del reproductor DFPlayer.],
 ) <fig:sch-dfplayer>

=== Amplificador y parlantes (salida de audio)

Para el sonido estéreo se utiliza un módulo amplificador clase D PAM8403, que entrega 3 W por canal sobre 4 Ω con 5 V de alimentación @diodes_pam8403. El módulo se monta en el panel del gabinete, para que su potenciómetro quede accesible, y se conecta al poncho por cable mediante dos conectores:

- *J7 (señal):* salidas de audio izquierda y derecha del DFPlayer y masa de señal, en el mismo orden que la entrada L, G, R del módulo.
- *J6 (alimentación):* 5 V y masa.

Siguiendo la corrección del Avance 1, entre cada salida DAC del DFPlayer y J7 se agregó un filtro pasa bajos RC: R3 (1 kΩ) con C14 (10 nF) en el canal izquierdo, y R4 con C17 en el derecho. Su frecuencia de corte es:

$ f_c = 1 / (2 pi R C) = 1 / (2 pi dot 1 "kΩ" dot 10 "nF") approx 15.9 "kHz" $

Ese valor deja pasar casi todo el rango de audio y atenúa el ruido de frecuencias más altas que pueda traer la salida del DAC. Después del filtro, C16 y C18 (1 µF) quedan en serie con cada canal para bloquear una posible componente continua antes de entrar al amplificador. Al medir las salidas DAC del DFPlayer no se encontró componente continua; C16 y C18 se mantienen en el diseño como resguardo.

Los parlantes se conectan directamente a las borneras del módulo, de modo que la corriente de audio no circula por el poncho.

Los cables hacia el panel deben ser cortos y alejados de los del motor. En los ensayos, la falta de la masa de señal entre el DFPlayer y el amplificador fue la causa de que no hubiera sonido, por lo que esa masa se incluye explícitamente en J7.

 #figure(
   image("../images/sch_audio.png", width: 65%),
   caption: [Esquemático del filtro de audio y de los conectores hacia el amplificador y el parlante de respaldo.],
 ) <fig:sch-audio>

=== Control de volumen (entrada)

El volumen se controla con un potenciómetro deslizante de 10 kΩ montado en el panel, cuya posición se lee con el ADC y se traduce por firmware a los 31 niveles de volumen del DFPlayer. Es de tipo B (viene marcado B10K), es decir lineal. Se eligió lineal porque la tensión en el cursor queda proporcional a la posición y el firmware la puede traducir directamente a niveles. Se conecta por cable a J10:

- Extremo alto a VDDA (P1-17).
- Cursor a CH1 del ADC (P1-13).
- Extremo bajo a GNDA (P1-18).

Se alimenta desde la alimentación analógica de la CIAA, para que la lectura quede referida a la misma tensión que usa el conversor. Los pines del ADC no toleran 5 V @nxp_lpc43xx, por lo que el potenciómetro nunca debe conectarse al riel de 5 V. Entre el cursor y GNDA se coloca C13 (100 nF), que reduce el ruido que capta el cable.

 #figure(
   image("../images/sch_fader.png", width: 50%),
   caption: [Esquemático del control de volumen.],
 ) <fig:sch-fader>

=== Motor (salida)

Para el giro del disco se utiliza un motor paso a paso 28BYJ-48 con su módulo driver ULN2003, montado en el gabinete junto al motor y conectado al poncho por cable:

- *J8:* entradas IN1 a IN4 del módulo, desde GPIO3, GPIO5, GPIO7 y GPIO8.
- *J9:* alimentación de 5 V del módulo, desde el riel de 5 V del poncho, en el mismo orden que su conector (pin 1 GND, pin 2 VCC).

Según el esquema interno del ULN2003 @st_uln2003[Fig. 1], cada entrada tiene una resistencia de 2,7 kΩ en serie, que limita la corriente que toma del GPIO, y el fabricante garantiza que con 2,4 V en la entrada la salida conduce 200 mA @st_uln2003[Tabla 3]. Por lo tanto, los 3,3 V de los GPIO de la CIAA alcanzan para manejarlo directamente, sin etapas intermedias. Los diodos de protección contra los picos de tensión de las bobinas también están integrados en el ULN2003.

Mientras la CIAA arranca y hasta que el firmware configura los pines, los GPIO del LPC4337 quedan como entradas con resistencia de pull-up interna; el fabricante lo indica para todos los GPIO después de un reset @nxp_lpc43xx[sec. 7.16]. Para que las entradas del ULN2003 no dependan de ese estado, se agregan resistencias de 10 kΩ a masa en cada una (R5 a R8); cuando el GPIO está en alto, cada una consume 3,3 V / 10 kΩ = 0,33 mA. Junto a J9 se colocan C11 (470 µF) y C12 (100 nF), porque cada bobina consume 100 mA a 5 V y en cada paso se conmutan de a dos @kiatronics_28byj48.

 #figure(
   image("../images/sch_motor.png", width: 100%),
   caption: [Esquemático de la conexión al módulo del motor.],
 ) <fig:sch-motor>

=== Iluminación (salida) <sec:neopixel>

Para la iluminación se utiliza una tira de 22 LEDs WS2812B, que se mantendrá encendida mientras suene un tema. Cada LED tiene un controlador propio y los LEDs se conectan en cadena: la señal entra por la entrada de datos (DIN) del primero, que toma los primeros 24 bits (8 por color) y reenvía el resto por su salida al siguiente LED @worldsemi_ws2812b. Los datos viajan por un solo cable, sin señal de reloj: cada bit dura 1,25 µs y se distingue por el tiempo que la señal está en alto (0,4 µs para un 0 y 0,8 µs para un 1), y una pausa en bajo de más de 50 µs hace que todos los LEDs muestren los colores recibidos @worldsemi_ws2812b.

Alimentada con 5 V, la entrada de datos de la tira necesita al menos 0,7 × 5 V = 3,5 V para reconocer un nivel alto @worldsemi_ws2812b, mientras que la CIAA entrega 3,3 V. Como se trata de una única señal, la adaptación de nivel se resuelve con un transistor MOSFET de canal N (Q1, 2N7000) y una resistencia de pull-up a 5 V:

- La compuerta de Q1 recibe la señal de T_FIL1 (P1-36) y su fuente va a masa.
- El drenador se conecta a 5 V a través de R10 (1 kΩ) y, a través de R9 (330 Ω), a la entrada de datos de la tira, en J11.

Cuando el GPIO está en alto, Q1 conduce y lleva la línea a 0 V; cuando está en bajo, Q1 se corta y R10 lleva la línea a 5 V. La señal resultante queda invertida, lo que se compensa en el firmware enviando cada bit negado. El 2N7000 empieza a conducir con una tensión de compuerta de entre 0,8 y 3 V @microchip_2n7000, por debajo de los 3,3 V del GPIO, y como el GPIO solo maneja la compuerta, no entrega corriente a la carga. Cuando Q1 conduce, por R10 circulan 5 V / 1 kΩ = 5 mA. Al arrancar, el GPIO queda con su pull-up interno, Q1 conduce y la línea queda en bajo, por lo que la tira no recibe datos.

Para R9 y C15 se siguió la guía de Adafruit, que recomienda una resistencia de 300 a 500 Ω entre la salida del microcontrolador y la entrada del primer LED, y un capacitor de 500 a 1000 µF entre los 5 V y la masa de la tira @adafruit_neopixel. Por eso se usan R9 de 330 Ω y C15 de 1000 µF junto a J11.

 #figure(
   image("../images/sch_neopixel.png", width: 60%),
   caption: [Esquemático del adaptador de nivel y la tira de LEDs.],
 ) <fig:sch-neopixel>

=== Botones (entrada)

Para los botones, cuya función se definirá junto con el modo de configuración, se deja el conector J12 con dos entradas (GPIO4 y GPIO6) y masa. Los pulsadores se montan en el panel y cierran cada entrada a masa.

 #figure(
   image("../images/sch_botones.png", width: 35%),
   caption: [Esquemático del conector de botones.],
 ) <fig:sch-botones>

== Alimentación del sistema <sec:alimentacion>

El sistema se alimenta desde un único riel de 5 V, con la siguiente arquitectura:

- *Fuente:* cargador de 5 V / 3 A. Con el cargador se midieron entre 5,0 y 5,1 V sin carga.
- *Entrada al poncho (J1):* jack polarizado de 2,1 × 5,5 mm, soldado en el poncho. Junto a él se colocan C1 (1000 µF), como reserva de energía para los picos de corriente del audio, del motor y de la tira, y C2 (100 nF), para el ruido de alta frecuencia del cargador. El valor de C1 es una decisión del grupo: se tomó de recomendaciones de buena práctica encontradas durante la búsqueda de información, para las que no se halló una fuente formal que citar. Se verificará midiendo la tensión en J1 con el sistema funcionando (ver @sec:riel5).
- *Salidas de 5 V del poncho:* desde el mismo riel se alimentan la EDU-CIAA (por J2, hacia su bornera P4), el amplificador (J6), el módulo del motor (J9) y la tira de LEDs (J11). El DFPlayer toma los 5 V directamente en la placa.
- *EDU-CIAA:* su bornera P4 es la entrada de 5 V de la placa, combinada con la del USB mediante diodos @ciaa_esquematico.
- *Riel de 3,3 V:* lo genera el regulador de la propia CIAA y sale por los pines 3V3 de P1 y P2, cada uno protegido por un fusible reseteable de 300 mA @ciaa_esquematico. Se separa en `3V3_P1` (OLED y EEPROM) y `3V3_P2` (RFID) para repartir la carga entre ambos fusibles. No se agrega un regulador propio.

No se coloca un diodo contra inversión de polaridad, para no perder tensión en el riel de 5 V; la protección queda a cargo del jack polarizado.

 #figure(
   image("../images/sch_alimentacion.png", width: 90%),
   caption: [Esquemático de la entrada de alimentación y de la salida hacia la EDU-CIAA.],
 ) <fig:sch-alimentacion>

=== Riel de 3,3 V

#figure(
  table(
    columns: (2fr, 1.2fr, 2.6fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: center + horizon,
    [*Componente*], [*Consumo MAX [mA]*], [*Notas*],
    [MFRC522], [120], [Transmisor 100 mA + secciones digital y analógica @nxp_mfrc522.],
    [OLED SH1106], [50], [Pantalla completamente encendida @allvision_oled.],
    [EEPROM 24LC256], [3], [Durante escritura @microchip_24lc256.],
    [*Total*], [*175*], [Repartido en dos fusibles de 300 mA.],
  ),
  caption: [Consumo del riel de 3,3 V.],
) <tab:consumo33>

El consumo máximo queda por debajo de 300 mA aun si todas las cargas estuvieran sobre un mismo fusible.

=== Riel de 5 V <sec:riel5>

El consumo del amplificador se estima a partir de su potencia máxima de salida y su eficiencia, de 83 % según el fabricante @diodes_pam8403:

$ I_"PAM" = (2 dot P_"out") / (eta dot V_"DD") = (2 dot 3.2 "W") / (0.83 dot 5 "V") approx 1.54 "A" $

Este valor corresponde a ambos canales a potencia máxima en forma continua, que es el peor caso. En la tira de LEDs, cada LED consume hasta 60 mA en blanco a brillo máximo @worldsemi_ws2812b, es decir 22 × 60 mA ≈ 1,32 A; como su uso es de iluminación ambiente, el brillo se limitará por firmware.

#figure(
  table(
    columns: (2.4fr, 1fr, 2.8fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: center + horizon,
    [*Componente*], [*Peor caso [A]*], [*Notas*],
    [PAM8403 estéreo (2 × 4 Ω)], [1,54], [Ecuación anterior.],
    [DFPlayer], [0,20], [Datos del fabricante @dfrobot_dfplayer.],
    [Motor 28BYJ-48], [0,20], [Dos bobinas de 50 Ω a 5 V @kiatronics_28byj48.],
    [Tira WS2812B], [0,40], [Brillo limitado por firmware.],
    [EDU-CIAA + riel de 3,3 V], [0,38], [Estimado; a medir.],
    [*Total*], [*2,72*], [],
  ),
  caption: [Consumo del riel de 5 V en el peor caso.],
) <tab:consumo5>

El peor caso, con todas las cargas al máximo a la vez, queda por debajo de los 3 A del cargador; además, el potenciómetro del amplificador se usa como tope de volumen. Se medirá la tensión en la entrada del poncho con el sistema a volumen alto: no debería bajar de unos 4,6 V, porque la CIAA pierde unos 0,3 V en el diodo de su entrada P4 y su regulador necesita alrededor de 1 V de margen para entregar 3,3 V.

== Diseño del PCB <sec:pcb>

El PCB del poncho se diseñó en KiCad @kicad a partir del esquemático. La placa se fabrica por el método de transferencia de tóner y atacado con ácido; para el diseño se siguieron las normas de diseño de la cátedra y las correcciones que hizo el profesor sobre los borradores. La @fig:pcb-cobre muestra la capa de cobre terminada; las vistas de ambas caras y la vista 3D están en el Apéndice C.

=== Normas y reglas de diseño

La placa es de *una sola capa*: todo el cobre está del lado inferior y los componentes van del lado superior. Por eso no hay vías ni pistas cruzadas, y tampoco serigrafía. Las reglas que se cargaron en KiCad, para que el verificador de reglas de diseño (DRC) avise si alguna no se cumple, se resumen en la @tab:pcb-reglas.

#figure(
  table(
    columns: (2.2fr, 1.4fr, 2.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Parámetro*], [*Valor*], [*Origen*],
    [Orificio de todos los pads], [0,7 mm], [Norma de la cátedra (marca para centrar la mecha).],
    [Pad de tira de pines simple], [2,5 × 1,8 mm], [Norma de la cátedra.],
    [Pad de tira de pines doble (P1, P2)], [2 × 2 mm], [Norma de la cátedra.],
    [Pad de bornera (J2)], [3 × 2,5 mm], [Norma de la cátedra.],
    [Pad de circuito integrado (U2)], [2,5 × 1,5 mm], [Norma de la cátedra.],
    [Pad de transistor (Q1)], [2,5 × 1,8 mm], [Norma de la cátedra.],
    [Pad de resistencias], [2,5 × 2,5 mm], [Norma de la cátedra.],
    [Pad de capacitores], [2,5 × 2,5 mm], [Igual que las resistencias.],
    [Agujeros de sujeción], [Pad de 6 mm, orificio de 3,25 mm], [Norma de la cátedra.],
    [Ancho de pista], [1 mm (todas)], [Norma: 1 mm como mínimo.],
    [Separación entre pistas y de pista a pad], [1 mm (0,7 mm como excepción)], [Corrección del profesor.],
    [Distancia de las pistas al borde], [1,5 mm (mínimo 1 mm)], [Corrección del profesor.],
  ),
  caption: [Reglas de diseño del PCB.],
) <tab:pcb-reglas>

La separación de 1 mm se cumple en toda la placa salvo en cuatro puntos, donde queda entre 0,75 y 0,99 mm, dentro de la excepción de 0,7 mm. Todas las pistas son de 1 mm de ancho, incluida la del riel de 5 V. Los pads del jack J1 y del conector J9 se agrandaron por pedido del profesor, para que resistan mejor el esfuerzo de los cables y sean más fáciles de soldar: crecen solo hacia el lado donde no hay otras pistas.

=== Forma de la placa y montaje

El poncho tiene el tamaño completo de la EDU-CIAA, 85,85 × 137 mm, con cuatro agujeros de sujeción en las mismas posiciones que los de la placa. En el borde izquierdo se dejó un corte de 10 × 15 mm sobre la bornera P4 de la EDU-CIAA, para poder llegar a ella con los cables que salen de J2; la bornera J2 se ubicó junto al corte, con la entrada de los cables hacia él.

De P1 y P2 solo se sueldan los pines que se usan y algunos más para que el poncho quede firme sobre la placa, y no los 80 (así también cuesta menos poner y sacar el poncho). Para que sea fácil armarlo con tiras de pines comunes, los pines se agruparon en bloques de dos filas: en P1, los pines 1 a 4, 13 a 26 y 35 a 38; en P2, los pines 1 a 4, 17 a 22 y 29 a 40. En total son 44 pines; los que no se usan quedan aislados en el poncho, sin conexión a ninguna pista.

=== Ubicación de los componentes

Los componentes se agruparon por función y se ubicaron cerca de los pines de la EDU-CIAA que usan, para que las pistas sean cortas:

- *Alimentación:* el jack J1, C1, C2, J2 y J6 quedan en el borde superior, con el jack sobre el borde para poder enchufarlo.
- *Lector RFID:* J4 y sus capacitores, arriba a la izquierda, lejos de la salida de audio.
- *Pantalla, EEPROM y control de volumen:* junto a P1, donde están el bus I2C y el ADC.
- *DFPlayer y filtro de audio:* en el centro; el filtro, junto a J7.
- *Motor y botones:* abajo a la izquierda, junto a los GPIO de P2 que los manejan.
- *Tira de LEDs:* abajo a la derecha, junto a T_FIL1.

=== Ruteo y plano de masa

Todo el ruteo se hizo en la cara inferior sin puentes de cable. Para lograrlo hubo que reasignar algunos GPIO respecto del Avance 1 (motor, botones, BUSY del DFPlayer y las señales SDA y RST del lector) y ordenar los pines de J4 igual que los de P2; con eso las pistas salen de los conectores sin cruzarse. En algunos casos los propios componentes hacen de puente: por ejemplo, la pista de 5 V pasa por debajo de R3 y R4 y entre las dos filas de pines del DFPlayer.

El resto de la cara de cobre es un plano de masa (GND), separado 1 mm de las pistas y pads de otras redes. El plano reduce la cantidad de cobre que tiene que quitar el ácido y sirve de retorno común para todos los circuitos.

=== Indicaciones en el cobre

Como la placa es de una sola capa, no se hace serigrafía del lado de los componentes. En su lugar, las indicaciones mínimas para el armado se dejaron caladas en el plano de cobre: un punto junto al pin 1 de los conectores y circuitos integrados, los signos + y − en los conectores de alimentación y en los capacitores electrolíticos, y las letras L y R en el conector de audio. Se leen mirando la placa del lado del cobre. Donde no hubo lugar para el punto, el pin 1 se reconoce porque su pad es cuadrado.

=== Verificación

El esquemático pasa el verificador de reglas eléctricas (ERC) sin errores, y el PCB pasa el DRC sin errores y sin conexiones pendientes. Antes de transferir el diseño a la placa se imprime la capa de cobre en escala 1:1 para comprobar sobre papel que los componentes reales y la EDU-CIAA coincidan con los pads.

 #figure(
   image("../images/pcb_bottom.png", width: 62%),
   caption: [Capa de cobre del PCB (vista desde el lado de los componentes).],
 ) <fig:pcb-cobre>

== Diseño mecánico del prototipo

El prototipo se construirá como un gabinete con aspecto de tocadiscos:

- *Cara superior:* pantalla OLED, control deslizante de volumen y módulo amplificador con su perilla accesible, zona de apoyo del disco, con el lector RFID debajo. El disco lleva adherida una etiqueta NFC y se acopla al eje del motor para girar durante la reproducción; debe ser liviano por el bajo torque del 28BYJ-48.
- *Interior:* la EDU-CIAA con el poncho encima. El poncho se enchufa en P1 y P2 mediante las tiras de pines. El módulo ULN2003 va junto al motor y la tira de LEDs en el gabinete; ambos se conectan al poncho por cables.
- *Parlantes:* montados en el gabinete, idealmente en una cavidad cerrada, que mejora la respuesta acústica.
- *Alimentación:* el cable del cargador entra al gabinete y se enchufa en el jack J1 del poncho.

// #figure(
//   image("image/croquis.png", width: 80%),
//   caption: [Croquis del prototipo.],
// ) <fig:croquis>
