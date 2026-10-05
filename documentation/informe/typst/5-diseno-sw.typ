#set heading(numbering: "1.1.1.1.")
= Diseño de software

El firmware se desarrolla en C sobre la EDU-CIAA-NXP utilizando la biblioteca sAPI del entorno firmware_v3 [14] [15], que abstrae el acceso a los periféricos del LPC4337 (GPIO, SPI, I2C, UART, ADC y base de tiempo). Sobre ella se escribe un módulo por periférico, de modo que cada uno pueda probarse por separado antes de integrarlo, y una lógica principal organizada como máquina de estados finitos (MEF) no bloqueante.

== Arquitectura y modularización del firmware

El firmware se organiza en cuatro capas (@fig:arquitectura). Cada capa solo utiliza servicios de la inmediatamente inferior, lo que permite reemplazar un módulo (por ejemplo, el reproductor) sin modificar la lógica principal:

- *sAPI:* acceso al hardware de la EDU-CIAA (periféricos y tick de 1 ms).
- *Drivers:* un módulo por periférico, que encapsula su protocolo y sus particularidades.
- *Servicios:* funciones de más alto nivel que combinan drivers: la biblioteca de discos, el control de volumen y los efectos de giro y luz.
- *Aplicación:* la MEF principal y la interfaz de usuario.

#figure(
  image("../images/arquitectura.svg", width: 95%),
  caption: [Arquitectura en capas del firmware.],
) <fig:arquitectura>

=== Planificación y temporización

// PENDIENTE: confirmar la elección de un lazo cooperativo (sin RTOS).
Se adopta un esquema cooperativo sin sistema operativo: un único lazo principal recorre las tareas del sistema y cada una se ejecuta solo cuando venció su período, lo que se determina comparando el tick de 1 ms de la sAPI con el instante de su última ejecución. Ninguna tarea utiliza retardos bloqueantes, de modo que la lectura del lector RFID, la pantalla y el control de volumen avanzan en paralelo. Se eligió este esquema frente a un sistema operativo de tiempo real porque las tareas son pocas, sus tiempos son del orden de decenas de milisegundos y resulta más simple de depurar; si durante la integración aparecieran problemas de temporización, la organización por módulos permite migrar a FreeRTOS, disponible en el mismo entorno [15].

#figure(
  table(
    columns: (1.4fr, 1.2fr, 3.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: left + horizon,
    [*Tarea*], [*Período*], [*Función*],
    [Lector RFID], [150 ms], [Detecta la presencia de un disco y lee su UID. El retiro del disco se confirma tras varias lecturas fallidas consecutivas, para no reaccionar a una lectura perdida.],
    [Reproductor], [Cada iteración], [Procesa las tramas recibidas del DFPlayer y envía los comandos pendientes, respetando la separación mínima de 200 ms que requiere el módulo. Vigila la salida BUSY.],
    [Volumen], [50 ms], [Lee el ADC, promedia las muestras y traduce la posición del fader a un nivel de 0 a 30.],
    [Pantalla], [100 ms], [Actualiza la pantalla por páginas (ver más abajo).],
    [Motor], [2 a 3 ms], [Avanza un paso de la secuencia mientras el disco debe girar.],
    [Iluminación], [Por evento], [Envía los colores a la tira solo cuando cambia el estado del sistema.],
  ),
  caption: [Tareas del lazo principal.],
) <tab:tareas>

Dos tareas requieren atención particular para no bloquear el lazo:

- *Pantalla:* enviar los 1024 bytes de la pantalla completa por I2C a 100 kHz demora unos 100 ms (1024 bytes × 9 bits / 100 kHz), tiempo durante el cual las demás tareas quedarían detenidas. Por eso la imagen se arma en un buffer en RAM y se envía de a una página (128 bytes, 12 ms aproximadamente) por iteración, y solo se envían las páginas que cambiaron.
- *Tira de LEDs:* la señal de datos del WS2812B tiene tiempos del orden de 1 µs [11], por lo que se genera por software con las interrupciones deshabilitadas. Para 22 LEDs la transmisión dura 22 × 24 bits × 1,25 µs ≈ 0,7 ms, y como la luz es fija solo ocurre al cambiar de estado.

// PENDIENTE: medir en la integración si el paso del motor presenta 
// irregularidades por las tareas más largas (página de pantalla, lectura RFID). 
// Si es así, generar los pasos desde la interrupción de un temporizador del 
// LPC4337.
El motor es la tarea más sensible a esas demoras, porque un retraso en un paso se percibe como un giro irregular. Si en la integración se observara ese efecto, los pasos se generarán desde la interrupción periódica de un temporizador del LPC4337, independiente del lazo principal.

=== Drivers

- *dfplayer:* arma las tramas de 10 bytes del protocolo del DFPlayer, con su suma de verificación [5], y las encola para respetar la separación mínima entre comandos. Al arrancar espera la trama de inicialización del módulo, con un tiempo máximo de 3 s, y fija el volumen inicial, ya que el módulo arranca al máximo. Los comandos utilizados son reproducir una pista de una carpeta, detener, pausar y fijar el volumen. El fin de una pista se detecta principalmente por la salida BUSY y, como respaldo, por la trama de fin de reproducción que envía el módulo.
- *rfid:* inicializa el MFRC522 por SPI, habilita la antena y realiza la secuencia de detección y anticolisión de la norma ISO/IEC 14443A [4]. Como las etiquetas NTAG tienen UID de 7 bytes, se implementan los dos niveles de cascada de la anticolisión. Para la secuencia de registros se toma como referencia la biblioteca MFRC522 para Arduino [16], reescrita sobre la sAPI. La verificación del registro de versión acepta el valor 0x82 del clon utilizado, además de los valores del datasheet.
- *oled:* inicializa el controlador SH1106 y envía la imagen por páginas, considerando el desplazamiento de 2 columnas de su memoria (132 columnas frente a 128 visibles). Sobre él, una capa gráfica dibuja texto con una tipografía de mapa de bits e imágenes almacenadas en memoria de programa, como los cuadros de la animación del disco.
- *eeprom:* lee y escribe páginas de 64 bytes de la 24LC256 [8]. Tras cada escritura consulta a la memoria hasta que responde (ACK polling), en lugar de esperar un tiempo fijo de 5 ms.
- *motor:* recorre la secuencia de medio paso de 8 estados sobre las cuatro entradas del ULN2003. Al detenerse apaga las bobinas, para evitar el consumo de 200 mA y el calentamiento con el motor quieto.
- *neopixel:* mantiene un buffer con el color de los 22 LEDs y lo transmite a la tira. Un brillo máximo fijado como constante limita el consumo (ver sección de alimentación).

=== Servicios

- *Biblioteca de discos:* asocia cada UID con la carpeta y la pista de la microSD, y con el título y el artista que se muestran en pantalla, ya que el DFPlayer no informa los nombres de los archivos. En el núcleo funcional la tabla se define en el código; con la EEPROM, se carga desde la memoria al iniciar y se amplía desde el modo de configuración.
- *Volumen:* promedia las lecturas del ADC y las traduce a los 31 niveles del DFPlayer, con una zona muerta en cada extremo del recorrido (el fader no llega exactamente a 0 ni a 10 kΩ). El comando de volumen se envía solo cuando el nivel cambia.
- *Efectos:* arranca y detiene el giro del disco y enciende o apaga la tira de LEDs según el estado de la reproducción.

En la EEPROM, la primera página de 64 bytes se reserva para un encabezado (identificador de formato y cantidad de entradas), y cada asignación ocupa una página completa: 7 bytes de UID, 1 de carpeta, 1 de pista, 1 que indica si la entrada tiene título y artista, y 27 bytes para cada uno de esos textos. En los discos agregados desde el modo de configuración, los campos de texto quedan vacíos. Con este formato cada entrada se escribe en una sola operación y la memoria admite más de 500 discos.

=== Máquina de estados principal

El comportamiento del sistema se describe con la MEF de la @fig:mef. El control de volumen y la actualización de la pantalla se ejecutan en todos los estados, por lo que no figuran como transiciones.

#figure(
  image("../images/mef.svg", width: 80%),
  caption: [Máquina de estados principal.],
) <fig:mef>

// PENDIENTE: confirmar el comportamiento al retirar el disco (detener) y al terminar la pista (quedar en FIN DE PISTA).
+ *Inicio:* se inicializan los periféricos y se espera la trama de inicialización del DFPlayer. Si no responde o informa que no hay tarjeta, se pasa al estado de error y se muestra un aviso en pantalla.
+ *Espera:* la pantalla invita a apoyar un disco y el lector consulta periódicamente si hay una etiqueta presente.
+ *Identificando:* al leer un UID se lo busca en la biblioteca de discos.
+ *Reproduciendo:* si el UID está registrado, se ordena reproducir su pista, se muestran el título y el artista, gira el disco y se enciende la luz. Si el disco se retira, se detiene la reproducción y se vuelve a la espera.
+ *Fin de pista:* cuando BUSY indica que la pista terminó, se detienen el giro y la luz, y el sistema queda en este estado hasta que se retire el disco.
+ *Disco no registrado:* si el UID no está en la biblioteca, se informa en pantalla hasta que el disco se retire.
+ *Configuración:* funcionalidad complementaria que permite asociar un disco nuevo con una pista y guardar la asignación en la EEPROM (ver @sec:interfaz-usuario).

=== Bibliotecas y dependencias

// PENDIENTE: indicar la versión de firmware_v3 / sAPI utilizada.
- *sAPI*, dentro del entorno firmware_v3 del Proyecto CIAA [14] [15].
- *Bibliotecas de terceros:* como punto de partida para los drivers se evaluarán bibliotecas existentes para Arduino y ESP32, en particular la del MFRC522 [16] y las utilizadas en los ensayos de la pantalla y del reproductor. Las que puedan adaptarse a la sAPI se incorporarán al firmware, y en los casos en que no resulte viable el driver se implementará a partir de las hojas de datos. La lista definitiva de dependencias se definirá durante el desarrollo de cada módulo.

== Software adicional

El sistema funciona en forma autónoma y no utiliza software en PC, teléfono ni servicios web. La única tarea externa es la preparación de la tarjeta microSD del DFPlayer, que se realiza desde una PC con el explorador de archivos: la tarjeta se formatea en FAT32 y los archivos se organizan en carpetas numeradas (01, 02, …) con nombres que comienzan con un número de tres cifras (001.mp3, 002.mp3, …), que es como el DFPlayer los direcciona [5].

== Interfaz con el usuario <sec:interfaz-usuario>

La interacción busca imitar el uso de un tocadiscos: el gesto principal es apoyar un disco, y el resto de los controles se reduce al volumen. Los elementos de la interfaz son:

- *Entradas:* el disco (apoyar y retirar), el fader de volumen y la perilla del amplificador, que fija el volumen máximo.
- *Salidas:* la pantalla OLED, el sonido, el giro del disco y la luz de la tira de LEDs.

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

La pantalla de reproducción ya se probó en el ensayo de la pantalla OLED, con la animación del disco girando junto al título y el artista.

// PENDIENTE: agregar la foto de la pantalla del ensayo en ESP32 NO LA ENCUENTRO!!
// #figure(
//   image("image/oled_maqueta.jpg", width: 50%),
//   caption: [Maqueta de la pantalla de reproducción.],
// ) <fig:oled-maqueta>

El uso habitual del sistema es el siguiente:

+ Se enciende el equipo y, tras unos segundos de inicialización, la pantalla invita a apoyar un disco.
+ Se apoya un disco en la zona de lectura: comienza a sonar la canción asociada, el disco gira, se enciende la luz y la pantalla muestra el título y el artista.
+ El volumen se ajusta con el fader.
+ Al retirar el disco, la reproducción se detiene y el sistema vuelve a la espera. Si la canción termina con el disco apoyado, el sistema se detiene hasta que se lo retire.

// PENDIENTE: definir cómo se ingresa al modo de configuración (botón en GPIO3/GPIO4 o tarjeta de configuración).
Para asociar un disco nuevo se prevé un modo de configuración, al que se ingresa con un botón o apoyando una tarjeta de configuración reservada para ese fin. En ese modo se apoya el disco nuevo, se elige la pista moviendo el fader (la pantalla muestra la carpeta y el número de pista seleccionados) y se confirma la asignación, que queda guardada en la EEPROM.