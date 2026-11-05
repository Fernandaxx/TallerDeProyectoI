#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Diseño de software

El firmware se desarrolla en C sobre la EDU-CIAA-NXP utilizando la biblioteca sAPI del entorno firmware_v3 @pernia_sapi @pernia_firmware_v3, que abstrae el acceso a los periféricos del LPC4337 (GPIO, SPI, I2C, UART, ADC y base de tiempo). Sobre ella se escribe un módulo por periférico, de modo que cada uno pueda probarse por separado antes de integrarlo, y una lógica principal organizada como máquina de estados finitos (MEF) no bloqueante.

== Arquitectura y modularización del firmware

El firmware se organiza en cuatro capas (@fig:arquitectura). Cada capa utiliza únicamente los servicios de la inmediatamente inferior, esta separación permite reemplazar un componente (por ejemplo, el módulo MP3 o la pantalla) modificando solo su driver, sin tocar la lógica principal. La única excepción es el control de volumen, que accede directamente al ADC de la sAPI porque el fader es un potenciómetro y no requiere un driver propio.

#figure(
  image("../images/arquitectura_v2.svg", width: 95%),
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

    [MEF], [20 ms], [Actualiza el estado del sistema a partir de los eventos del lector, el reproductor y el volumen.],

    [Reproductor],
    [20 ms],
    [Procesa las tramas recibidas del DFPlayer y envía los comandos pendientes, respetando la separación mínima de 200 ms que requiere el módulo. Vigila la salida BUSY.],

    [Volumen], [60 ms], [Lee el ADC, promedia las muestras y traduce la posición del fader a un nivel de 0 a 30.],
    [Pantalla], [20 ms], [Actualiza la pantalla por páginas (ver más abajo).],
    [Motor],
    [2 ms],
    [Avanza un paso de la secuencia mientras el disco debe girar. Se ejecuta desde la interrupción del tick de 1 ms, solo en los ticks pares.],

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

Maneja la memoria EEPROM 24LC256 por I2C, en el mismo bus que la pantalla, con dirección de dispositivo `0x50`. Es un driver de acceso a bytes, no conoce el formato de los datos que se guardan ya que de eso se ocupa el servicio de biblioteca de discos. Expone dos operaciones, `eepromLeer` y `eepromEscribir`, que reciben una dirección de 16 bits, un buffer y una cantidad de bytes, y devuelven si la transacción fue exitosa. Esto permite cambiar la estructura de la información sin cambiar el driver de la memoria.

La lectura envía la dirección de 2 bytes y luego lee de forma secuencial la cantidad pedida, de modo que un registro completo se obtiene en una sola transacción. La escritura, en cambio, está limitada por las páginas internas de 64 bytes del dispositivo, por eso el driver parte la escritura en tramos de ese tamaño y envía cada uno en una transacción distinta. Después de cada tramo espera 6 ms, para asegurar que transcurran los 5 ms máximos de escritura interna indicados por el fabricante, durante los cuales la memoria no responde.

Esta espera es la única parte bloqueante del driver. No afecta el funcionamiento normal, porque las lecturas no tienen retardo y la escritura solo se usa en dos casos: en la carga inicial de la tabla y en la asignación de un disco nuevo. En el primer caso se llama una vez por registro, lo que podría generar problemas pero ocurre antes de que arranque el lazo principal. Y en el segundo caso sólo se llama una vez por disco configurado, y a su vez sólo ocurre en el modo configuración donde no están encendidos el motor ni el reproductor.

==== rc522


// biblioteca: usamos una adaptacion a edu ciaa de la libreria mfrc522 de balboa
// está en la bibliografia como @balboa_rfid

Maneja el lector RFID RC522, basado en el MFRC522 de NXP @nxp_mfrc522, por SPI. Es una adaptación a la EDU-CIAA de la biblioteca de Balboa @balboa_rfid, reducida a lo necesario: detectar una etiqueta ISO 14443A y leer su UID, sin autenticación ni acceso a bloques. Expone `rc522_init`, `rc522_version` y `rc522_read_uid`.

Todas las operaciones se reducen a leer y escribir registros del chip: cada transferencia SPI comienza con un byte de dirección (con el bit 7 en alto para lecturas), y el chip select y el reset se manejan por GPIO. `rc522_init` hace el reset, configura el temporizador de espera (unos 10 ms), la modulación y la ganancia, y enciende la antena. `rc522_version` permite verificar que el lector responde por SPI.

`rc522_read_uid` sigue la secuencia de ISO 14443A: despierta la etiqueta (WUPA), realiza la anticolisión, la selecciona y, si el UID no está completo, repite el proceso en un segundo nivel de cascada. Así se leen UID de 4 y de 7 bytes, como los de las etiquetas NTAG usadas. Al final deja la etiqueta detenida (HLTA) para que la lectura siguiente vuelva a empezar con WUPA. El resultado de cada intento se informa como `RC522_OK`, `RC522_NOTAG`, `RC522_COLLISION` o `RC522_ERROR`; el driver no decide si hay un disco apoyado, de eso se ocupa el servicio `rfid`.


==== neopixel
Controla la tira de 22 LEDs WS2812B mediante una única línea GPIO conectada al transistor MOSFET. Debido a que los tiempos de pulso son del orden de los nanosegundos, el driver utiliza el contador de ciclos DWT->CYCCNT a 204 MHz para generar los retardos precisos bit a bit. Durante la transmisión de los datos, las interrupciones se deshabilitan temporalmente para evitar interrupciones de tiempo. La línea se opera negada, enviando el nivel lógico adecuado a la compuerta de Q1 para modular los 5 V requeridos por la tira.


==== motor
Gestiona la secuencia de activación de las bobinas del motor paso a paso 28BYJ-48. Configura cuatro salidas GPIO y ejecuta la secuencia en modo full-step (pasos completos utilizando dos bobinas en energizado constante). La función motorPaso() hace avanzar el motor un paso en el sentido indicado y es invocada periódicamente dentro de la rutina de interrupción del SysTick (1 ms), garantizando un giro uniforme sin ralentizar el lazo principal.


==== dfplayer

Controla el reproductor MP3 (MP3-TF-16P) por UART a 9600 baudios @dfrobot_dfplayer. El módulo decodifica los archivos de su microSD, por lo que el driver solo envía comandos. Expone `mp3Init`, `mp3Reproducir`, `mp3Detener`, `mp3Pausar`, `mp3Continuar` y `mp3Volumen`.

Todas se apoyan en `mp3EnviarComando`, que arma una trama de 10 bytes: inicio (`0x7E`), versión, longitud, comando, parámetro de 16 bits, checksum y fin (`0xEF`).

Las pistas se reproducen con el comando de carpeta y número (`0x0F`), con la carpeta fija en 1, de modo que cada archivo se identifica por su nombre (`/01/001.mp3`, …) y no por el orden de copiado. Al iniciar, `mp3Init` espera 1,5 s a que el módulo monte la microSD, fija el volumen en 20 y desactiva las repeticiones; luego, cada comando va seguido de una pausa de 100 ms. El driver es unidireccional: no lee las respuestas del módulo, y el fin de pista se detecta con la salida BUSY desde el servicio `reproductor`.


=== Servicios

La capa de servicios se ubica entre la máquina de estados y los drivers. Cada servicio implementa la lógica propia de una función del reproductor (identificar un disco, mostrar información, controlar los efectos) y utiliza los drivers para acceder al hardware, de modo que la máquina de estados trabaja con operaciones de alto nivel sin conocer protocolos ni direcciones. Los servicios periódicos se ejecutan como tareas desde el lazo principal, mientras que el resto de las funciones se invocan desde la máquina de estados.

==== Biblioteca de discos

Administra la tabla que asocia cada disco con sus datos. Cada disco es una etiqueta RFID/NFC de 7 bytes de UID, y su registro contiene el número de pista en la microSD, el color RGB de los efectos de iluminación, y el nombre del artista y de la canción para mostrar en pantalla. Los registros tienen un tamaño fijo de 64 bytes y se guardan de forma consecutiva en la EEPROM. Es el único módulo que utiliza el driver `eeprom`, ninguna otra capa accede a la memoria directamente.

Un registro vacío se reconoce porque su primer byte vale `0xFF`, esta marca permite resolver dos situaciones sin reservar espacio para una cabecera:

- *Carga inicial:* al arrancar, `bibliotecaInit` lee el primer byte de la tabla. Si es distinto de `0xFF`, la tabla ya fue cargada y no se modifica; si no, escribe en la memoria los discos iniciales, definidos como una constante en memoria de programa. Una opción de compilación permite forzar el borrado de la tabla y su recarga, útil cuando cambia el formato del registro.
- *Búsqueda:* `bibliotecaBuscar` recibe el UID leído por el lector RFID y recorre los registros en orden, leyendo solo el UID de cada uno, hasta encontrar una coincidencia o llegar al primer registro vacío, donde termina la búsqueda. Si encuentra el disco, lee el registro completo, asegura que las cadenas de texto terminen en `'\0'` y devuelve su índice; en caso contrario devuelve -1. Como los UID de 4 bytes se completan con ceros hasta los 7, la tabla admite etiquetas de ambos tamaños.

La búsqueda es lineal, lo cual resulta adecuado para la cantidad de discos prevista, y la lectura de cada UID es una transacción I2C breve. La máquina de estados invoca la búsqueda al detectar un cambio de disco.

//==== Volumen


==== Efectos

Abstrae y simplifica el control coordinado del movimiento y la iluminación del tocadiscos. Brinda la interfaz para encender las luces NeoPixel fijando el color mediante componentes RGB personalizados para la canción en reproducción (efectosEncender()) o apagar las luces y el motor cuando el sistema entra en estado de reposo o detención (efectosApagar()).

==== Reproductor



Es el servicio que usa la máquina de estados para manejar el audio. Se apoya en el driver `dfplayer` y agrega el estado de la reproducción, de modo que la MEF pide "reproducir esta pista" sin conocer comandos ni protocolos. Sus funciones son `reproductorInit`, `reproductorPista`, `reproductorDetener`, `reproductorPausaContinuar` y `reproductorFinPista`.

El fin de pista se detecta con la salida BUSY del módulo, activa en bajo: en bajo mientras suena y en alto cuando no (ver @sec:interfaces). `reproductorFinPista` devuelve verdadero una sola vez, cuando se ordenó una reproducción y la entrada pasa a nivel alto, por lo que la MEF puede consultarla en cada pasada sin repetir la transición. Para que BUSY alcance a bajar después de ordenar la pista, la MEF espera 500 ms en _Identificando_ antes de pasar a _Reproduciendo_ (ver @fig:mef).


==== RFID
Convierte las lecturas del driver `rc522` en información para la máquina de estados: si hay un disco apoyado, si es nuevo y cuál es su UID. La tarea `tareaRFID` se ejecuta cada 200 ms (ver @tab:tareas) e intenta leer un UID en cada pasada.

Si la lectura es exitosa, el servicio guarda el UID y marca un disco nuevo cuando antes no había ninguno o el UID cambió. Si falla estando un disco presente, recién después de tres fallos seguidos (unos 0,6 s) lo considera retirado, para no reaccionar a una lectura perdida.

La MEF consulta el servicio con tres funciones: `rfidHayDisco`, que indica si hay un disco apoyado; `rfidCambioDisco`, que devuelve verdadero una sola vez por cada disco nuevo; y `rfidObtenerUID`, que entrega el UID para buscar su pista en la biblioteca.


==== Display

Es el servicio que decide qué se muestra en la pantalla y cuándo se actualiza, y se apoya en el driver `oled` para el dibujo. La máquina de estados indica qué pantalla corresponde con `uiMostrar`, y le entrega el artista y la canción del disco actual con `uiActualizarTextos` al comenzar la reproducción. Las pantallas disponibles son inicio, espera, reproduciendo, fin de pista, disco no registrado, configuración y error.

El servicio separa dos tareas. Cambiar de pantalla o de texto solo modifica el contenido que se desea mostrar, y es instantáneo. La actualización física de la pantalla la realiza `tareaPantalla`, que el lazo principal ejecuta en cada paso de 20 ms. En cada ejecución arma o continúa la imagen en el buffer y envía una sola página de 128 bytes, lo cual toma unos 15 ms, menos que el período de la tarea. Así, la pantalla completa se renueva en varias pasadas consecutivas y el resto de las tareas, incluida la máquina de estados, se ejecutan sin retrasos. Como las animaciones avanzan por cuadros, su velocidad depende de este ritmo de actualización.

=== Máquina de estados principal

El comportamiento del sistema se describe con la MEF de la @fig:mef. El control de volumen y la actualización de la pantalla se ejecutan en todos los estados, por lo que no figuran como transiciones.

#figure(
  image("../images/diagrama_mef.png", width: 80%),
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
