// Bloques de código
#import "@preview/codly:1.3.0": * 
#import "@preview/codly-languages:0.1.10": codly-languages
// Diagramas de estados o bloques
#import "@preview/fletcher:0.5.8"
// Listas o cuestionarios
#import "@preview/lilaq:0.5.0" as lq 
// Notación matemática
#import "@preview/physica:0.9.6": * 
#import "@preview/zero:0.5.0" 

// Configuración general del texto y títulos
#set text(lang: "es", size: 12pt)
#set par(
  justify: true,
  first-line-indent: 0pt, // sangría de primera línea
)
// Numeración de títulos automática
#set heading(numbering: "1.1.")
#show heading: set text(size: 14pt)

// Leyenda ARRIBA solo para tablas; las figuras de imagen la mantienen abajo
#show figure: set figure(supplement: [Fig.])
#show figure.where(kind: table): set figure.caption(position: top)

// Leyenda ARRIBA solo para tablas; las figuras de imagen la mantienen abajo
#show figure.where(kind: image): set figure(supplement: [Fig.])
#show figure.where(kind: table): set figure(supplement: [Tabla])
#show figure.where(kind: table): set figure.caption(position: top)

// Enlaces de colores y referencias
#show cite: set text(blue)
#show link: set text(blue)
#show ref: set text(blue)

#set math.equation(numbering: "(1)")
#show ref: it => {
  if it.element != none and it.element.func() == math.equation {
    link(it.element.location(), numbering(
      it.element.numbering,
      ..counter(math.equation).at(it.element.location()),
    ))
  } else {
    it
  }
}

// Configuración de codly y zero
#show: codly-init.with()
#codly(languages: codly-languages, display-name: false, display-icon: false)
#import zero: num, zi
#zero.set-num(decimal-separator: ",")
#zero.set-group(size: 3, separator: ".", threshold: (integer: 5, fractional: calc.inf))
#zero.set-unit(fraction: "inline")

// ==========================================
// 1. CONFIGURACIÓN DE LA PORTADA
// ==========================================
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  header: none, // Sin encabezado en la portada
  footer: none  // Sin pie de página en la portada
)

/*// Logo cabecera portada Informatica 
#align(top + center)[
  #image("image/logo_INFO-UNLP.png", width: 14cm)
] */

// Logo cabecera portada Ingenieria 
#align(top + center)[
  #image("image/logo_FI-UNLP.png", width: 13cm)
]
// Espacio flexible que empuja el texto hacia el centro
#v(1fr)

// Título centrado vertical y horizontalmente
#align(center)[
  #text(size: 16pt, fill: luma(80))[E0306 - Taller de Proyecto I] \
  #v(0.8cm)
  #text(size: 24pt, weight: "bold")[Tocadisco moderno] \
  #v(0.8cm)
  #text(size: 18pt, style: "italic")[Informe inicial]
]

#v(1fr)

// Datos de los autores en la parte inferior
#align(center)[
  #text(size: 14pt)[
    #v(0.1cm)
    Acuña, Lucia - 12345/6 \ #link("mailto:gustav.kirchhoff@alu.ing.unlp.edu.ar") \
    #v(0.1cm)
    Avila Montoya, Eygleen Fernanda - 02931/2 \ #link("mailto:Eygleen.avila@alu.ing.unlp.edu.ar") \
    #v(0.1cm)
    Bejarano, Abril - 03339/5 \ #link("mailto:abril.bejarano@alu.ing.unlp.edu.ar") \
    #v(0.1cm)
    Seijo, Gerónimo - 01859/7 \ #link("mailto:seijo.geronimo@alu.ing.unlp.edu.ar") \
  ]
]

#v(1cm)
#align(center)[
  #text(size: 11pt)[
    Universidad Nacional de La Plata \
    10 de septiembre de 2026
  ]
]

#pagebreak()


// ==========================================
// 2. CONFIGURACIÓN DE LAS PÁGINAS NORMALES
// ==========================================
#set page(
  margin: (top: 3.5cm, bottom: 3cm, x: 2.5cm),
  header: context {
    set text(size: 9pt, fill: luma(80))
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        *I118 Taller de Proyecto I* \
        Tocadisco moderno
      ],
      [/**Grupo G2**/ \ Año 2026]
    )
    v(-0.3em)
    line(length: 100%, stroke: 0.5pt + luma(150))
  },
  footer: context {
    set text(size: 10pt)
    line(length: 100%, stroke: 0.5pt + luma(150))
    v(0.2em)
    align(center)[
      #counter(page).display("1 / 1", both: true)
    ]
  }
)

// Reiniciamos el contador para que el índice sea la página 1
#counter(page).update(1)

// ==========================================
// ÍNDICE
// ==========================================
#outline(title: "Índice", indent: auto)

#pagebreak()

// ==========================================
// INICIO DE DOCUMENTO 
// ==========================================
= Introducción

La reproducción de música ha atravesado una larga evolución tecnológica, desde los discos de vinilo y las máquinas de discos (jukeboxes) hasta los reproductores digitales y el streaming actual. En ese recorrido, ciertos objetos analógicos,como el tocadiscos, conservan un fuerte valor estético y nostálgico, lo que ha impulsado en los últimos años una tendencia de dispositivos que recuperan esa experiencia física combinándola con tecnología moderna.

El proyecto propuesto consiste en desarrollar un *reproductor de música interactivo* inspirado en un tocadiscos moderno, en el que el usuario selecciona la música de forma tangible: al apoyar un disco identificado con una etiqueta NFC/RFID sobre el reproductor, el sistema reconoce la tarjeta, reproduce la pista o lista de canciones asociada y hace girar el disco mediante un motor, imitando el movimiento de un plato de vinilo real. Una pantalla muestra información del estado de reproducción.

A diferencia de un reproductor puramente digital, el sistema integra tres dominios: la *identificación por radiofrecuencia* de la pieza seleccionada, la *reproducción de audio* a partir de archivos almacenados localmente, y el *accionamiento mecánico* que aporta la experiencia visual del disco girando. El reproductor de audio se resuelve mediante un módulo dedicado (DFPlayer Mini), que decodifica los archivos MP3 de una tarjeta de memoria, de modo que la unidad de control se ocupa únicamente de coordinar los periféricos y no del procesamiento de audio en sí.

El principal desafío del proyecto es la integración coordinada de múltiples periféricos que se comunican por protocolos distintos (SPI, I2C y UART) sobre una misma unidad de control, junto con el diseño de una etapa de alimentación que contemple los distintos dominios de tensión y consumo del sistema. El proyecto se desarrolla sobre la plataforma EDU-CIAA-NXP, de uso educativo, lo que aporta además valor formativo en el área de sistemas embebidos.

= Objetivo

== Objetivo general

Desarrollar un prototipo funcional de reproductor de música interactivo que, mediante la lectura de etiquetas RFID/NFC, reproduzca pistas de audio almacenadas localmente, controlado íntegramente por la placa EDU-CIAA-NXP. De forma complementaria, y sujeto a la disponibilidad de tiempo, el prototipo incorpora un mecanismo giratorio a modo de tocadiscos y un modo de asignación de canciones con almacenamiento persistente.

== Objetivos primarios

Constituyen el núcleo del proyecto, a cumplir en tiempo y forma para la cátedra. El sistema debe:

- *Selección por RFID:* detectar la presentación de una etiqueta RFID/NFC y leer su identificador único (UID) mediante un lector MFRC522 conectado por SPI.
- *Asociación tarjeta–pista:* mantener una correspondencia entre cada UID y una pista o carpeta de audio determinada.
- *Reproducción de audio:* reproducir la pista asociada mediante un módulo DFPlayer Mini, comandado por UART, que decodifica los archivos MP3 desde una microSD.
- *Amplificación de audio:* amplificar la señal de salida del reproductor mediante un módulo PAM8403 hacia un parlante.
- *Señalización visual:* mostrar el estado del sistema (en espera, reproduciendo, pista actual) en una pantalla OLED conectada por I2C.
- *Integración en PCB:* integrar la unidad de control, los periféricos y la etapa de alimentación en un poncho (shield) que no supere las dimensiones de la EDU-CIAA.

== Objetivos secundarios

Corresponden a mejoras y agregados de cumplimiento no obligatorio, sujetos a la disponibilidad de materiales, costos y, sobre todo, tiempo de desarrollo. Se plantean desde el inicio, pero su implementación queda condicionada a haber completado los objetivos primarios:

- *Accionamiento giratorio del disco:* hacer girar el disco a modo de tocadiscos mediante un motor paso a paso 28BYJ-48 con su driver ULN2003, de forma coordinada con la reproducción (el disco gira únicamente mientras suena la música). El criterio de arranque/parada se ajustaría empíricamente sobre el prototipo.
- *Asignación de canciones con almacenamiento persistente:* incorporar un modo de configuración que permita asociar una etiqueta RFID a una canción sin necesidad de fijarla en el código, guardando dicha asociación en una memoria EEPROM externa (comunicada por I2C) para que persista tras el reinicio del sistema.
- *Controles físicos (a evaluar):* incorporar botones para funciones de reproducción (por ejemplo, pausa, siguiente, control de volumen).

// TODO (con el grupo): confirmar si los botones físicos se mantienen como secundario o se descartan.

= Esquema Gráfico del Proyecto

= Esquema Gráfico del Proyecto

El sistema se organiza en torno a la placa EDU-CIAA-NXP como unidad central de control, que coordina los periféricos sin realizar procesamiento de audio. Cada periférico se comunica por un protocolo distinto, de modo que no compiten entre sí por un mismo bus: el lector RFID MFRC522 por SPI, la pantalla OLED por I2C y el módulo reproductor DFPlayer Mini por UART. En la @fig-bloques se presenta el diagrama en bloques del sistema a desarrollar.

El flujo funcional principal es el siguiente: en estado de espera, el sistema monitorea el lector RFID. Al presentarse una etiqueta, se lee su UID y se busca la pista asociada; la unidad de control envía por UART el comando de reproducción al DFPlayer Mini, que reproduce el audio hacia el amplificador PAM8403 y el parlante. La pantalla OLED se actualiza con la información de la pista. Al finalizar la reproducción, el sistema vuelve al estado de espera.

Como agregados opcionales (objetivos secundarios), el sistema contempla dos extensiones sobre este flujo: un motor paso a paso 28BYJ-48, controlado mediante cuatro líneas GPIO a través de su driver ULN2003, que haría girar el disco de forma coordinada con la reproducción; y una memoria EEPROM externa, conectada al mismo bus I2C que la pantalla, que almacenaría de forma persistente las asociaciones entre etiquetas y canciones definidas por el usuario. Ambos elementos se prevén en el diseño del hardware, de modo que puedan incorporarse si el tiempo lo permite, sin rediseñar el sistema.

La alimentación se organiza en dos dominios a partir de una fuente única de 5 V: un dominio de 5 V que alimenta el reproductor, el amplificador y —de incorporarse— el motor (los elementos de mayor consumo y con picos de corriente), y un dominio de 3,3 V, obtenido mediante un regulador, que alimenta la lógica y los módulos de 3,3 V (lector RFID, pantalla y, de incorporarse, la EEPROM). Ambos dominios comparten una masa (GND) común.

#let ciaa = rgb("#5b4a8a")
#let audio = rgb("#c77f2a")
#let logic = rgb("#3b6ea5")
#let opt = rgb("#8a8a8a")
#let pwr = rgb("#4a7a3a")

#let blk(color, title, sub) = box(
  fill: color, inset: 7pt, radius: 4pt, width: 100%,
)[
  #set text(fill: white)
  #align(center)[*#title* \ #text(size: 7.5pt)[#sub]]
]

#figure(
  block[
    #table(
      columns: (1fr, 0.5fr, 1.3fr, 0.5fr, 1fr),
      column-gutter: 0pt, row-gutter: 10pt,
      stroke: none, align: horizon,

      blk(logic, "MFRC522 (RFID)", "lectura de tarjeta"),
      align(center)[#text(size: 8pt)[SPI \ #sym.arrow.r]],
      blk(ciaa, "EDU-CIAA-NXP", "unidad de control"),
      align(center)[#text(size: 8pt)[UART \ #sym.arrow.r]],
      blk(audio, "DFPlayer Mini", "reproductor MP3"),

      [], [], align(center)[#text(size: 8pt)[I2C #sym.arrow.b]], [], align(center)[#text(size: 8pt)[audio #sym.arrow.b]],

      blk(opt, "(Opc.) Motor 28BYJ-48", "+ driver ULN2003"),
      align(center)[#text(size: 8pt)[4 GPIO \ #sym.arrow.l]],
      blk(logic, "OLED SH1106", "pantalla estado"),
      [],
      blk(audio, "PAM8403", "amplificador"),

      [], [], align(center)[#text(size: 8pt)[I2C #sym.arrow.b]], [], align(center)[#text(size: 8pt)[#sym.arrow.b]],

      [], [],
      blk(opt, "(Opc.) EEPROM", "memoria I2C"),
      [],
      blk(rgb("#666666"), "Parlante", "4-8 Ω"),
    )

    #v(8pt)

    #box(stroke: (paint: pwr, dash: "dashed", thickness: 1pt), inset: 8pt, radius: 4pt, width: 95%)[
      #align(left)[#text(fill: pwr, weight: "bold", size: 8pt)[ALIMENTACIÓN]]
      #v(3pt)
      #table(
        columns: (1fr, 0.4fr, 1fr, 0.4fr, 1.4fr),
        column-gutter: 0pt, row-gutter: 6pt, stroke: none, align: horizon,
        blk(pwr, "Fuente 5V", "USB / powerbank"),
        align(center)[#text(size: 8pt)[#sym.arrow.r]],
        blk(audio, "Riel 5V", "audio + (opc.) motor"),
        [], [],
        [],[], align(center)[#text(size: 8pt)[#sym.arrow.b]], [], [],
        [],[],
        blk(logic, "Regulador AMS1117", "salida 3.3V: RFID, OLED, CIAA, (opc.) EEPROM"),
        [],[],
      )
      #v(3pt)
      #align(left)[#text(size: 7.5pt)[GND común a todos los bloques.]]
    ]
  ],
    caption: [Diagrama en bloques del sistema: unidad de control, periféricos y etapa de alimentación.],
  kind: image,
) <fig-bloques>

= Análisis de Requerimientos

=== Primarios

- *RF-HW 1:* El sistema debe basarse en la placa EDU-CIAA-NXP como unidad central de control.
- *RF-HW 2:* El sistema debe incorporar un lector RFID MFRC522, alimentado a 3,3 V y comunicado por SPI.
- *RF-HW 3:* El sistema debe incorporar un módulo reproductor DFPlayer Mini con lectura de archivos MP3 desde microSD, alimentado a 5 V y comunicado por UART.
- *RF-HW 4:* El sistema debe incorporar un amplificador PAM8403 y un parlante de 4 u 8 Ω (potencia igual o mayor a la entregada por el amplificador) para la salida de audio.
- *RF-HW 5:* El sistema debe incorporar una pantalla OLED (SSD1306 / SH1106) de 128×64, alimentada a 3,3 V y comunicada por I²C.
- *RF-HW 6:* La línea UART que va del DFPlayer hacia la EDU-CIAA debe contar con adaptación de nivel (divisor resistivo) para proteger la entrada de 3,3 V de la placa, en caso de utilizar la respuesta del DFPlayer.
- *RF-HW 7:* Todos los periféricos deben integrarse mediante un poncho (PCB) que no supere las dimensiones de la EDU-CIAA.

// TODO: confirmar RF-HW 6 según se decida usar o no la línea TX del DFPlayer (detección de fin de pista).

=== Secundarios

- *RF-HW 8 (secundario):* El sistema podrá incorporar un motor paso a paso 28BYJ-48 con driver ULN2003, alimentado a 5 V y controlado por cuatro líneas GPIO, para el accionamiento giratorio del disco. La PCB debe prever su conexión aunque el motor no llegue a implementarse.
- *RF-HW 9 (secundario):* El sistema podrá incorporar una memoria EEPROM externa (p. ej. 24LC256, 32K×8) comunicada por I2C sobre el mismo bus que la pantalla, para el almacenamiento persistente de las asociaciones etiqueta–canción. La PCB debe prever su conexión.

== Requerimientos funcionales de software

=== Primarios

- *RF-SW 1:* El sistema debe detectar la presentación de una etiqueta RFID y leer su UID.
- *RF-SW 2:* El sistema debe asociar cada UID con una pista o carpeta de audio, mediante una estructura de datos interna.
- *RF-SW 3:* El sistema debe enviar al DFPlayer Mini los comandos correspondientes (reproducir pista, detener, ajustar volumen) por UART.
- *RF-SW 4:* El sistema debe mostrar en la pantalla OLED el estado del sistema y la información de la pista en reproducción.
- *RF-SW 5:* El sistema debe gestionar de forma no bloqueante la lectura del RFID y la actualización de la pantalla, manteniendo la responsividad.
- *RF-SW 6:* El sistema debe ignorar de forma controlada las etiquetas no reconocidas, informándolo por pantalla.

=== Secundarios

- *RF-SW 7 (secundario):* El sistema podrá accionar el motor paso a paso de forma coordinada con la reproducción de audio, manteniendo la gestión no bloqueante.
- *RF-SW 8 (secundario):* El sistema podrá proveer un modo de configuración que permita asociar una etiqueta RFID a una canción seleccionada por el usuario, sin fijarla en el código.
- *RF-SW 9 (secundario):* El sistema podrá almacenar y recuperar las asociaciones etiqueta–canción desde la memoria EEPROM, de modo que persistan tras el reinicio.

// TODO: agregar requerimientos de software para botones físicos si se incorporan.

== Requerimientos no funcionales

- *Plataforma y biblioteca:* el firmware debe desarrollarse sobre la EDU-CIAA-NXP utilizando la biblioteca sAPI para la abstracción del hardware.
- *Alimentación:* el sistema debe alimentarse mediante un circuito propio con dominios de tensión separados (5 V y 3,3 V) y masa común, sin alimentar los periféricos de mayor consumo (audio y motor) directamente desde los pines de la EDU-CIAA, respetando el límite de corriente de la placa.
- *Modularidad:* cada periférico debe contar con su módulo de control independiente, para facilitar las pruebas unitarias y la integración progresiva.
- *Validación:* cada módulo debe ensayarse de forma individual antes de su integración final, y deben documentarse los resultados de los ensayos.
- *Plazos:* el desarrollo debe ajustarse al cronograma de hitos de la cátedra.
#pagebreak()
= Cronograma Preliminar

El proyecto se planifica en etapas sucesivas propias de un desarrollo de ingeniería, inicial, investigación, diseño, desarrollo de código y etapa final, tratando las entregas parciales como cierres de etapa. Si bien el cronograma oficial de la materia contempla la presentación final en febrero de 2027, el grupo se propone como meta anticipar la presentación a mediados de diciembre de 2026. Esta decisión impone una administración del tiempo más exigente y guía la priorización: el núcleo primario debe estar terminado y validado con holgura antes de esa fecha.

Las entregas formales de la cátedra (Informe Inicial, Informes de Avance 1 y 2, e Informe Final) se toman como hitos de control que marcan el cierre de cada etapa. Los objetivos secundarios (giro del disco con motor y modo de asignación con EEPROM) se ubican en la holgura de la etapa final y se abordarán únicamente si las etapas previas se cierran en tiempo.

// NOTA (con el grupo): las columnas agrupan semanas por mes. Las barras indican en qué período
// se trabaja cada tarea; la asignación fina por integrante y semana se detalla en la sección
// "División de tareas". Editar celdas (marca de color) y estimar horas al planificar en grupo.

#v(0.5em)

#let e = table.cell(fill: rgb("#b6d7a8"))[]   // etapa inicial
#let v = table.cell(fill: rgb("#a2c4c9"))[]   // investigación
#let d = table.cell(fill: rgb("#ffe599"))[]   // diseño
#let c = table.cell(fill: rgb("#f9cb9c"))[]   // desarrollo de código
#let f = table.cell(fill: rgb("#b4a7d6"))[]   // etapa final
#let h = table.cell(fill: rgb("#c9c9c9"))[]   // secundaria (opcional)
#let m = table.cell(fill: rgb("#f2d9d9"), align: center)[#text(fill: rgb("#b02020"), weight: "bold")[◆]]

#figure(
  text(size: 9pt)[#table(
    columns: (auto,) + (1fr,) * 9,
    align: (left,) + (center,) * 9,
    stroke: 0.4pt + gray,
    inset: 3pt,
    table.header(
      [*Tarea*],
      [Ago], [1ª Sep], [2ª Sep], [1ª Oct], [2ª Oct],
      [1ª Nov], [2ª Nov], [1ª Dic], [2ª Dic],
    ),
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Etapa inicial*],
    [Elección y definición del proyecto], e, e, [], [], [], [], [], [], [],
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Etapa de investigación*],
    [Análisis de componentes y protocolos], [], v, v, [], [], [], [], [], [],
    [Definición de requerimientos y arquitectura], [], v, v, [], [], [], [], [], [],
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Etapa de diseño*],
    [Diseño del esquemático y pines EDU-CIAA], [], [], d, d, [], [], [], [], [],
    [Diseño de la arquitectura del firmware], [], [], d, d, [], [], [], [], [],
    [Diseño del PCB (poncho)], [], [], [], d, d, [], [], [], [],
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Desarrollo de código*],
    [Pruebas unitarias por módulo RFID], [], [], [], c, c, c, [], [], [],
    [Pruebas unitarias por módulo DFPlayer], [], [], [], c, c, c, [], [], [],
    [Pruebas unitarias por módulo OLED], [], [], [], c, c, c, [], [], [],
    [Firmware del núcleo (máquina de estados)], [], [], [], [], c, c, c, [], [],
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Etapa final*],
    [Fabricación y soldado del PCB], [], [], [], [], [], f, f, [], [],
    [Ensamblaje e integración del prototipo], [], [], [], [], [], [], f, f, [],
    [Estructura física del tocadiscos], [], [], [], [], [], [], f, f, [],
    [Pruebas de validación del sistema], [], [], [], [], [], [], [], f, f,
    [(Opcional) Motor + giro del disco], [], [], [], [], [], [], [], h, [],
    [(Opcional) EEPROM + modo asignación], [], [], [], [], [], [], [], h, [],
    [Documentación e informe final], [], [], [], [], [], [], [], f, f,
    table.cell(colspan: 10, fill: rgb("#eeeeee"))[*Entregas formales (hitos)*],
    [Informe Inicial - 10/09/2026], [], m, [], [], [], [], [], [], [],
    [Informe de Avance 1 - 05/10/2026], [], [], [], m, [], [], [], [], [],
    [Informe de Avance 2 - 05/11/2026], [], [], [], [], [], m, [], [], [],
    [Presentación (meta del grupo)], [], [], [], [], [], [], [], [], m,
  )],
  caption: [Diagrama de Gantt por etapas, con meta de presentación en diciembre de 2026.],
)

#text(size: 9pt)[
  *Referencias:*
  #box(fill: rgb("#6b8e4e"), width: 0.7em, height: 0.7em) inicial ·
  #box(fill: rgb("#4a7a3a"), width: 0.7em, height: 0.7em) investigación ·
  #box(fill: rgb("#3b6ea5"), width: 0.7em, height: 0.7em) diseño ·
  #box(fill: rgb("#c77f2a"), width: 0.7em, height: 0.7em) desarrollo ·
  #box(fill: rgb("#7a4a9a"), width: 0.7em, height: 0.7em) etapa final ·
  #box(fill: rgb("#c9c9c9"), width: 0.7em, height: 0.7em) opcional ·
  #text(fill: rgb("#b02020"), weight: "bold")[◆] hito.
]

#pagebreak()

= División de Tareas del Grupo

La siguiente tabla propone una distribución de tareas por áreas de trabajo entre las cuatro integrantes del grupo. La asignación de cada integrante a un área es todavía tentativa y se definirá al inicio del desarrollo; las áreas están planteadas de modo que las cargas queden equilibradas y que cada integrante participe tanto de hardware como de software o documentación. Muchas tareas (fabricación del PCB, soldado, armado final, redacción de informes) se realizarán de forma colaborativa.

// NOTA (con el grupo): reemplazar "Integrante 1..4" por los nombres reales una vez acordada la asignación.
// Las áreas pueden reordenarse o intercambiarse entre integrantes.

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + gray,
    inset: 5pt,

    table.header([*Integrante / Rol*], [*Áreas y tareas principales*]),

    [Integrante 1 — Firmware base y arquitectura],
    [Definición de la arquitectura del firmware y la máquina de estados principal. Integración general del sistema y coordinación de los módulos de software.],

    [Integrante 2 — Audio (RFID + DFPlayer)],
    [Lectura del RFID por SPI y adaptación de la librería del MFRC522. Control del DFPlayer Mini por UART (protocolo de comandos) y lógica de asociación tarjeta–pista.],

    [Integrante 3 — Interfaz y hardware],
    [Control de la pantalla OLED por I²C. Diseño del esquemático y la PCB (poncho) en KiCad, previendo también los módulos secundarios (motor y EEPROM).],

    [Integrante 4 — Alimentación, estructura y secundarios],
    [Diseño de la etapa de alimentación (dominios 5 V / 3,3 V). Estructura física del tocadiscos. Desarrollo de las tareas secundarias (motor 28BYJ-48 y EEPROM) si el tiempo lo permite.],

    [Tareas colaborativas (todo el grupo)],
    [Investigación de componentes, fabricación y soldado del PCB, pruebas unitarias, integración final, ensayos funcionales, redacción de informes y video.],
  ),
  caption: [Distribución tentativa de tareas por áreas de trabajo (asignación de nombres a definir).],
)

#pagebreak()

= Bibliografía

// TODO: completar y verificar las referencias, dando formato según la plantilla.

- [1] Proyecto CIAA, "Computadora Industrial Abierta Argentina". URL: http://www.proyecto-ciaa.com.ar/
- [2] Biblioteca sAPI, EDU-CIAA. URL: https://github.com/epernia/firmware_v3
- [3] DFRobot, "DFPlayer Mini — hoja de datos y comandos". URL: https://wiki.dfrobot.com/DFPlayer_Mini_SKU_DFR0299
- [4] NXP, "MFRC522 — Standard performance MIFARE and NTAG frontend".
- [5] Driver ULN2003 y motor 28BYJ-48 — hojas de datos.
- [6] Controlador SSD1306 / SH1106 para display OLED — hojas de datos.
- [7] Memoria EEPROM I²C 24LC256 (256K / 32K×8) — hoja de datos. // secundario
