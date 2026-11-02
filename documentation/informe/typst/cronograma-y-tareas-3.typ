= Cronograma actualizado

El desarrollo del proyecto se organizó en etapas sucesivas que comprenden el análisis inicial, la investigación de componentes, el diseño de hardware y software, el desarrollo del código, la fabricación, la integración y las pruebas finales. La planificación se realizó tomando como referencia el cronograma propuesto por la cátedra y los requerimientos definidos para el sistema.

A la fecha se completaron la elección y definición del proyecto, el análisis de componentes y protocolos, la definición de requerimientos y el diseño preliminar del esquemático y de la arquitectura del firmware. En la @tab-gantt se muestra el período restante, de octubre a diciembre de 2026, con las tareas pendientes y los hitos por cumplir.

#let d = table.cell(fill: rgb("#ffe599"))[]   // diseño
#let c = table.cell(fill: rgb("#f9cb9c"))[]   // código
#let f = table.cell(fill: rgb("#b4a7d6"))[]   // etapa final
#let h = table.cell(fill: rgb("#c9c9c9"))[]   // secundario
#let m = table.cell(fill: rgb("#f2d9d9"), align: center)[#text(fill: rgb("#b02020"), weight: "bold")[◆]]

// Días hábiles: 9/11 al 3/12 (19 días)
#let ndias = 19

// Genera una fila: tarea + celdas pintadas en los rangos indicados
#let fila(nombre, celda, ..rangos) = {
  let cells = ([#nombre],)
  for i in range(ndias) {
    let activo = rangos.pos().any(r => i >= r.at(0) and i <= r.at(1))
    cells.push(if activo { celda } else { [] })
  }
  cells
}

#let etapa(nombre) = (table.cell(colspan: ndias + 1, fill: rgb("#eeeeee"))[*#nombre*],)

  #figure(
    text(size: 7.5pt)[#table(
      columns: (auto,) + (1fr,) * ndias,
      align: (left,) + (center,) * ndias,
      stroke: 0.4pt + gray,
      inset: 3pt,
      table.header(
        table.cell(rowspan: 3, align: horizon)[*Tarea*],
        table.cell(colspan: 5)[*9–13/11*],
        table.cell(colspan: 5)[*16–20/11*],
        table.cell(colspan: 5)[*23–27/11*],
        table.cell(colspan: 4)[*30/11–3/12*],
        ..([9], [10], [11], [12], [13],
           [16], [17], [18], [19], [20],
           [23], [24], [25], [26], [27],
           [30], [1], [2], [3]).map(x => x),
      ),

      ..etapa("Etapa de diseño"),
      ..fila("Diseño del PCB (poncho)", d, (0, 4)),

      ..etapa("Desarrollo de código"),
      ..fila("Firmware de la máquina de estados", c, (0, 9)),
      ..fila("Revisión de módulos", c, (0, 14)),
      ..fila("Implementar biblioteca de discos", c, (3, 5)),
      ..fila("Implementar service de efectos", c, (6, 8)),
      ..fila("(Opcional) Modo configuración", h, (5, 11)),

      ..etapa("Etapa final"),
      ..fila("Fabricación y soldado del PCB", f, (5, 9)),
      ..fila("Estructura física del tocadiscos", f, (5, 14)),
      ..fila("Ensamblaje e integración del prototipo", f, (15, 16)),
      ..fila("Pruebas de validación del sistema", f, (17, 18)),
      ..fila("Documentación e informe final", f, (13, 18)),

      ..etapa("Entregas formales"),
      ..fila("Informe Final — 03/12/2026", m, (18, 18)),
    )],
    caption: [Diagrama de Gantt diario (días hábiles) del 9/11 al 3/12 de 2026.],
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

