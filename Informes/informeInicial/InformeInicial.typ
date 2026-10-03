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
  #image("images/logo_FI-UNLP.png", width: 13cm)
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
    5 de octubre de 2026
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
        *E0306 Taller de Proyecto I* \
        Tocadisco RFID/NFC
      ],
      [Año 2026],
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
// DOCUMENTO
// ==========================================

#include "typst/1-introduccion.typ"
#include "typst/2-objetivos.typ"
#include "typst/3-requerimientos.typ"
#include "typst/4-cronograma-y-tareas.typ"

#pagebreak()

// ==========================================
// BIBLIOGRAFIA
// ==========================================

= Bibliografía

// TODO: completar y verificar las referencias, dando formato según la plantilla.

- [1] Proyecto CIAA, "Computadora Industrial Abierta Argentina". URL: http://www.proyecto-ciaa.com.ar/
- [2] Biblioteca sAPI, EDU-CIAA. URL: https://github.com/epernia/firmware_v3
- [3] DFRobot, "DFPlayer Mini — hoja de datos y comandos". URL: https://wiki.dfrobot.com/DFPlayer_Mini_SKU_DFR0299
- [4] NXP, "MFRC522 — Standard performance MIFARE and NTAG frontend".
- [5] Driver ULN2003 y motor 28BYJ-48 — hojas de datos.
- [6] Controlador SSD1306 / SH1106 para display OLED — hojas de datos.
- [7] Memoria EEPROM I²C 24LC256 (256K / 32K×8) — hoja de datos. // secundario
- [8] Worldsemi, "WS2812B Intelligent control LED integrated light source" — hoja de datos.
