#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

= Diseño de software

El firmware se desarrolla en C sobre la EDU-CIAA-NXP utilizando la biblioteca sAPI del entorno firmware_v3 @pernia_sapi @pernia_firmware_v3, que abstrae el acceso a los periféricos del LPC4337 (GPIO, SPI, I2C, UART, ADC y base de tiempo). Sobre ella se escribe un módulo por periférico, de modo que cada uno pueda probarse por separado antes de integrarlo, y una lógica principal organizada como máquina de estados finitos (MEF) no bloqueante.

== Arquitectura y modularización del firmware

El firmware se organiza en cuatro capas (@fig:arquitectura). Cada capa utiliza únicamente los servicios de la inmediatamente inferior, esta separación permite reemplazar un componente (por ejemplo, el módulo MP3 o la pantalla) modificando solo su driver, sin tocar la lógica principal. La única excepción es el control de volumen, que accede directamente al ADC de la sAPI porque el fader es un potenciómetro y no requiere un driver propio.

#figure(
  image("../images/arquitectura_v2.svg", width: 95%)
) <fig:arquitectura>

- *sAPI:* acceso al hardware de la EDU-CIAA-NXP (I2C, SPI, UART, GPIO, ADC) y tick de 1 ms.
- *Drivers:* un módulo por periférico (`oled`, `eeprom`, `rc522`, `neopixel`, `motor` y `dfplayer`), que encapsula su protocolo y sus particularidades.
- *Servicios:* módulos de más alto nivel que se apoyan en los drivers: `display` (pantallas), `rfid` (lectura del UID), `biblioteca` (asociación UID → pista), `reproductor` (reproducción y pausa), `efectos` (giro y luz) y `volumen` (lectura del fader y escalado a 0–30). Los servicios no se llaman entre sí, sino que son coordinados desde la aplicación.
- *Aplicación:* `main.c`, que inicializa el sistema y ejecuta el bucle principal, y `mef.c`, la máquina de estados que coordina los servicios.

=== Planificación y temporización

Se adopta un esquema cooperativo sin sistema operativo. El tick de 1 ms de la sAPI activa un flag cada 20 ms y el lazo principal, al detectarla, ejecuta las tareas del sistema, las cuales poseen distintos períodos (no estrictos). Ninguna tarea utiliza retardos bloqueantes, de modo que la lectura del lector RFID, la pantalla y el control de volumen avanzan de forma concurrente. La única excepción al lazo es el motor, cuyos pasos se generan directamente desde la interrupción del tick, para que no se vean afectados por la duración de las demás tareas. Se eligió este esquema frente a un sistema operativo de tiempo real porque las tareas son pocas, sus tiempos son del orden de decenas de milisegundos y resulta más simple. Si durante la integración hubieran aparecido problemas de temporización, la organización por módulos habría permitido migrar fácilmente a FreeRTOS, disponible en el mismo entorno @pernia_firmware_v3.

#figure(
  table(
    columns: (1.4fr, 1.2fr, 3.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Tarea*], [*Período*], [*Función*],
    [Lector RFID],
    [200 ms],
    [Detecta la presencia de un disco y lee su UID. El retiro del disco se confirma tras varias lecturas fallidas consecutivas, para no reaccionar a una lectura perdida.],

    [MEF],
    [20 ms],
    [Actualiza el estado del sistema a partir de los eventos del lector, el reproductor y el volumen.],

    [Reproductor],
    [20 ms],
    [Procesa las tramas recibidas del DFPlayer y envía los comandos pendientes, respetando la separación mínima de 200 ms que requiere el módulo. Vigila la salida BUSY.],

    [Volumen], [60 ms], [Lee el ADC, promedia las muestras y traduce la posición del fader a un nivel de 0 a 30.],
    [Pantalla], [20 ms], [Actualiza la pantalla por páginas (ver más abajo).],
    [Motor], [2 ms], [Avanza un paso de la secuencia mientras el disco debe girar. Se ejecuta desde la interrupción del tick de 1 ms, solo en los ticks pares.],
    [Iluminación], [Por evento], [Envía los colores a la tira solo cuando cambia el estado del sistema.],
  ),
  caption: [Tareas del sistema.],
) <tab:tareas>

Dos tareas requieren atención particular para no bloquear el lazo:

- *Pantalla:* enviar los 1024 bytes de la pantalla completa por I2C a 100 kHz demora unos 100 ms (1024 bytes × 9 bits / 100 kHz), tiempo durante el cual las demás tareas quedarían detenidas. Por eso la imagen se arma en un buffer en RAM y se envía de a una página (128 bytes) por pasada del lazo. Se estimaba que la transmisión de una página demore unos 12 ms aproximadamente, pero en la práctica se midieron retardos de 15 ms. De esta forma cada pasada cabe dentro de los 20 ms del período base.
- *Tira de LEDs:* la señal de datos del WS2812B tiene tiempos del orden de 1 µs [11], por lo que se genera por software con las interrupciones deshabilitadas. Para 22 LEDs la transmisión dura 22 × 24 bits × 1,25 µs ≈ 0,7 ms, y como la luz es fija solo ocurre al cambiar de estado. Al generarse desde la interrupción, los pasos del motor no dependen de las tareas largas del lazo, pero mientras las interrupciones están deshabilitadas el tick queda pendiente y se atiende al terminar, por lo que un paso podría retrasarse estos 0,7 ms. Como el período del motor es de 2 ms y su tarea toma mucho menos, no se espera que esto sea un problema.

=== Drivers

La capa de drivers contiene un módulo por periférico. Cada uno accede al hardware únicamente a través de la sAPI del proyecto CIAA @pernia_firmware_v3 y oculta a las capas superiores el protocolo y las particularidades del componente, de modo que cambiar un periférico solo obliga a modificar su driver. Los periféricos de comunicación se configuran una sola vez en el arranque, desde `main.c`: UART a 9600 baudios para el reproductor, I2C a 100 kHz compartido entre la pantalla y la memoria, y SPI para el lector RFID. Luego cada driver se inicializa por separado. Todos exponen operaciones que no bloquean, de modo que pueden usarse desde el lazo cooperativo descripto en la sección anterior.

==== oled

Maneja la pantalla OLED de 128 × 64 píxeles con controlador SH1106 mediante la biblioteca U8g2 @olikraus_u8g2, de código abierto, que se adaptó para comunicarse por el I2C de la sAPI. La biblioteca ya contempla este controlador y el desplazamiento de 2 columnas de su memoria interna (132 columnas frente a 128 visibles) @sinowealth_sh1106, y aporta el dibujo de texto con tipografías de mapa de bits y de imágenes almacenadas en memoria de programa, como los cuadros de la animación del disco. La imagen se arma en un buffer en RAM, y el driver envía a la pantalla una sola página de 128 bytes por llamada. A 100 kHz, la transmisión de cada página demora unos 15 ms, algo más que el valor teórico de 11,5 ms (128 bytes × 9 bits / 100 kHz) por la sobrecarga de la biblioteca y de la sAPI. De esta forma el servicio `display` divide la actualización de la pantalla completa en varias pasadas del lazo, sin bloquear las demás tareas.

==== eeprom

==== rc522

// biblioteca: usamos una adaptacion a edu ciaa de la libreria mfrc522 de balboa
// está en la bibliografia como @balboa_rfid

==== neopixel
Controla la tira de 22 LEDs WS2812B mediante una única línea GPIO conectada al transistor MOSFET. Debido a que los tiempos de pulso son del orden de los nanosegundos, el driver utiliza el contador de ciclos DWT->CYCCNT a 204 MHz para generar los retardos precisos bit a bit. Durante la transmisión de los datos, las interrupciones se deshabilitan temporalmente para evitar interrupciones de tiempo. La línea se opera negada, enviando el nivel lógico adecuado a la compuerta de Q1 para modular los 5 V requeridos por la tira.

==== motor
Gestiona la secuencia de activación de las bobinas del motor paso a paso 28BYJ-48. Configura cuatro salidas GPIO y ejecuta la secuencia en modo full-step (pasos completos utilizando dos bobinas en energizado constante). La función motorPaso() hace avanzar el motor un paso en el sentido indicado y es invocada periódicamente dentro de la rutina de interrupción del SysTick (1 ms), garantizando un giro uniforme sin ralentizar el lazo principal.

==== dfplayer
Encapsula la comunicación serie UART a 9600 baudios con el módulo MP3 DFPlayer Mini. La función interna mp3EnviarComando() construye de forma estructurada las tramas de 10 bytes exigidas por el protocolo: byte de inicio (0x7E), versión, longitud, código de comando, bytes de parámetro (MSB y LSB), suma de comprobación (checksum de 16 bits) y byte de finalización (0xEF). El driver usa funciones de bajo nivel para inicializar la reproducción desactivando repeticiones automáticas (mp3Init()), seleccionar y reproducir una pista almacenada en la carpeta de la microSD (mp3Reproducir(), utilizando la orden 0x0F), pausar/reanudar el audio (mp3Pausar(), mp3Continuar()), detener la reproducción (mp3Detener()) y limitar el volumen en una escala de 0 a 30 (mp3Volumen()).

=== Servicios

==== Biblioteca de discos
Administra la asociación lógica entre los discos físicos con lasetiquetas RFID y los archivos de audio en la tarjeta microSD. Expone la función bibliotecaBuscar(), la cual recibe un UID de 7 bytes e identifica si el disco está registrado en la base de datos. En caso afirmativo, devuelve la información del disco: número de pista asociada, nombre de la canción, artista y el color asignado para la secuencia lumínica.

==== Volumen

==== Efectos
Abstrae y simplifica el control coordinado del movimiento y la iluminación del tocadiscos. Brinda la interfaz para encender las luces NeoPixel fijando el color mediante componentes RGB personalizados para la canción en reproducción (efectosEncender()) o apagar las luces y el motor cuando el sistema entra en estado de reposo o detención (efectosApagar()).

==== Reproductor
Constituye la capa de servicio que administra el estado del audio y se comunica directamente con la máquina de estados principal (mef.c). Utiliza el driver dfplayer, coordina las órdenes de arranque (reproductorPista()), pausa/reanudación (reproductorPausaContinuar()) y detención del audio (reproductorDetener()). Además, configura la lectura digital del pin BUSY de la placa y ofrece la función reproductorFinPista(), la cual evalúa el nivel alto para notificar una sola vez a la máquina de estados cuando un archivo de audio finaliza en forma natural.

==== RFID
Monitorea periódicamente el lector de tarjetas sin bloquear el programa principal. Se ejecuta cada 200 ms, esto es controlado por temporización del lazo en main.c. Notifica a la máquina de estados cuando se apoya un nuevo disco (rfidCambioDisco()), cuando un disco se retira del campo magnético (rfidHayDisco()) o entregando el valor del UID leído (rfidObtenerUID()).

==== Display
Maneja la interfaz visual del usuario sobre la pantalla OLED SH1106 ($128 x 64$ píxeles) con la biblioteca gráfica U8g2, administrando las pantallas de estado (UI_INICIO, UI_ESPERA, UI_REPRODUCIENDO, UI_FIN_PISTA, UI_NO_REGISTRADO, UI_CONFIG y UI_ERROR). Para garantizar que sea una operación no bloqueante dentro del bucle principal, la función tareaPantalla() fragmenta el refresco de la memoria gráfica procesando una sola página por pasada. Además, gestiona la animación en tiempo real de del disco girando (pasos de 10°) y renderiza secuencias de 14 cuadros en formato mapa de bits ($32 x 32$ píxeles), exponiendo la función uiActualizarTextos() para formatear el título (hasta 28 caracteres) y el artista (hasta 20 caracteres), y centralizando el flujo de interfaz mediante uiMostrar() 


=== Máquina de estados principal

El comportamiento del sistema se describe con la MEF de la @fig:mef. El control de volumen y la actualización de la pantalla se ejecutan en todos los estados, por lo que no figuran como transiciones.

#figure(
  image("../images/mef.svg", width: 80%),
  caption: [Máquina de estados principal.],
) <fig:mef>

+ *Inicio:* se inicializan los periféricos, y se analiza el estado del dfplayer. Si hay un problema con la microSD, pasa a estado ERROR, si no pasa a ESPERA.
+ *Espera:* la pantalla invita a apoyar un disco y el lector consulta periódicamente si hay una etiqueta presente.
+ *Identificando:* al leer un UID se lo busca en la biblioteca de discos. Si el disco está registrado, se ordena reproducir su pista y espera 500 ms antes de pasar a el estado REPRODUCIENDO (esto es para darle tiempo al reproductor para establecer la señal de BUSY, el retardo no es bloqueante). Si el disco no está registrado, pasa inmediatamente al modo NO_REGISTRADO.
+ *Reproduciendo:* se muestran el título y el artista, gira el disco y se enciende la luz. Si el disco se retira, se detiene la reproducción y se vuelve a ESPERA. Si la canción termina, se pasa a FIN_DE_PISTA.
+ *Fin de pista:* cuando BUSY indica que la pista terminó, se detienen el giro y la luz, y el sistema queda en este estado hasta que se retire el disco.
+ *Disco no registrado:* si el UID no está en la biblioteca, se informa en pantalla hasta que el disco se retire.
+ *Configuración:* funcionalidad complementaria que permite asociar un disco nuevo con una pista y guardar la asignación en la EEPROM (ver @sec:interfaz-usuario).

== Software adicional

El sistema funciona en forma autónoma y no utiliza software en PC, teléfono ni servicios web. La única tarea externa es la preparación de la tarjeta microSD del DFPlayer, que se realiza desde una PC con el explorador de archivos. La tarjeta se formatea en FAT32 y los archivos se organizan en la carpeta '01'  con nombres que comienzan con un número de tres cifras (001.mp3, 002.mp3, …), que es como el DFPlayer los direcciona @dfrobot_dfplayer.

== Interfaz con el usuario <sec:interfaz-usuario>

La interacción busca imitar el uso de un tocadiscos, el gesto principal es apoyar un disco, y el resto de los controles se reducen al volumen o pausa/reanudación. La única excepción a esto es el modo configuración, donde el usuario puede asignar un disco a un numero de pista mediante la pantalla, los botones y el fader de volumen.

- *Entradas:* los discos, el fader de volumen, la perilla del amplificador y dos botones.
- *Salidas:* la pantalla OLED, los parlantes, el giro del disco y la luz de la tira de LEDs.

En la @tab:pantallas se resume lo que muestra la pantalla y el estado de las demás salidas en cada estado. Al mover el fader, en cualquier estado, se superpone durante unos instantes una barra con el nivel de volumen.

#figure(
  table(
    columns: (1.4fr, 2.6fr, 2fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Estado*], [*Pantalla*], [*Giro y luz*],
    [Inicio], [Nombre del sistema y "Iniciando…".], [Apagados.],
    [Espera], [Invitación a apoyar un disco.], [Apagados.],
    [Reproduciendo], [Animación del disco girando, título y artista.], [Disco girando, luz encendida.],
    [Fin de pista], [Título de la pista terminada.], [Apagados.],
    [Disco no registrado], [Aviso de disco no registrado.], [Apagados.],
    [Configuración], [UID leído y pista seleccionada.], [Apagados.],
    [Error], [Aviso para revisar la microSD.], [Apagados.],
  ),
  caption: [Pantallas y salidas de cada estado.],
) <tab:pantallas>

El uso habitual del sistema es el siguiente:

+ Se enciende el equipo y, tras unos segundos de inicialización, la pantalla invita a apoyar un disco.
+ Se apoya un disco sobre el plato, comienza a sonar la canción asociada, el disco gira, se enciende la luz y la pantalla muestra el título y el artista.
+ El volumen se ajusta con el fader.
+ Al retirar el disco, la reproducción se detiene y el sistema vuelve a la espera. Si la canción termina con el disco apoyado, el sistema se detiene hasta que se lo retire.

Para asociar un disco nuevo se ingresa al modo configuración con un botón específico reservado para ese fin. En este modo se apoya el disco nuevo, se elige la pista moviendo el fader (la pantalla muestra la carpeta y el número de pista seleccionados) y se confirma la asignación, que queda guardada en la EEPROM.
