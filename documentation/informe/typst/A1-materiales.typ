= Lista de materiales

En la @tab:bom se detalla la lista de materiales del proyecto, agrupados por función. Para cada componente del poncho se indica su encapsulado y la huella (footprint) que se le asignó en el PCB. Las huellas son de una biblioteca propia (`jukebox`), armada a partir de las de KiCad pero con los pads y orificios de la norma de la cátedra (ver @tab:pcb-reglas). Los elementos sin referencia se montan fuera de la placa y se conectan por cable.

#[
#show figure: set block(breakable: true)   // permite partir la tabla entre páginas
#set par(justify: false)                   // evita espacios raros dentro de las celdas
#set text(size: 9pt)
#show raw: set text(size: 8pt)
#figure(
  table(
    columns: (0.45fr, 2fr, 1.25fr, 1.9fr, 1.75fr, 0.5fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: (center + horizon, left + horizon, left + horizon, left + horizon, left + horizon, center + horizon),
    table.header(
      [*Ítem*], [*Componente (ref.)*], [*Valor*], [*Encapsulado*], [*Huella en el PCB*], [*Cant.*],
    ),

    table.cell(colspan: 6, align: center)[_Módulos y placas_],
    [1], [Placa de control EDU-CIAA-NXP], [LPC4337], [Placa], [—], [1],
    [2], [Lector RFID RC522 (por cable a J4)], [13,56 MHz], [Módulo], [—], [1],
    [3], [Etiquetas NFC NTAG], [—], [Adhesivas], [—], [5],
    [4], [Reproductor DFPlayer Mini (U1)], [MP3-TF-16P], [Módulo de 2 × 8 pines, paso 2,54 mm], [`DFPlayer_Mini`], [1],
    [5], [Tarjeta microSD], [≤ 32 GB, FAT32], [microSD], [—], [1],
    [6], [Pantalla OLED SH1106 (por cable a J3)], [1,3", 128 × 64], [Módulo de 4 pines], [—], [1],
    [7], [Amplificador PAM8403 con potenciómetro (por cable a J6 y J7)], [2 × 3 W], [Módulo de panel], [—], [1],
    [8], [Parlantes], [4 Ω / 3 W], [—], [—], [2],
    [9], [Potenciómetro deslizante (por cable a J10)], [B10K, lineal], [Panel], [—], [1],
    [10], [Motor 28BYJ-48 + módulo ULN2003 (por cable a J8 y J9)], [5 V], [Motor + módulo], [—], [1],
    [11], [Tira de LEDs WS2812B (por cable a J11)], [22 LEDs, 5 V], [Tira], [—], [1],
    [12], [Pulsadores (por cable a J12)], [—], [Panel], [—], [2],

    table.cell(colspan: 6, align: center)[_Alimentación_],
    [13], [Cargador], [5 V / 3 A], [Externo, plug de 2,1 × 5,5 mm], [—], [1],
    [14], [Jack de alimentación (J1)], [2,1 × 5,5 mm], [Jack de chasis para placa, THT], [`BarrelJack_H`], [1],

    table.cell(colspan: 6, align: center)[_Semiconductores_],
    [15], [EEPROM I2C 24LC256-I/P (U2)], [256 kbit], [DIP-8], [`DIP-8_Socket`], [1],
    [16], [MOSFET canal N 2N7000 (Q1)], [—], [TO-92], [`TO-92_Wide`], [1],

    table.cell(colspan: 6, align: center)[_Capacitores_],
    [17], [Electrolítico (C1, C15)], [1000 µF / 16 V], [Radial, Ø 10 mm, paso 5 mm], [`CP_D10_P5.00`], [2],
    [18], [Electrolítico (C6, C11)], [470 µF / 16 V], [Radial, Ø 8 mm, paso 3,5 mm], [`CP_D8_P3.50`], [2],
    [19], [Cerámico (C2, C3, C4, C7, C10, C12, C13)], [100 nF], [Disco, paso 5 mm], [`C_Disc_D4.7_P5.00`], [7],
    [20], [Cerámico (C5)], [10 µF], [Disco o multicapa, paso 5 mm (a confirmar)], [`C_Disc_D4.7_P5.00`], [1],
    [21], [Cerámico (C14, C17)], [10 nF], [Disco, paso 5 mm], [`C_Disc_D4.7_P5.00`], [2],
    [22], [Cerámico (C16, C18)], [1 µF], [Disco, paso 5 mm], [`C_Disc_D5_P5.00`], [2],

    table.cell(colspan: 6, align: center)[_Resistencias (1/4 W)_],
    [23], [Resistencia (R1, R2, R3, R4, R10)], [1 kΩ], [Axial, paso 10,16 mm], [`R_Axial_P10.16`], [5],
    [24], [Resistencia (R5, R6, R7, R8)], [10 kΩ], [Axial, paso 10,16 mm], [`R_Axial_P10.16`], [4],
    [25], [Resistencia (R9)], [330 Ω], [Axial, paso 10,16 mm], [`R_Axial_P10.16`], [1],

    table.cell(colspan: 6, align: center)[_Conectores y montaje_],
    [26], [Tira de pines macho doble para P1 y P2 (XA1)], [44 pines en bloques de 2 × 2, 2 × 3, 2 × 6 y 2 × 7], [Tira doble, paso 2,54 mm], [`Poncho_Grande_Reducido`], [1],
    [27], [Tira de pines hembra para el DFPlayer (U1)], [1 × 8], [Tira simple, paso 2,54 mm], [(huella de U1)], [2],
    [28], [Bornera de salida a P4 (J2)], [2 polos], [Bornera de tornillo, paso 5,08 mm], [`TB_P5.08_1x02`], [1],
    [29], [Tira de pines macho (J4)], [1 × 8], [Tira simple, paso 2,54 mm], [`PinHeader_1x08`], [1],
    [30], [Tira de pines macho (J3, J8)], [1 × 4], [Tira simple, paso 2,54 mm], [`PinHeader_1x04`], [2],
    [31], [Tira de pines macho (J7, J10, J11, J12)], [1 × 3], [Tira simple, paso 2,54 mm], [`PinHeader_1x03`], [4],
    [32], [Tira de pines macho (J5, J6)], [1 × 2], [Tira simple, paso 2,54 mm], [`PinHeader_1x02`], [2],
    [33], [Tira de pines macho (J9)], [1 × 2], [Tira simple, paso 2,54 mm], [`PinHeader_1x02_Robusto` (pads agrandados)], [1],
    [34], [Cables Dupont], [Hembra-hembra], [—], [—], [40],
    [35], [Placa virgen], [Simple faz, al menos 86 × 137 mm], [—], [—], [1],
  ),
  caption: [Lista de materiales con encapsulados y huellas del PCB.],
) <tab:bom>
]
