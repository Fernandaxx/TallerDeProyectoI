
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
    [Motor + giro del disco], [], [], [], [], [], [], [], f, f,
    [(Opcional) LEDs NeoPixel + secuencias], [], [], [], [], [], [], [], h, [],
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
      - Asociación entre etiquetas y canciones.
      - Integración y programación de los LEDs NeoPixel en caso de abordar el objetivo secundario.
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
      - Integración del motor de giro.
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