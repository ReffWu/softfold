<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Klappe das Display zu, und dein Schreibtisch faltet sich sanft zurück.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Softfold für Mac herunterladen">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Kostenlos · MacBook mit Apple Silicon · macOS 14 oder neuer · Von Apple beglaubigt</sub>

<sub>Wenn dir Softfold gefällt, hilft ein ⭐ auf GitHub dabei, dass noch mehr Menschen die App entdecken.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · Deutsch · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · [Polski](README.pl.md) · [العربية](README.ar.md) · [Tiếng Việt](README.vi.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Klappe das Display zu, und dein Schreibtisch faltet sich sanft zurück.">
  </picture>
</p>

---

Softfold folgt dem Scharnier deines MacBook. Senkst du den Bildschirm ab, neigt sich dein aktiver Schreibtisch synchron mit nach hinten, wird von oben her weichgezeichnet und blendet in die dunklen Ränder über. Hebst du ihn wieder an, kehrt alles gestochen scharf und exakt an seinen ursprünglichen Platz zurück.

## Download

[Softfold.dmg herunterladen](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), die Datei öffnen und Softfold in den Ordner „Programme“ ziehen. Die App ist mit einer Developer-ID signiert und von Apple beglaubigt (notarisiert), sodass sie sich wie jede native Mac-App sicher öffnen lässt.

Erlaube beim ersten Start die Bildschirmaufnahme in den Systemeinstellungen, öffne Softfold bei Aufforderung erneut und aktiviere den Effekt. Danach startet Softfold bei jedem Hochfahren deines Mac automatisch im Hintergrund.

Beim ersten Aktivieren übernimmt Softfold den aktuellen Winkel deines Displays als Ausgangswert. Um ihn später anzupassen, bringe den Bildschirm in deine bevorzugte Position und klicke auf **Aktuellen Winkel verwenden**. Mit <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> kannst du den Effekt jederzeit ein- oder ausschalten.

## Unterstützte MacBook-Modelle

Softfold benötigt den Deckelwinkelsensor, den Apple seit 2019 verbaut (auf Apple-Silicon-Geräten über den Sensor-Coprozessor angebunden), sowie macOS 14 oder neuer. Verfügt dein Mac über keinen solchen Sensor, weist Softfold dich direkt darauf hin.

| Status | Modelle |
| --- | --- |
| Funktioniert, von Nutzern bestätigt | 14" und 16" MacBook Pro mit M1 Pro oder M1 Max (2021), M2 Max (2023), M3 Pro oder M3 Max (2023), M4 Pro oder M4 Max (2024). MacBook Air mit M4 (2025) oder M5 |
| Sensor vorhanden, noch unbestätigt | 14" MacBook Pro mit M3, M4 oder M5. 14" und 16" MacBook Pro mit M5 Pro oder M5 Max. MacBook Air mit M2 oder M3 |
| Nicht unterstützt | MacBook Air mit M1, alle 13" MacBook Pro (Intel, M1 und M2), Intel-MacBook Pro, 12" MacBook, MacBook Neo, Desktop-Macs |

Auch das 16" MacBook Pro von 2019 besitzt den Sensor, die veröffentlichte Version ist jedoch ausschließlich für Apple Silicon optimiert.

Nicht sicher? Führe diesen Befehl im Terminal aus. Eine Zeile mit „las“ am Ende bedeutet, dass Softfold den Sensor deines Deckels auslesen kann:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Auf einem Modell aus der mittleren Zeile ausprobiert? [Teile deine Erfahrung mit uns](https://github.com/ReffWu/softfold/issues).

## Funktionsweise

Softfold liest den Deckelwinkel über IOKit HID mit einer Präzision von Hundertstelgrad direkt aus und folgt dabei der Sensorfrequenz, statt blind abzufragen. Ein kritisch gedämpfter Filter verwandelt die Rohwerte in organische, kontinuierliche Bewegungen. Langsames Senken, sanftes Falten. Schnelles Absenken, rasches Wegfalten. Verweilst du kurz auf halbem Weg, gewinnt der Schreibtisch sanft an Schärfe zurück und faltet sich weiter, sobald du das Display weiter schließt.

ScreenCaptureKit liefert den Live-Desktop, während Metal die räumliche Perspektive, den progressiven Blur und den seitlichen Übergang mit flüssigen 60 fps rendert. Die Erfassung läuft nur beim Schließen oder im gefalteten Zustand und stoppt wenige Sekunden nach dem erneuten Öffnen – wodurch auch der macOS-Aufnahmeindikator wieder erlischt. Sämtliche Frames verbleiben ausschließlich im Arbeitsspeicher deines Mac und werden weder aufgezeichnet noch übertragen. Einmal täglich sendet Softfold einen anonymen Heartbeat mit einer zufälligen Installations-ID, App- und macOS-Version, Mac-Modell sowie der Information, ob die Faltung an jenem Tag aktiv genutzt wurde, um aktive Installationen zu schätzen. Es werden keinerlei Bildschirminhalte, Dateien, IP-Adressen oder persönliche Daten erfasst. Deaktiviere einfach „Anonyme Nutzungsstatistiken teilen“ im Softfold-Fenster, um dies zu stoppen.

Das vollständige Motion-Design findest du in [MOTION.md](MOTION.md).

## Sprachen

Englisch, vereinfachtes Chinesisch, traditionelles Chinesisch, Japanisch, Koreanisch, Deutsch, Französisch, Spanisch, Italienisch, brasilianisches Portugiesisch, Russisch, Niederländisch, Türkisch, Polnisch, Arabisch und Vietnamesisch. Softfold passt sich der Systemsprache deines Mac an oder lässt sich im App-Fenster manuell wählen.

## Aus dem Quellcode bauen

Xcode installieren, danach:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Entwicklungsprüfungen sind in [CHECKS.md](CHECKS.md) dokumentiert, signierte Builds in [RELEASE.md](RELEASE.md).

## Mitwirken

Ideen, Fehlerberichte und Pull Requests sind herzlich willkommen. [Erstelle ein Issue](https://github.com/ReffWu/softfold/issues) oder sende einen Pull Request.

## Danksagung

Softfold begann als Fork von [Hinge](https://github.com/Noveum/hinge) von Noveum.ai, veröffentlicht unter der MIT-Lizenz. Die HID-Kennungen und das Berichtsformat des Deckelsensors wurden erstmals von [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor) dokumentiert.

## Lizenz

[MIT](LICENSE)
