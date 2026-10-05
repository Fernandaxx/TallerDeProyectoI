= Cronograma ajustado

El desarrollo del proyecto se organizó en etapas sucesivas que comprenden el análisis inicial, la investigación de componentes, el diseño de hardware y software, el desarrollo del código, la fabricación, la integración y las pruebas finales. La planificación se realizó tomando como referencia el cronograma propuesto por la cátedra y los requerimientos definidos para el sistema.

A la fecha se completaron la elección y definición del proyecto, el análisis de componentes y protocolos, la definición de requerimientos y el diseño preliminar del esquemático y de la arquitectura del firmware. En la @tab-gantt se muestra el período restante, de octubre a diciembre de 2026, con las tareas pendientes y los hitos por cumplir.

#let d = table.cell(fill: rgb("#ffe599"))[]   // diseño
#let c = table.cell(fill: rgb("#f9cb9c"))[]   // desarrollo de código
#let f = table.cell(fill: rgb("#b4a7d6"))[]   // etapa final
#let h = table.cell(fill: rgb("#c9c9c9"))[]   // secundaria (opcional)
#let m = table.cell(fill: rgb("#f2d9d9"), align: center)[#text(fill: rgb("#b02020"), weight: "bold")[◆]]

#figure(
  text(size: 9pt)[#table(
    columns: (auto,) + (1fr,) * 6,
    align: (left,) + (center,) * 6,
    stroke: 0.4pt + gray,
    inset: 3pt,
    table.header([*Tarea*], [1ª Oct], [2ª Oct], [1ª Nov], [2ª Nov], [1ª Dic], [2ª Dic]),

    table.cell(colspan: 7, fill: rgb("#eeeeee"))[*Etapa de diseño*],
    [Ajuste final del esquemático y pines EDU-CIAA], d, [], [], [], [], [],
    [Refinamiento de la arquitectura del firmware], d, [], [], [], [], [],
    [Diseño del PCB (poncho)], d, d, [], [], [], [],

    table.cell(colspan: 7, fill: rgb("#eeeeee"))[*Desarrollo de código*],
    [Pruebas unitarias del módulo RFID], c, c, c, [], [], [],
    [Pruebas unitarias del módulo DFPlayer], c, c, c, [], [], [],
    [Pruebas unitarias del módulo OLED], c, c, c, [], [], [],
    [Firmware del núcleo (máquina de estados)], [], c, c, c, [], [],

    table.cell(colspan: 7, fill: rgb("#eeeeee"))[*Etapa final*],
    [Fabricación y soldado del PCB], [], [], f, f, [], [],
    [Ensamblaje e integración del prototipo], [], [], [], f, f, [],
    [Estructura física del tocadiscos], [], [], [], f, f, [],
    [Motor y giro del disco], [], [], [], [], f, f,
    [Pruebas de validación del sistema], [], [], [], [], f, f,
    [(Opcional) LEDs NeoPixel y secuencias], [], [], [], [], h, [],
    [(Opcional) EEPROM y modo de asignación], [], [], [], [], h, [],
    [Documentación e informe final], [], [], [], [], f, f,

    table.cell(colspan: 7, fill: rgb("#eeeeee"))[*Entregas formales (hitos)*],
    [Informe de Avance 1 — 05/10/2026], m, [], [], [], [], [],
    [Informe de Avance 2 — 05/11/2026], [], [], m, [], [], [],
    [Presentación (meta del grupo)], [], [], [], [], [], m,
  )],
  caption: [Diagrama de Gantt del período restante, con meta de presentación en diciembre de 2026.],
) <tab-gantt>

#text(size: 9pt)[
  *Referencias:*
  #box(fill: rgb("#ffe599"), width: 0.7em, height: 0.7em) diseño ·
  #box(fill: rgb("#f9cb9c"), width: 0.7em, height: 0.7em) desarrollo ·
  #box(fill: rgb("#b4a7d6"), width: 0.7em, height: 0.7em) etapa final ·
  #box(fill: rgb("#c9c9c9"), width: 0.7em, height: 0.7em) opcional ·
  #text(fill: rgb("#b02020"), weight: "bold")[◆] hito.
]

= División de tareas del grupo

Con el fin de organizar el desarrollo y permitir el trabajo en paralelo, las principales tareas del proyecto se distribuyeron entre los integrantes del grupo. Cada integrante tendrá responsabilidades principales sobre determinados bloques del sistema, aunque las etapas de integración, pruebas, validación y documentación se realizarán de manera conjunta. La distribución de tareas podrá ajustarse durante el desarrollo en función del avance del proyecto y de las necesidades que surjan en cada etapa.

Durante estas semanas se trabajó en conjunto en el esquemático y el diseño de la arquitectura del firmware. En la @tab-tareas se presenta la división de tareas del grupo, actualizada según el trabajo realizado. Se agregaron las horas computadas por cada integrante.

#figure(
  table(
    columns: (1.1fr, 3fr, 0.87fr),
    align: (left, left, left, left),
    stroke: 0.4pt + gray,
    inset: 7pt,

    table.header([*Integrante*], [*Tareas asignadas*], [*Horas computadas*]),

    [Acuña, Lucía],
    [
      Identificación RFID/NFC y sistema de iluminación:
      - Integración y pruebas del lector MFRC522.
      - Lectura e identificación de etiquetas.
      - Asociación entre etiquetas y canciones.
      - Integración y programación de los LEDs NeoPixel en caso de abordar el objetivo secundario.
      - Implementación de la EEPROM en caso de abordar el objetivo secundario.
    ],
    [],

    [Avila, Fernanda],
    [
      Reproducción y sistema de audio:
      - Integración y pruebas del DFPlayer Mini.
      - Manejo de la tarjeta microSD y reproducción de archivos.
      - Integración del amplificador PAM8403 y parlante.
      - Análisis y verificación de la alimentación del sistema.
    ],
    [],

    [Bejarano, Abril],
    [
      Interfaz y estructura física:
      - Integración y programación de la pantalla OLED.
      - Diseño de la información mostrada al usuario.
      - Diseño y desarrollo de la estructura física del tocadiscos.
      - Integración del motor de giro.
    ],
    [],

    [Seijo, Gerónimo],
    
    [
      Firmware e integración de hardware:,
      #strike[- Diseño de la arquitectura general del firmware.]
      - Integración de los distintos módulos en la EDU-CIAA-NXP.
      #strike[- Selección de pines y diseño del esquemático.]
      - Diseño de la PCB tipo poncho.
    ],
    [],

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
