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
      Identificación RFID/NFC y funcionalidades complementarias:
      - Integración y pruebas del lector MFRC522.
      - Lectura de etiquetas y asociación UID–canción.
      - Análisis de EEPROM 24LC256 y LEDs NeoPixel.
      - Colaboración en requerimientos y revisión del diseño.
    ],
    [9 h],

    [Avila, Fernanda],
    [
      Reproducción, audio y alimentación:
      - Integración y ensayos del DFPlayer Mini.
      - Configuración de microSD y reproducción de audio.
      - Integración del PAM8403 y parlantes.
      - Verificación de UART/BUSY y análisis de alimentación.
    ],
    [9 h],

    [Bejarano, Abril],
    [
      Interfaz de usuario y estructura física:
      - Integración y ensayos de la pantalla OLED SH1106.
      - Diseño de pantallas e información al usuario.
      - Análisis del control de volumen mediante fader.
      - Diseño preliminar de estructura e integración del motor.
    ],
    [9 h],

    [Seijo, Gerónimo],
    [
      Firmware e integración de hardware:
      - Diseño de la arquitectura del firmware y máquina de estados.
      - Selección y asignación de pines de la EDU-CIAA-NXP.
      - Diseño del esquemático e interfaces de periféricos.
      - Inicio del diseño de la PCB tipo poncho.
    ],
    [12 h],
  ),

  caption: [División actualizada de tareas y horas invertidas por los integrantes del grupo.],
  kind: table,
) <tab-tareas>


#figure(
  table(
    columns: 1fr,
    align: left,
    stroke: 0.4pt + gray,
    inset: 7pt,

    table.header([*Tareas compartidas por todo el grupo*]),

    [
      - Revisión de requerimientos y selección de componentes.
      - Revisión conjunta del diseño de hardware y firmware.
      - Elaboración y corrección del Informe de Avance.
      - Planificación de integración, pruebas y validación del prototipo.
    ],
  ),

  caption: [Tareas compartidas por todos los integrantes del grupo.],
  kind: table,
) <tab-tareas-compartidas>

