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
#set heading(numbering: "1.1.1.")
#show heading: set text(size: 14pt)

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

  #text(size: 18pt, style: "italic")[Informe de Avance 1]
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
#include "typst/4-diseno-hw.typ"
#include "typst/5-diseno-sw.typ"
#include "typst/6-ensayos-y-avances.typ"
#include "typst/cronograma-y-tareas-2.typ"
#pagebreak()

// ==========================================
// BIBLIOGRAFIA
// ==========================================

= Bibliografía

#[
#set par(justify: false, hanging-indent: 2.2em)

[1] Proyecto CIAA, «EDU-CIAA-NXP — Esquemático jerárquico», Rev. 1.2, 2015, hojas 4 y 5. [En línea]. Disponible en: #link("https://github.com/epernia/firmware_v3/tree/master/documentation/CIAA_Boards/NXP_LPC4337/EDU-CIAA-NXP")

[2] E. Pernia, «EDU-CIAA-NXP v1.1 Board — Pinout», v5r0, 2019. [En línea]. Disponible en: #link("https://github.com/epernia/firmware_v3/tree/master/documentation/CIAA_Boards/NXP_LPC4337/EDU-CIAA-NXP")

[3] NXP Semiconductors, «LPC435x/3x/2x/1x — 32-bit ARM Cortex-M4/M0 microcontroller», Product data sheet, Rev. 5.3. [En línea]. Disponible en: #link("https://www.nxp.com/docs/en/data-sheet/LPC435X_3X_2X_1X.pdf")

[4] NXP Semiconductors, «MFRC522 — Standard performance MIFARE and NTAG frontend», Rev. 3.4. [En línea]. Disponible en: #link("https://www.nxp.com/docs/en/data-sheet/MFRC522.pdf")

[5] DFRobot, «DFPlayer Mini SKU:DFR0299». [En línea]. Disponible en: #link("https://wiki.dfrobot.com/DFPlayer_Mini_SKU_DFR0299")

[6] Allvision Technology, «QG-2864KSWLG01 — 1,3" OLED module (SH1106)», hoja de datos.

[7] Diodes Incorporated, «PAM8403 — Filterless 3 W class-D stereo audio amplifier», 2012. [En línea]. Disponible en: #link("https://www.mouser.com/datasheet/2/115/PAM8403-247318.pdf")

[8] Microchip Technology, «24AA256/24LC256/24FC256 — 256K I2C Serial EEPROM», DS20001203W. [En línea]. Disponible en: #link("https://ww1.microchip.com/downloads/en/DeviceDoc/24AA256-24LC256-24FC256-Data-Sheet-20001203W.pdf")

[9] Kiatronics, «28BYJ-48 — 5V Stepper Motor», hoja de datos. [En línea]. Disponible en: #link("https://www.mouser.com/datasheet/2/758/stepd-01-data-sheet-1143075.pdf")

[10] STMicroelectronics, «ULN2001, ULN2002, ULN2003, ULN2004 — Seven Darlington array», DocID5279 Rev. 14. [En línea]. Disponible en: #link("https://www.st.com/resource/en/datasheet/uln2001.pdf")

[11] Worldsemi, «WS2812B — Intelligent control LED integrated light source». [En línea]. Disponible en: #link("https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf")

[12] onsemi, «2N7000, 2N7002, NDS7002A — N-Channel Enhancement Mode Field Effect Transistor». [En línea]. Disponible en: #link("https://www.onsemi.com/download/data-sheet/pdf/nds7002a-d.pdf")

[13] Adafruit, «Adafruit NeoPixel Überguide — Best Practices». [En línea]. Disponible en: #link("https://learn.adafruit.com/adafruit-neopixel-uberguide/best-practices")

[14] E. Pernia, «sAPI — Referencia de la API». [En línea]. Disponible en: #link("https://github.com/epernia/firmware_v3/blob/master/libs/sapi/documentation/api_reference_es.md")

[15] E. Pernia, «firmware_v3». [En línea]. Disponible en: #link("https://github.com/epernia/firmware_v3")

[16] M. Balboa, «Arduino RFID Library for MFRC522». [En línea]. Disponible en: #link("https://github.com/miguelbalboa/rfid")

[17] Proyecto CIAA, «Computadora Industrial Abierta Argentina». [En línea]. Disponible en: #link("http://www.proyecto-ciaa.com.ar/")

[18] Sino Wealth, «SH1106 — 132 X 64 Dot Matrix OLED/PLED Segment/Common Driver with Controller», V2.3, 2013. [En línea]. Disponible en: #link("https://www.pololu.com/file/0J1813/SH1106.pdf")

[19] KiCad Developers, «KiCad EDA». [En línea]. Disponible en: #link("https://www.kicad.org/")
]

// ==========================================
// APÉNDICES
// ==========================================

#pagebreak()
#set heading(numbering: "A.1.1.", supplement: [Apéndice])
#counter(heading).update(0)
#include "typst/A1-materiales.typ"
#pagebreak(weak: true)
#include "typst/A2-esquematico.typ"