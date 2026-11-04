= Esquemático completo

El esquemático completo del poncho se realizó en KiCad @kicad. Para el DFPlayer se creó un símbolo propio; la EEPROM y el transistor 2N7000 (Q1) usan símbolos de la biblioteca estándar, y el resto de los módulos se representa mediante su conector. Las conexiones entre bloques se realizan con etiquetas globales. El verificador de reglas eléctricas (ERC) no reporta errores ni advertencias.

#figure(
  rotate(-90deg, reflow: true, image("../images/esquematico.png", width: 18.5cm)),
  caption: [Circuito esquemático completo del poncho.],
) <fig:esquematico>
