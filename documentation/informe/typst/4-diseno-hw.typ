//#set heading(numbering: "1.1.1.1.")
= Diseño de hardware

El sistema se organiza alrededor de la EDU-CIAA-NXP, que coordina los periféricos pero no procesa audio: la decodificación de los archivos MP3 la resuelve un módulo dedicado. Sobre la EDU-CIAA se monta una placa de expansión propia (poncho) que distribuye la alimentación, aloja los módulos de menor tamaño y concentra los conectores hacia los elementos que van montados en el gabinete (amplificador, motor, control de volumen y tira de LEDs).

El diseño contempla todas las funcionalidades del proyecto. Dentro de ellas se distingue un *núcleo funcional* (lectura RFID, reproducción de audio, pantalla, control de volumen y giro del disco), que conforma el camino crítico del desarrollo y se integra en primer lugar, y un conjunto de *funcionalidades complementarias* (persistencia de las asignaciones e iluminación), que completan la experiencia de uso y se incorporan sobre ese núcleo. Todas quedan resueltas en el hardware desde esta etapa.

== Componentes a utilizar

En la @tab:modulos se resumen los módulos y componentes principales. La justificación de cada componente pasivo se desarrolla junto al módulo al que pertenece, en la @sec:interfaces, y en la @tab:referencias se listan todas las referencias del poncho con su valor y su huella.

// PENDIENTE: confirmar formato THT para todo el poncho (fabricación casera).
El poncho se diseña con componentes de inserción (THT), compatibles con la fabricación de la placa por el método de transferencia de tóner y atacado con ácido. Los circuitos integrados se montan sobre zócalos y los módulos se conectan mediante tiras de pines hembra o por cable, de modo que ninguno quede apoyado directamente sobre el cobre.

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
    [Fuente], [Cargador USB + módulo USB de panel], [5 V / 3 A (módulo: 2 A)], [Externo, salida JST de 2 pines],
    table.cell(colspan: 4)[_Funcionalidades complementarias_],
    [EEPROM], [24LC256-I/P (Microchip)], [256 kbit, I2C (0x50)], [DIP-8 en zócalo],
    [Tira de LEDs], [WS2812B], [22 LEDs direccionables, 5 V], [Tira con conector de 3 hilos],
    [Adaptador de nivel], [2N7000], [MOSFET N, TO-92], [TO-92],
  ),
  caption: [Módulos y componentes principales.],
) <tab:modulos>

#[
#show raw: set text(size: 7pt)
#figure(
  table(
    columns: (0.8fr, 1.7fr, 3.9fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Ref.*], [*Valor / tipo*], [*Huella propuesta (KiCad)*],
    [C1], [1000 µF / 16 V, electrolítico], [`Capacitor_THT:CP_Radial_D10.0mm_P5.00mm`],
    [C6, C11, C15], [470 µF / 16 V, electrolítico], [`Capacitor_THT:CP_Radial_D8.0mm_P3.50mm`],
    [C8], [100 µF / 16 V, electrolítico], [`Capacitor_THT:CP_Radial_D6.3mm_P2.50mm`],
    [C5], [10 µF, electrolítico], [`Capacitor_THT:CP_Radial_D5.0mm_P2.00mm`],
    [C2, C3, C4, C7, C10, C12, C13], [100 nF, cerámico], [`Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm`],
    [C9], [1 µF, cerámico], [`Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm`],
    [R1, R2, R10], [1 kΩ, 1/4 W], [`Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal`],
    [R3–R8], [10 kΩ, 1/4 W], [Ídem],
    [R9], [330 Ω, 1/4 W], [Ídem],
    [U1], [DFPlayer Mini], [Huella propia (2 tiras hembra de 1 × 8)],
    [U2], [24LC256-I/P], [`Package_DIP:DIP-8_W7.62mm_Socket`],
    [Q1], [2N7000], [`Package_TO_SOT_THT:TO-92_Inline`],
    [XA1], [Conectores P1 y P2 de la EDU-CIAA], [2 tiras macho de 2 × 20 (huella del Proyecto CIAA)],
    [J1, J2, J5, J6, J9], [Conectores de 2 pines], [`Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical`],
    [J7, J10, J11], [Conectores de 3 pines], [`Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical`],
    [J3, J8], [Conectores de 4 pines], [`Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical`],
    [J4], [Conector de 8 pines (RFID)], [`Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical`],
  ),
  caption: [Referencias del poncho.],
) <tab:referencias>
]

== Interfaces eléctricas y conexiones <sec:interfaces>

Los módulos del núcleo funcional utilizan cada uno un periférico distinto del LPC4337 (SPI, I2C, UART, ADC y GPIO para el motor), todos disponibles en los conectores P1 y P2 de la EDU-CIAA, por lo que no compiten entre sí. La asignación completa de pines se resume en la @tab:pines. Se evitaron los pines rotulados para Ethernet y LCD; de los pines del teclado matricial solo se usa T_FIL1, como salida de propósito general, porque el proyecto no utiliza teclado.

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
    [], [SDA (NSS)], [P2-29], [GPIO0], [`RFID_SDA`],
    [], [RST], [P2-32], [GPIO1], [`RFID_RST`],
    [], [3,3 V], [P2-1], [3V3], [`3V3_P2`],
    [OLED y EEPROM], [SDA], [P1-19], [I2C_SDA (I2C0)], [`I2C_SDA`],
    [], [SCL], [P1-21], [I2C_SCL (I2C0)], [`I2C_SCL`],
    [], [3,3 V], [P1-1], [3V3], [`3V3_P1`],
    [DFPlayer], [RX (vía R1)], [P1-25], [RS232_TX (USART3)], [`UART_TX`],
    [], [TX (vía R2)], [P1-23], [RS232_RX (USART3)], [`UART_RX`],
    [], [BUSY], [P2-31], [GPIO2], [`DF_BUSY`],
    [Fader], [Cursor], [P1-13], [CH1 (ADC)], [`ADC_VOL`],
    [], [Extremos], [P1-17 / P1-18], [VDDA / GNDA], [`VDDA` / `GNDA`],
    [Motor], [IN1–IN4 del ULN2003], [P2-36, 35, 38, 40], [GPIO5–GPIO8], [`MOT_IN1`–`MOT_IN4`],
    [Tira LED], [DIN (vía Q1 y R9)], [P1-36], [T_FIL1 (PWM0, SCT)], [`NEO_DATA`],
    [Reserva], [Botones (a definir)], [P2-34, P2-33], [GPIO3, GPIO4], [—],
  ),
  caption: [Asignación de pines de la EDU-CIAA-NXP.],
) <tab:pines>

=== Conectores P1 y P2

Para representar la EDU-CIAA se utilizó el símbolo de la biblioteca de ponchos del Proyecto CIAA, que reúne P1 y P2 en un único componente de 80 pines. Los pines de alimentación se tratan de la siguiente manera:

- *3V3 de P1 y de P2:* alimentan los módulos de 3,3 V en dos redes separadas (`3V3_P1` y `3V3_P2`), una por cada fusible de la placa (ver @sec:alimentacion).
- *5V de P1 y de P2:* no se utilizan, porque atraviesan fusibles de 300 mA.
- *GND:* todos se conectan a la masa común para ofrecer el mejor camino de retorno.
- *GNDA y VDDA:* solo se usan para el control de volumen; GNDA no se une a GND en el poncho, porque la placa ya las une a través de una ferrita.
- *Pines sin uso:* marcados como no conectados.

 #figure(
   image("../images/sch_conectores.png", width: 95%),
   caption: [Esquemático de los conectores P1 y P2.],
 ) <fig:sch-conectores>

=== Lector RFID (entrada)

Se utiliza el módulo RC522, basado en el MFRC522 de NXP, que lee el identificador (UID) de las etiquetas NFC adheridas a cada disco. En los ensayos se verificó la lectura de etiquetas NTAG, cuyo UID es de 7 bytes. El módulo se comunica por SPI, a través del periférico SSP1 expuesto en P2:

- SCK, MOSI y MISO a los pines SPI_SCK, SPI_MOSI y SPI_MISO.
- SDA (que en modo SPI cumple la función de selección, NSS) a GPIO0.
- RST a GPIO1.

La selección se maneja por GPIO porque el MFRC522 requiere que NSS vuelva a nivel alto entre tramas [4]. Al encender, los GPIO de la CIAA quedan como entradas con pull-up interno, lo que deja el lector deshabilitado y fuera de reset hasta que el firmware los configure, por lo que no se agregan resistencias externas. Las líneas SPI van directas, sin resistencias serie, porque ambos extremos trabajan a 3,3 V.

El módulo se alimenta desde `3V3_P2` y nunca debe conectarse a 5 V (máximo absoluto de 4 V [4]). Junto al conector se colocan:

- *C5 (10 µF):* el transmisor del MFRC522 consume típicamente 60 mA y hasta 100 mA por pulsos al generar el campo de radiofrecuencia [4]; el capacitor aporta esos pulsos para que no caiga la tensión que llega desde la CIAA.
- *C4 (100 nF):* desacople de alta frecuencia.

 #figure(
   image("../images/sch_rfid.png", width: 60%),
   caption: [Esquemático del lector RFID.],
 ) <fig:sch-rfid>

=== Pantalla OLED (salida)

Para mostrar el estado del sistema y la canción en reproducción se eligió una pantalla OLED de 1,3 pulgadas y 128 × 64 píxeles con controlador SH1106 [18]. No requiere retroiluminación y su resolución alcanza para texto y gráficos simples; en los ensayos se mostró incluso una animación del disco girando junto al título y el artista. Se comunica por I2C en la dirección 0x3C:

- SDA a I2C_SDA (P1-19).
- SCL a I2C_SCL (P1-21).

Se alimenta desde `3V3_P1`, por lo que no necesita adaptación de niveles. Junto a su conector se coloca un capacitor de desacople de 100 nF (C3), ya que la pantalla consume por pulsos al refrescar; los capacitores que exige el panel para su convertidor interno ya vienen montados en el módulo [6].

 #figure(
   image("../images/sch_oled.png", width: 55%),
   caption: [Esquemático de la pantalla OLED.],
 ) <fig:sch-oled>

=== Memoria EEPROM (almacenamiento)

Para que la asignación entre etiquetas y canciones persista tras un reinicio se incorpora una EEPROM 24LC256, que comparte el bus I2C con la pantalla en la dirección 0x50 (A0, A1 y A2 a masa). Su pin WP se conecta a masa para habilitar la escritura, y se alimenta desde `3V3_P1` con un capacitor de desacople de 100 nF (C10) pegado a su pin de alimentación.

Los pines I2C0 de la CIAA son de drenador abierto y no tienen pull-up interno [3], por lo que el bus necesita resistencias externas. El módulo OLED trae las suyas (se verificó midiendo 3 V en SDA y SCL con las líneas libres), pero en el poncho se agregan R3 y R4 de 10 kΩ para que el bus funcione aunque la pantalla no esté conectada. Es el valor que recomienda el fabricante de la memoria para 100 kHz [8], velocidad a la que operará el bus; en paralelo con las del módulo, la resistencia equivalente queda dentro de lo admitido por el estándar I2C.

 #figure(
   image("../images/sch_eeprom.png", width: 40%),
   caption: [Esquemático de la memoria EEPROM y los pull-ups del bus I2C.],
 ) <fig:sch-eeprom>

=== Reproductor DFPlayer (salida de audio)

La reproducción la resuelve un DFPlayer Mini (clon MP3-TF-16P), que decodifica los archivos MP3 almacenados en su propia microSD y libera al microcontrolador de esa tarea. Se controla con comandos simples por UART a 9600 bps y se conecta a la USART3 de la CIAA:

- RX del módulo a RS232_TX (P1-25), a través de R1.
- TX del módulo a RS232_RX (P1-23), a través de R2.
- BUSY a GPIO2.

Aunque el módulo se alimenta con 5 V, su interfaz serie es de 3,3 V [5]. Se confirmó midiendo 3,375 V en el TX en reposo, por encima del umbral de nivel alto de la CIAA (0,7 × 3,3 V = 2,31 V [3]). Las resistencias R1 y R2 (1 kΩ) se colocan en serie según la recomendación del fabricante [5], para reducir ruido y limitar la corriente si una de las placas queda sin alimentación. La salida BUSY indica si hay reproducción en curso; se midieron 0,061 V reproduciendo y 3,376 V en silencio (activa en bajo, lógica de 3,3 V), lo que permite conectarla directamente y detectar el fin de una canción por su flanco ascendente.

El módulo se alimenta desde el riel de 5 V, junto a él se colocan C6 (470 µF), que cubre sus picos de hasta 200 mA, y C7 (100 nF) para el desacople. Los pines IO, ADKEY y USB no se utilizan. Las salidas SPK del amplificador interno (mono) se llevan a una bornera de respaldo (J5), validada en los ensayos.

 #figure(
   image("../images/sch_dfplayer.png", width: 75%),
   caption: [Esquemático del reproductor DFPlayer.],
 ) <fig:sch-dfplayer>

=== Amplificador y parlantes (salida de audio)

Para el sonido estéreo se utiliza un módulo amplificador clase D PAM8403, que entrega 3 W por canal sobre 4 Ω con 5 V de alimentación [7]. El módulo se monta en el panel del gabinete, para que su potenciómetro quede accesible, y se conecta al poncho por cable mediante dos conectores:

- *J7 (señal):* DAC_L, masa de señal y DAC_R del DFPlayer, en el mismo orden que la entrada L, G, R del módulo.
- *J6 (alimentación):* 5 V y masa, con pistas anchas por la corriente del amplificador.

Los parlantes se conectan directamente a las borneras del módulo, de modo que la corriente de audio no circula por el poncho. Junto a J6 se coloca C8 (100 µF), que absorbe los picos del amplificador (hasta 1,5 A) para que no se propaguen al resto del riel, y C9 (1 µF) para el desacople. Los capacitores que pide el fabricante van, en cambio, en los bornes de alimentación del propio módulo, porque deben estar lo más cerca posible del integrado [7]: un cerámico de 1 µF para los picos de alta frecuencia, uno de al menos 20 µF para el ruido de baja frecuencia y, como medida para reducir interferencias electromagnéticas, uno de 1000 µF en su borne de alimentación. Como el módulo está en el panel, se suelda en sus bornes un electrolítico de 1000 µF (que cubre las dos últimas recomendaciones) junto con el cerámico de 1 µF.

Los cables hacia el panel deben ser cortos, trenzados y alejados de los del motor. En los ensayos, la falta de la masa de señal entre el DFPlayer y el amplificador fue la causa de que no hubiera sonido, por lo que esa masa se incluye explícitamente en J7.

 #figure(
   image("../images/sch_audio.png", width: 65%),
   caption: [Esquemático de los conectores hacia el amplificador.],
 ) <fig:sch-audio>

=== Control de volumen (entrada)

El volumen se controla con un potenciómetro deslizante lineal de 10 kΩ (B10K) montado en el panel, cuya posición se lee con el ADC y se traduce por firmware a los 31 niveles de volumen del DFPlayer. La curva lineal permite que esa traducción sea directa. Se conecta por cable a J10:

- Extremo alto a VDDA (P1-17).
- Cursor a CH1 del ADC (P1-13).
- Extremo bajo a GNDA (P1-18).

Se alimenta desde la alimentación analógica de la CIAA porque así la lectura resulta proporcional a la misma referencia del conversor y queda menos expuesta al ruido digital; su consumo es de 0,33 mA. Los pines del ADC no toleran 5 V [3], por lo que el potenciómetro nunca debe conectarse al riel de 5 V. Con 10 kΩ, la impedancia que ve el ADC es como máximo de 2,5 kΩ (cursor en el centro del recorrido), dentro de lo que admite el conversor del LPC4337. Entre el cursor y GNDA se coloca C13 (100 nF), que filtra el ruido captado por el cable y estabiliza la muestra del ADC; su constante de tiempo (1 ms) es despreciable para un control manual.

 #figure(
   image("../images/sch_fader.png", width: 55%),
   caption: [Esquemático del control de volumen.],
 ) <fig:sch-fader>

=== Motor (salida)

Para el giro del disco se utiliza un motor paso a paso 28BYJ-48 con su módulo driver ULN2003, montado en el gabinete junto al motor y conectado al poncho por cable:

- *J8:* entradas IN1 a IN4 del módulo, desde GPIO5 a GPIO8.
- *J9:* alimentación de 5 V del módulo, desde el riel de 5 V del poncho, en el mismo orden que su conector (pin 1 GND, pin 2 VCC).

Según el esquema interno del ULN2003 [10, Fig. 1], cada entrada tiene una resistencia de 2,7 kΩ en serie, que limita la corriente que toma del GPIO, y el fabricante garantiza que con 2,4 V en la entrada la salida conduce 200 mA [10, Tabla 3]. Por lo tanto, los 3,3 V de los GPIO de la CIAA alcanzan para manejarlo directamente, sin etapas intermedias. Los diodos de protección contra los picos de tensión de las bobinas también están integrados en el ULN2003.

Un punto a resolver es el comportamiento durante el arranque: mientras la CIAA se reinicia y hasta que el firmware configura los pines, los GPIO del LPC4337 quedan como entradas con resistencia de pull-up interna [3]. Esa corriente débil podría activar parcialmente las salidas y mover o calentar el motor durante el reset. Para evitarlo se agregan resistencias de 10 kΩ a masa en cada entrada (R5 a R8), que mantienen las entradas firmemente en nivel bajo hasta que el firmware las controla; cuando el GPIO está en alto, cada una consume solo 0,33 mA. Junto a J9 se colocan C11 (470 µF) y C12 (100 nF), porque cada bobina consume 100 mA a 5 V y en cada paso se conmutan de a dos [9].

 #figure(
   image("../images/sch_motor.png", width: 100%),
   caption: [Esquemático de la conexión al módulo del motor.],
 ) <fig:sch-motor>

=== Iluminación (salida) <sec:neopixel>

Para la iluminación se utiliza una tira de 22 LEDs WS2812B, que se mantendrá encendida mientras suene un tema. Alimentada con 5 V, su entrada de datos necesita al menos 0,7 × 5 V = 3,5 V para reconocer un nivel alto [11], mientras que la CIAA entrega 3,3 V. Como se trata de una única señal, la adaptación de nivel se resuelve con un transistor MOSFET de canal N (Q1, 2N7000) y una resistencia de pull-up a 5 V:

- La compuerta de Q1 recibe la señal de T_FIL1 (P1-36) y su fuente va a masa.
- El drenador se conecta a 5 V a través de R10 (1 kΩ) y, a través de R9 (330 Ω), a la entrada de datos de la tira, en J11.

Cuando el GPIO está en alto, Q1 conduce y lleva la línea a 0 V; cuando está en bajo, Q1 se corta y R10 lleva la línea a 5 V. La señal resultante queda invertida, lo que se compensa en el firmware enviando cada bit negado. El 2N7000 conduce con tensiones de compuerta del orden de los 3,3 V que entrega la CIAA [12], y como el GPIO solo maneja la compuerta, no entrega corriente a la carga. El valor de R10 se eligió para que el flanco de subida, que depende de esa resistencia, sea mucho más rápido que la duración de un bit de la tira (del orden de 0,4 µs), con una corriente de solo 5 mA cuando el transistor conduce. Al arrancar, el GPIO queda con su pull-up interno, Q1 conduce y la línea permanece en bajo, que es el estado de reposo de la tira, por lo que no se encienden LEDs de forma espuria.

R9 protege al primer LED y amortigua reflexiones en el cable [13], y C15 (470 µF) cubre los picos de consumo de la tira. Se eligió T_FIL1 porque la sAPI la ofrece como salida PWM y está vinculada al periférico SCT [14]: para luz fija alcanza con generar la señal por software, y el SCT permitiría generar animaciones por hardware sin cambiar el circuito.

 #figure(
   image("../images/sch_neopixel.png", width: 75%),
   caption: [Esquemático del adaptador de nivel y la tira de LEDs.],
 ) <fig:sch-neopixel>

== Circuito esquemático

El esquemático completo del poncho se realizó en KiCad [19]. Para el DFPlayer se creó un símbolo propio; la EEPROM y el transistor 2N7000 (Q1) usan símbolos de la biblioteca estándar, y el resto de los módulos se representa mediante su conector, identificado con el módulo y el orden de sus pines, junto con los componentes que cada uno necesita. Las conexiones entre bloques se realizan con etiquetas globales. El verificador de reglas eléctricas (ERC) no reporta errores ni advertencias.
// PENDIENTE: exportar el esquemático completo (KiCad: Archivo → Trazar → SVG) y descomentar.
 #figure(
   image("../images/esquematico.png", width: 105%),
   caption: [Circuito esquemático completo del poncho.],
 ) <fig:esquematico>

== Alimentación del sistema <sec:alimentacion>

El sistema se alimenta desde un único riel de 5 V, con la siguiente arquitectura:

- *Fuente:* cargador de celular de 5 V / 3 A conectado a un módulo USB de panel (especificado a 2 A). Con el cargador y el cable reales se midieron entre 5,0 y 5,1 V sin carga.
- *Entrada al poncho (J1):* conector polarizado. Junto a él se colocan C1 (1000 µF), que actúa como reserva de todo el riel: la alimentación llega por cable desde el panel, y los picos del audio, del motor y de la tira producirían caídas momentáneas de tensión; y C2 (100 nF), para el ruido de alta frecuencia del cargador, que es una fuente conmutada.
- *Riel de 5 V:* alimenta el DFPlayer, el amplificador, el motor, la tira de LEDs y la EDU-CIAA.
- *EDU-CIAA:* se alimenta desde J2 hacia su bornera P4, la entrada de 5 V de la placa, combinada con la del USB mediante diodos [1].
- *Riel de 3,3 V:* lo genera el regulador de la propia CIAA y sale por los pines 3V3 de P1 y P2, cada uno protegido por un fusible reseteable de 300 mA [1]. Se separa en `3V3_P1` (OLED y EEPROM) y `3V3_P2` (RFID) para repartir la carga entre ambos fusibles. No se agrega un regulador propio.

No se coloca diodo contra inversión de polaridad, porque su caída de tensión dejaría al amplificador y al DFPlayer por debajo de 5 V; en su lugar se usa un conector polarizado.

 #figure(
   image("../images/sch_alimentacion.png", width: 100%),
   caption: [Esquemático de la entrada de alimentación.],
 ) <fig:sch-alimentacion>

=== Riel de 3,3 V

#figure(
  table(
    columns: (2fr, 1.2fr, 2.6fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: center + horizon,
    [*Componente*], [*Consumo MAX [mA]*], [*Notas*],
    [MFRC522], [120], [Transmisor 100 mA + secciones digital y analógica [4].],
    [OLED SH1106], [50], [Pantalla completamente encendida [6].],
    [EEPROM 24LC256], [3], [Durante escritura [8].],
    [*Total*], [*175*], [Repartido en dos fusibles de 300 mA.],
  ),
  caption: [Consumo del riel de 3,3 V.],
) <tab:consumo33>

El consumo máximo queda por debajo de 300 mA aun si todas las cargas estuvieran sobre un mismo fusible.

=== Riel de 5 V

El consumo del amplificador se estima a partir de su potencia máxima de salida y su eficiencia, de 83 % según el fabricante [7]:

$ I_"PAM" = (2 dot P_"out") / (eta dot V_"DD") = (2 dot 3.2 "W") / (0.83 dot 5 "V") approx 1.54 "A" $

Este valor corresponde a ambos canales a potencia máxima en forma continua, situación que la música no sostiene: la potencia media de una señal musical es bastante menor que la de pico. En la tira de LEDs, cada LED consume hasta 60 mA en blanco a brillo máximo [11], es decir 22 × 60 mA ≈ 1,32 A; como su uso es de iluminación ambiente, el brillo se limita por firmware a un 25 a 30 %.

#figure(
  table(
    columns: (2.2fr, 1fr, 1.1fr, 2.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: center + horizon,
    [*Componente*], [*Peor caso [A]*], [*Típico estimado [A]*], [*Notas*],
    [PAM8403 estéreo (2 × 4 Ω)], [1,54], [0,3 a 0,4], [Ecuación anterior; potencia media de la música.],
    [DFPlayer], [0,20], [0,05], [Datos del fabricante [5].],
    [Motor 28BYJ-48], [0,20], [0,20], [Dos bobinas de 50 Ω a 5 V [9].],
    [Tira WS2812B], [0,40], [0,30], [Brillo limitado por firmware.],
    [EDU-CIAA + riel de 3,3 V], [0,38], [0,30], [Estimado; a medir.],
    [*Total*], [*2,72*], [*1,15 a 1,25*], [],
  ),
  caption: [Consumo estimado del riel de 5 V.],
) <tab:consumo5>

El peor caso teórico, con todas las cargas al máximo en simultáneo, queda por debajo de los 3 A del cargador pero supera los 2 A del módulo de panel; en condiciones reales de uso el consumo típico estimado ronda 1,2 A. Para conservar el margen, el brillo de la tira se limita por firmware y el potenciómetro del amplificador se usa como tope de volumen; también se evaluará modificar el módulo de panel para que entregue los 3 A del cargador. Además, se medirá la tensión en la entrada del poncho con el sistema a volumen alto: no debería bajar de unos 4,6 V, porque la CIAA pierde unos 0,3 V en el diodo de su entrada P4 y su regulador necesita alrededor de 1 V de margen para entregar 3,3 V.

== Diseño mecánico del prototipo

El prototipo se construirá como un gabinete con aspecto de tocadiscos:

- *Cara superior:* pantalla OLED, control deslizante de volumen y módulo amplificador con su perilla accesible, zona de apoyo del disco, con el lector RFID debajo. El disco lleva adherida una etiqueta NFC y se acopla al eje del motor para girar durante la reproducción; debe ser liviano por el bajo torque del 28BYJ-48.
- *Interior:* la EDU-CIAA con el poncho, el módulo ULN2003 junto al motor y la tira de LEDs. Los módulos que no van sobre el poncho se fijan con separadores de nylon y se conectan por cables cortos, sin apoyarse sobre pistas de cobre.
- *Parlantes:* montados en el gabinete, idealmente en una cavidad cerrada, que mejora la respuesta acústica.
- *Alimentación:* ingresa por el módulo USB de panel.

// #figure(
//   image("image/croquis.png", width: 80%),
//   caption: [Croquis del prototipo.],
// ) <fig:croquis>