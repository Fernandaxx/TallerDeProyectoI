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

  #text(size: 18pt, style: "italic")[Informe de avance — TP N.º 2]
]

#v(1fr)

// Datos de los autores en la parte inferior
#align(center)[
  #text(size: 14pt)[
    #v(0.1cm)
    Acuña, Lucia - 03213/1 \ #link("mailto:acuna.lucia@alu.ing.unlp.edu.ar") \
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
    5 de Octubre de 2026
  ]
]

#pagebreak()




// ------------------------------------------------------------
// CARÁTULA
// ------------------------------------------------------------

// ------------------------------------------------------------

= Índice

#outline(title: none)

#pagebreak()

// ------------------------------------------------------------
// 1. DISEÑO DE HARDWARE
// ------------------------------------------------------------

= Diseño de hardware

_Describir de forma clara el diseño del hardware necesario para implementar la solución propuesta._

== Componentes a utilizar

_Detallar los componentes a utilizar indicando nombre, código de parte, valor y formato físico. Justificar la elección de cada componente._

#v(1.5cm)

== Interfaces eléctricas y conexiones

_Realizar una descripción detallada de las interfaces eléctricas entre los distintos bloques, incluyendo las conexiones entre la placa EDU-CIAA y los periféricos necesarios._

#v(1.5cm)

== Circuito esquemático

_A partir de las hojas de datos de los dispositivos involucrados, realizar el diagrama esquemático o plano electrónico con todos los componentes necesarios para su posterior implementación._

#v(3cm)

_Fig. 1: Circuito esquemático del sistema._

== Alimentación del sistema

_Detallar cómo se alimentarán los circuitos y la EDU-CIAA. Justificar mediante cálculos, aunque sean aproximados, la elección de la fuente de alimentación en función del consumo de los distintos elementos del hardware._

#v(2cm)

== Diseño mecánico del prototipo

_Describir brevemente el diseño mecánico del prototipo o maqueta que se requiere construir para el proyecto._

#v(2cm)

// ------------------------------------------------------------
// 2. DISEÑO DE SOFTWARE
// ------------------------------------------------------------

= Diseño de software

_Describir la arquitectura del firmware del microcontrolador que se planea desarrollar._

== Arquitectura y modularización del firmware

_Describir la modularización y jerarquización del firmware, identificando los módulos que interactuarán con los periféricos y aquellos encargados de la planificación y despacho de tareas, temporización y demás funciones del sistema._

#v(2cm)

== Software adicional

_En caso de utilizar software en PC, smartphone o servicios web, realizar una descripción equivalente de su arquitectura, modularización y funcionamiento._

#v(1.5cm)

== Interfaz con el usuario

_Detallar la interfaz con el usuario a implementar —entrada de datos, selección mediante menú, calibración, comandos, etc.— y explicar cómo se utilizará para obtener las distintas prestaciones requeridas._

#v(2cm)

// ------------------------------------------------------------
// 3. ENSAYOS Y AVANCES
// ------------------------------------------------------------

= Ensayos preliminares y avances realizados

_Describir si se desarrolló firmware específico para ensayar distintas funcionalidades del sistema con el objetivo de verificar la viabilidad de la propuesta. No incluir código C en el informe._

_En caso de haberse realizado modelos, cálculos, simulaciones, ensayos o mediciones sobre componentes de hardware y software, describirlos y comentar los resultados obtenidos._

_Agregar fotografías, capturas de pantalla o enlaces a videos cuando corresponda para documentar los avances del proyecto._

#v(3cm)

// ------------------------------------------------------------
// 4. LISTA DE MATERIALES
// ------------------------------------------------------------

= Lista de materiales a adquirir

_Incluir la lista de materiales necesarios para la implementación del proyecto._

#table(
  columns: (0.6fr, 1.8fr, 1.5fr, 0.8fr, 1.4fr, 0.8fr),
  inset: 5pt,
  stroke: 0.5pt,
  align: center + horizon,
  [*Ítem*], [*Componente*], [*Código / modelo*], [*Valor*], [*Formato físico*], [*Cantidad*],
  [], [], [], [], [], [],
  [], [], [], [], [], [],
  [], [], [], [], [], [],
  [], [], [], [], [], [],
  [], [], [], [], [], [],
)

#v(1cm)

// ------------------------------------------------------------
// 5. CRONOGRAMA AJUSTADO
// ------------------------------------------------------------

= Cronograma ajustado

_Presentar el cronograma del proyecto reajustado de acuerdo con el estado actual de avance y las tareas restantes._

#v(4cm)

_Fig. 2: Cronograma actualizado del proyecto._

#v(1cm)

// ------------------------------------------------------------
// 6. TAREAS INDIVIDUALES
// ------------------------------------------------------------

= Tareas individuales realizadas

_Especificar las tareas realizadas hasta la fecha por cada integrante del grupo e indicar las horas invertidas por cada uno._

#table(
  columns: (1.4fr, 3fr, 1fr),
  inset: 5pt,
  stroke: 0.5pt,
  [*Integrante*], [*Tareas realizadas*], [*Horas*],
  [Acuña, Lucia], [], [],
  [Avila Montoya, Eygleen Fernanda], [], [],
  [Bejarano, Abril], [], [],
  [Seijo, Gerónimo], [], [],
)

#v(1cm)

// ------------------------------------------------------------
// 7. TAREAS RESTANTES
// ------------------------------------------------------------

= Tareas restantes

_Detallar las tareas que quedan por realizar para continuar con el desarrollo del proyecto._

#table(
  columns: (3fr, 1.5fr, 1.5fr),
  inset: 5pt,
  stroke: 0.5pt,
  [*Tarea restante*], [*Responsable/s*], [*Fecha / etapa prevista*],
  [], [], [],
  [], [], [],
  [], [], [],
  [], [], [],
)

#v(1cm)

// ------------------------------------------------------------
// 8. DISEÑO DE CIRCUITOS ESQUEMÁTICOS
// ------------------------------------------------------------

= Diseño de circuitos esquemáticos

== Análisis del esquemático de la EDU-CIAA

_Investigar el circuito esquemático de la placa EDU-CIAA, interpretarlo y asociarlo con los componentes físicos presentes en la placa. Utilizar esta información como punto de partida para diseñar el circuito esquemático del proyecto._

#v(2cm)

== Conceptos utilizados en el diseño esquemático

_Realizar un resumen sobre el significado y las características de los siguientes términos utilizados en el diseño de un circuito esquemático: parte, componente o símbolo, referencia, valor, pin, cable, bus, no conexión, etiquetas, puertos, analizador de errores o ERC, netlist, lista de materiales o BOM, grilla, hoja jerárquica, huella o footprint, encapsulado o package y modelo 3D._

#v(2cm)

== Creación de un nuevo componente esquemático

_De acuerdo con la herramienta elegida, investigar cómo crear un nuevo componente esquemático mediante el editor de componentes._

#v(2cm)

== Conectores P1 y P2 de la EDU-CIAA

_Realizar como circuito esquemático un ejemplo que contenga las dos tiras de pines P1 y P2 de la EDU-CIAA correctamente enumeradas y especificadas._

#v(3cm)

_Fig. 3: Esquemático de los conectores P1 y P2 de la EDU-CIAA._

#v(1cm)

// ------------------------------------------------------------
// 9. BIBLIOGRAFÍA
// ------------------------------------------------------------

= Bibliografía

_Incluir las hojas de datos, manuales, documentación técnica y demás bibliografía utilizada durante esta etapa del proyecto._

#v(1cm)

[1] _Referencia._

[2] _Referencia._

[3] _Referencia._
