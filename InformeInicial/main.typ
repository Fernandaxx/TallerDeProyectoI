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
  footer: none, // Sin pie de página en la portada
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
  #text(size: 24pt, weight: "bold")[Tocadiscos RFID/NFC] \
  #v(0.8cm)

  #text(size: 16pt, style: "italic")["Reproductor musical interactivo con selección mediante RFID/NFC"] \
  #v(0.8cm)

  #text(size: 18pt, style: "italic")[Informe inicial]
]

#v(1fr)

// Datos de los autores en la parte inferior
#align(center)[
  #text(size: 14pt)[
    #v(0.1cm)
    Acuña, Lucia - 03213/1 \ #link("mailto:acunalucia064@gmail.com") \
    #v(0.1cm)
    Avila Montoya, Eygleen Fernanda - 02931/2 \ #link("mailto:eygleen.avila@alu.ing.unlp.edu.ar") \
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
        Tocadisco RFID/NFC
      ],
      [/**Grupo G2**/ \ Año 2026],
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
  },
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

La forma de escuchar música ha cambiado considerablemente con el avance de la tecnología. Los tocadiscos y discos de vinilo, además de cumplir una función de reproducción, se caracterizan por ofrecer una experiencia física y visual que aún hoy conserva un fuerte valor estético y nostálgico. A partir de esta idea surge el presente proyecto, que busca combinar esa forma de interacción con un sistema de reproducción musical digital.

El proyecto consiste en desarrollar un reproductor musical interactivo controlado por una placa EDU-CIAA-NXP. El usuario seleccionará la música mediante discos físicos impresos que incorporarán etiquetas RFID/NFC. Al colocar un disco sobre el dispositivo, el sistema lo identificará y reproducirá la canción o conjunto de canciones asociado. Además, una pantalla mostrará información básica sobre el estado de reproducción.

En la actualidad, la reproducción de música digital y los sistemas de identificación RFID/NFC son tecnologías ampliamente utilizadas. En este proyecto se combinan para ofrecer una forma de interacción diferente a la de los reproductores convencionales, utilizando un objeto físico para seleccionar contenido digital. Como mejora adicional, se contempla incorporar un mecanismo que permita hacer girar el disco durante la reproducción y un sistema de asociación configurable entre discos y canciones.

El principal desafío será integrar y coordinar los distintos componentes mediante la EDU-CIAA-NXP, garantizando el correcto funcionamiento de la identificación, la reproducción de audio, la señalización visual y la alimentación del sistema. De esta manera, el proyecto permitirá aplicar conocimientos de electrónica, programación y sistemas embebidos en el desarrollo de un prototipo funcional.

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

= Descripción técnico-conceptual

El sistema se organiza en torno a la placa EDU-CIAA-NXP, que funciona como unidad central de control y coordina los distintos módulos del proyecto. El lector RFID/NFC MFRC522 se comunica mediante SPI, la pantalla OLED mediante I²C y el módulo de reproducción DFPlayer Mini mediante UART. El procesamiento del audio es realizado por el propio DFPlayer Mini, mientras que la EDU-CIAA se encarga de controlar el funcionamiento general del sistema. En la @fig-bloques se presenta el diagrama en bloques del sistema a desarrollar.

El funcionamiento comienza cuando el usuario coloca un disco sobre el reproductor. El lector RFID/NFC obtiene el identificador de la etiqueta incorporada al disco y la EDU-CIAA busca la canción o lista de canciones asociada. A continuación, envía al DFPlayer Mini la orden de reproducción del archivo almacenado en la tarjeta microSD. La señal de audio se dirige al amplificador PAM8403 y posteriormente al parlante, mientras que la pantalla OLED muestra información sobre el estado de la reproducción.

Como objetivos secundarios, se contempla incorporar un motor paso a paso 28BYJ-48 con su controlador ULN2003 para hacer girar el disco mientras se reproduce la música. También se prevé una memoria EEPROM externa para almacenar las asociaciones entre las etiquetas RFID/NFC y las canciones, permitiendo conservarlas aun después de apagar o reiniciar el sistema. La EEPROM compartiría el bus I²C con la pantalla OLED.

#figure(
  image("image/DiagramaBloques.png", width: 95%),
  caption: [Diagrama en bloques del sistema.],
  kind: image,
) <fig-bloques>


== Alimentación del sistema

La alimentación del sistema partirá de una fuente de 5 V. Los módulos de audio y, en caso de implementarse, el motor utilizarán el dominio de 5 V, mientras que los dispositivos que trabajan con lógica de 3,3 V utilizarán el correspondiente nivel de alimentación.

La EDU-CIAA-NXP dispone de líneas de 5 V y 3,3 V en sus conectores de expansión. Todos los módulos compartirán una referencia de masa común (GND). En la @fig-alimentacion se presenta el esquema general de alimentación previsto para el sistema.

#figure(
  image("image/DiagramaBloques2.png", width: 90%),
  caption: [Esquema general de alimentación del sistema.],
  kind: image,
) <fig-alimentacion>




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







= Cronograma preliminar

El desarrollo del proyecto se organizó en etapas sucesivas que comprenden el análisis inicial, la investigación de componentes, el diseño de hardware y software, el desarrollo del código, la fabricación, la integración y las pruebas finales. La planificación se realizó tomando como referencia el cronograma propuesto por la cátedra y los requerimientos definidos para el sistema.

Las entregas formales de la materia se consideran hitos de control que permiten evaluar el avance del proyecto y marcar el cierre de las principales etapas de desarrollo. Durante septiembre y octubre se concentrarán principalmente las tareas de investigación y diseño, mientras que entre octubre y noviembre se avanzará con la programación, el diseño y fabricación de la placa y las pruebas individuales de los distintos módulos. Durante diciembre se prevé realizar la integración, los ensayos y la validación del prototipo.


En la Tabla 1 se presenta el diagrama de Gantt preliminar del proyecto, donde se indican las principales tareas, su distribución temporal y los hitos previstos.


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
    table.header([*Tarea*], [Ago], [1ª Sep], [2ª Sep], [1ª Oct], [2ª Oct], [1ª Nov], [2ª Nov], [1ª Dic], [2ª Dic]),
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
= División de tareas del grupo

Con el fin de organizar el desarrollo y permitir el trabajo en paralelo, las principales tareas del proyecto se distribuyeron entre los integrantes del grupo. Cada integrante tendrá responsabilidades principales sobre determinados bloques del sistema, aunque las etapas de integración, pruebas, validación y documentación se realizarán de manera conjunta.

En la @tab-tareas se presenta la división preliminar de tareas del grupo. Esta distribución podrá ajustarse durante el desarrollo en función del avance del proyecto y de las necesidades que surjan en cada etapa.
#figure(
  table(
    columns: (1.1fr, 1fr, 3fr),
    align: (left, left, left),
    stroke: 0.4pt + gray,
    inset: 7pt,

    table.header([*Integrante*], [*Responsabilidad principal*], [*Tareas asignadas*]),

    [Acuña, Lucía],
    [Identificación RFID/NFC],
    [
      - Integración y pruebas del lector MFRC522.
      - Lectura e identificación de etiquetas.
      - Desarrollo de la asociación entre etiquetas y canciones.
      - Implementación de la EEPROM en caso de abordar el objetivo secundario.
    ],

    [Avila, Fernanda],
    [Reproducción y sistema de audio],
    [
      - Integración y pruebas del DFPlayer Mini.
      - Manejo de la tarjeta microSD y reproducción de archivos.
      - Integración del amplificador PAM8403 y parlante.
      - Análisis y verificación de la alimentación del sistema.
    ],

    [Bejarano, Abril],
    [Interfaz y estructura física],
    [
      - Integración y programación de la pantalla OLED.
      - Diseño de la información mostrada al usuario.
      - Diseño y desarrollo de la estructura física del tocadiscos.
      - Integración del motor de giro en caso de abordar el objetivo secundario.
    ],

    [Seijo, Gerónimo],
    [Firmware e integración de hardware],
    [
      - Diseño de la arquitectura general del firmware.
      - Integración de los distintos módulos en la EDU-CIAA-NXP.
      - Selección de pines y diseño del esquemático.
      - Diseño de la PCB tipo poncho.
    ],

    table.cell(
      colspan: 3,
      fill: rgb("#eeeeee"),
    )[
      *Tareas compartidas por todo el grupo*
    ],

    table.cell(colspan: 3)[
      Integración final del prototipo, pruebas y validación del sistema, resolución de problemas, revisión del diseño, elaboración de los informes y preparación de la presentación del proyecto.
    ],
  ),

  caption: [División preliminar de tareas entre los integrantes del grupo.],
  kind: table,
) <tab-tareas>


= Bibliografía

// TODO: completar y verificar las referencias, dando formato según la plantilla.

- [1] Proyecto CIAA, "Computadora Industrial Abierta Argentina". URL: http://www.proyecto-ciaa.com.ar/
- [2] Biblioteca sAPI, EDU-CIAA. URL: https://github.com/epernia/firmware_v3
- [3] DFRobot, "DFPlayer Mini — hoja de datos y comandos". URL: https://wiki.dfrobot.com/DFPlayer_Mini_SKU_DFR0299
- [4] NXP, "MFRC522 — Standard performance MIFARE and NTAG frontend".
- [5] Driver ULN2003 y motor 28BYJ-48 — hojas de datos.
- [6] Controlador SSD1306 / SH1106 para display OLED — hojas de datos.
- [7] Memoria EEPROM I²C 24LC256 (256K / 32K×8) — hoja de datos. // secundario
