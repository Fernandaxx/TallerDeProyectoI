= Lista de materiales

En la @tab:bom se detalla la lista de materiales necesarios para implementar el proyecto, agrupados por función. Las referencias corresponden al esquemático del poncho; los elementos sin referencia se montan fuera de la placa o se conectan por cable.

#[
#show figure: set block(breakable: true)   // permite partir la tabla entre páginas
#set par(justify: false)                   // evita espacios raros dentro de las celdas
#set text(size: 10pt)
#figure(
  table(
    columns: (0.5fr, 2fr, 1.8fr, 1.3fr, 1.5fr, 0.6fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: (center + horizon, left + horizon, left + horizon, left + horizon, left + horizon, center + horizon),
    table.header(
      [*Ítem*], [*Componente*], [*Código / modelo*], [*Valor*], [*Formato físico*], [*Cant.*],
    ),

    table.cell(colspan: 6, align: center)[_Módulos y placas_],
    [1], [Placa de control], [EDU-CIAA-NXP], [LPC4337], [Placa], [1],
    [2], [Lector RFID/NFC], [Módulo RC522 (MFRC522)], [13,56 MHz], [Módulo], [1],
    [3], [Etiquetas NFC], [NTAG (adhesivas)], [—], [Sticker], [5],
    [4], [Reproductor MP3], [DFPlayer Mini (MP3-TF-16P)], [—], [Módulo 16 pines], [1],
    [5], [Tarjeta de memoria], [microSD, FAT32], [≤ 32 GB], [microSD], [1],
    [6], [Pantalla OLED], [1,3" SH1106, I2C], [128 × 64], [Módulo 4 pines], [1],
    [7], [Amplificador], [Módulo PAM8403 con potenciómetro], [2 × 3 W], [Módulo], [1],
    [8], [Parlante], [—], [4 Ω / 3 W], [—], [2],
    [9], [Potenciómetro deslizante], [Fader B10K], [10 kΩ lineal], [Panel, THT], [1],
    [10], [Motor paso a paso + driver], [28BYJ-48 + módulo ULN2003], [5 V], [Motor + módulo], [1],
    [11], [Tira de LEDs], [WS2812B], [22 LEDs, 5 V], [Tira], [1],

    table.cell(colspan: 6, align: center)[_Alimentación_],
    [12], [Cargador USB], [—], [5 V / 3 A], [Externo], [1],
    [13], [Módulo USB de panel], [USB-A + USB-C, salida JST SM], [5 V / 2 A], [Panel], [1],

    table.cell(colspan: 6, align: center)[_Semiconductores del poncho_],
    [14], [EEPROM I2C (U2)], [24LC256-I/P], [256 kbit], [DIP-8], [1],
    [15], [Zócalo], [—], [8 pines], [DIP-8], [1],
    [16], [MOSFET canal N (Q1)], [2N7000], [—], [TO-92], [1],

    table.cell(colspan: 6, align: center)[_Capacitores_],
    [17], [Electrolítico (C1)], [—], [1000 µF / 16 V], [Radial], [1],
    [18], [Electrolítico (C6, C11, C15)], [—], [470 µF / 16 V], [Radial], [3],
    [19], [Electrolítico (C8)], [—], [100 µF / 16 V], [Radial], [1],
    [20], [Capacitor (C5)], [—], [10 µF], [Radial], [1],
    [21], [Cerámico (C2–C4, C7, C10, C12, C13)], [—], [100 nF], [Disco], [7],
    [22], [Cerámico (C9)], [—], [1 µF], [Disco], [1],
    [23], [Electrolítico (bornes del PAM8403)], [—], [1000 µF / 16 V], [Radial], [1],
    [24], [Cerámico (bornes del PAM8403)], [—], [1 µF], [Disco], [1],

    table.cell(colspan: 6, align: center)[_Resistencias (1/4 W)_],
    [25], [Resistencia (R1, R2, R10)], [—], [1 kΩ], [Axial], [3],
    [26], [Resistencia (R3–R8)], [—], [10 kΩ], [Axial], [6],
    [27], [Resistencia (R9)], [—], [330 Ω], [Axial], [1],

    table.cell(colspan: 6, align: center)[_Conectores y montaje_],
    [28], [Tira de pines macho (P1, P2)], [—], [2 × 20, 2,54 mm], [THT], [2],
    [29], [Tira de pines hembra (DFPlayer)], [—], [1 × 8, 2,54 mm], [THT], [2],
    [30], [Tira de pines hembra (RFID)], [—], [1 × 8, 2,54 mm], [THT], [1],
    [31], [Tira de pines hembra (OLED)], [—], [1 × 4, 2,54 mm], [THT], [1],
    [32], [Tira de pines macho (J1, J2, J5–J11)], [—], [2,54 mm], [THT], [1],
    [33], [Cables Dupont], [Hembra-hembra], [—], [—], [40],
    [34], [Separadores], [Nylon M3], [—], [—], [8],
    [35], [Placa virgen], [Simple faz], [—], [FR-4 o pertinax], [1],
  ),
  caption: [Lista de materiales.],
) <tab:bom>
]
