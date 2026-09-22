<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Baja la pantalla, y tu escritorio se pliega suavemente.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Descargar Softfold para Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook con Apple Silicon · macOS 14 o posterior · Notarizado por Apple</sub>

<sub>Si te gusta Softfold, una ⭐ en GitHub ayuda a que más personas puedan descubrirlo.</sub>

[English](../../README.md) · [Français](README.fr.md) · Español · [Português](README.pt-BR.md) · [🌍 Los 39 idiomas](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Baja la pantalla, y tu escritorio se pliega suavemente.">
  </picture>
</p>

---

Softfold acompaña el movimiento de la bisagra de tu MacBook. Al bajar la pantalla, tu escritorio en tiempo real se reclina junto con ella, se difumina gradualmente desde arriba y se funde en los bordes oscuros. Levanta la pantalla de nuevo y todo vuelve nítido, exactamente donde lo dejaste.

## Descarga

[Descarga Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), abre el archivo y arrastra Softfold a la carpeta Aplicaciones. La app está firmada con Developer ID y notarizada por Apple, abriéndose con total naturalidad como cualquier otra app nativa.

En el primer inicio, permite la Grabación de pantalla en Ajustes del Sistema, vuelve a abrir Softfold si macOS lo solicita y actívalo. A partir de ese momento, se iniciará automáticamente cada vez que enciendas tu Mac y se mantendrá listo para usar.

La primera vez que enciendes Softfold, toma el ángulo de apertura actual de tu pantalla. Para ajustarlo más adelante, coloca la pantalla en la inclinación que prefieras y haz clic en **Usar ángulo actual**. Usa <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> para activarlo o desactivarlo al instante desde cualquier lugar.

## Modelos de MacBook compatibles

Softfold requiere el sensor de ángulo de la tapa que Apple incorporó a partir de 2019 (accesible en Apple Silicon mediante el coprocesador de sensores), además de macOS 14 o posterior. Si tu Mac no dispone de este sensor, Softfold te lo indicará de inmediato.

| Estado | Modelos |
| --- | --- |
| Confirmado y funcional | MacBook Pro de 14" y 16" con M1 Pro o M1 Max (2021), M2 Max (2023), M3 Pro o M3 Max (2023), M4 Pro o M4 Max (2024). MacBook Air con M4 (2025) o M5 |
| Tiene sensor, aún no confirmado | MacBook Pro de 14" con M3, M4 o M5. MacBook Pro de 14" y 16" con M5 Pro o M5 Max. MacBook Air con M2 o M3 |
| No compatible | MacBook Air con M1, todos los MacBook Pro de 13" (Intel, M1 y M2), MacBook Pro con Intel, MacBook de 12", MacBook Neo, Mac de escritorio |

El MacBook Pro de 16 pulgadas de 2019 también cuenta con este sensor, pero esta versión publicada está compilada exclusivamente para la arquitectura Apple Silicon.

¿Tienes dudas? Ejecuta este comando en Terminal. Una línea que termine en «las» significa que Softfold puede comunicarse con el sensor de tu tapa:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

¿Lo probaste en algún modelo de la fila intermedia? [Cuéntanos tu experiencia](https://github.com/ReffWu/softfold/issues).

## Cómo funciona

Softfold lee el ángulo de la tapa a través de IOKit HID con una precisión de centésimas de grado, respetando la cadencia natural de refresco del sensor en lugar de hacer lecturas forzadas. Un filtro con amortiguación crítica transforma estas lecturas en un movimiento fluido y orgánico. Inclinación suave, pliegue suave. Movimiento rápido, pliegue instantáneo. Si te detienes a medio camino durante un segundo, el escritorio recupera el enfoque con delicadeza, y vuelve a plegarse en cuanto continúas cerrando.

ScreenCaptureKit proporciona el escritorio en tiempo real y Metal procesa la perspectiva tridimensional, el desenfoque progresivo y el relleno ambiental a 60 fps constantes. La captura de pantalla solo opera mientras la tapa se está cerrando o permanece plegada, y se detiene instantes después de volver a abrirla por completo, lo que además apaga el indicador naranja de grabación de macOS. Los fotogramas permanecen únicamente en la memoria RAM y jamás se graban ni se suben a ningún servidor. Una vez al día, Softfold envía un pulso anónimo con un identificador de instalación aleatorio, versiones de la app y de macOS, modelo de Mac y si se utilizó el pliegue durante la jornada, con el único objetivo de contabilizar Macs activos. No se almacena ningún contenido de pantalla, archivo, dirección IP ni dato personal. Puedes desactivar «Compartir estadísticas de uso anónimas» en la ventana de Softfold en cualquier momento.

El diseño cinético completo se encuentra detallado en [MOTION.md](../../MOTION.md).

## Idiomas

Inglés, chino simplificado, chino tradicional, japonés, coreano, alemán, francés, español, italiano, portugués de Brasil, ruso, neerlandés, turco, polaco, árabe y vietnamita. Softfold se adapta automáticamente al idioma de tu Mac o puedes seleccionarlo manualmente en la ventana de la app.

## Compilar desde el código fuente

Instala Xcode y ejecuta:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Las comprobaciones de desarrollo están descritas en [CHECKS.md](../../CHECKS.md), y las versiones firmadas en [RELEASE.md](../../RELEASE.md).

## Contribuir

Ideas, reportes de fallos y pull requests son siempre bienvenidos. [Abre un issue](https://github.com/ReffWu/softfold/issues) o envía un pull request.

## Créditos

Softfold nació como una bifurcación de [Hinge](https://github.com/Noveum/hinge) de Noveum.ai, publicado bajo la licencia MIT. Los identificadores HID del sensor de la tapa y el formato del reporte fueron documentados por primera vez en [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licencia

[MIT](../../LICENSE)
