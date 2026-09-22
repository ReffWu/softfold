<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Lukk lokket, og skrivebordet ditt folder seg mykt unna.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Last ned Softfold for Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook med Apple Silicon · macOS 14 eller nyere · Notarisert av Apple</sub>

<sub>Hvis du liker Softfold, hjelper en ⭐ på GitHub andre med å oppdage prosjektet.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Norsk · [🌍 Flere språk](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Lukk lokket, og skrivebordet ditt folder seg mykt unna.">
  </picture>
</p>

---

Softfold følger hengslet på din MacBook. Når du senker skjermen, lener det levende skrivebordet seg bakover i samme takt, blir gradvis uskarpt ovenfra og svinner rolig inn i de mørke kantene. Løft skjermen opp igjen, og alt kommer tilbake krystallklart, akkurat der du slapp det.

## Nedlasting

[Last ned Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), åpne filen og dra Softfold til Programmer-mappen. Appen er signert med Developer ID og notarisert av Apple, slik at den åpnes trygt som en hvilken som helst Mac-app.

Ved første oppstart gir du tillatelse til «Skjermopptak» i Systeminnstillinger, starter Softfold på nytt dersom macOS ber om det, og slår den på. Deretter starter appen automatisk når Mac-en starter og holder seg klar.

Første gang du aktiverer Softfold, registreres skjermens nåværende posisjon som utgangsvinkel. For å endre den senere, plasserer du lokket i ønsket vinkel og klikker på **Bruk gjeldende vinkel**. Snarveien <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> lar deg slå effekten av og på når som helst.

## Hvilke MacBook-modeller som støttes

Softfold krever sensoren for lokkvinkel som Apple introduserte i 2019 (tilgjengelig på Apple Silicon via sensorens koprosessor) samt macOS 14 eller nyere. Hvis Mac-en din mangler sensoren, gir Softfold beskjed om dette.

| Status | Modeller |
| --- | --- |
| Fungerer, bekreftet av brukere | 14" og 16" MacBook Pro med M1 Pro eller M1 Max (2021), M2 Max (2023), M3 Pro eller M3 Max (2023), M4 Pro eller M4 Max (2024). MacBook Air med M4 (2025) eller M5 |
| Har sensor, ennå ikke bekreftet | 14" MacBook Pro med M3, M4 eller M5. 14" og 16" MacBook Pro med M5 Pro eller M5 Max. MacBook Air med M2 eller M3 |
| Støttes ikke | MacBook Air med M1, alle 13" MacBook Pro (Intel, M1 og M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, stasjonære Macer |

16-tommers MacBook Pro fra 2019 har også denne sensoren, men den publiserte versjonen er bygget utelukkende for Apple Silicon.

Usikker? Kjør denne kommandoen i Terminal. En linje som slutter på «las» betyr at Softfold kan lese av lokket ditt:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Prøvde du på en modell i den midterste raden? [Fortell oss hvordan det gikk](https://github.com/ReffWu/softfold/issues).

## Hvordan det fungerer

Softfold leser lokkvinkelen via IOKit HID med en nøyaktighet på hundredels grader, og tilpasser seg sensorens egen oppdateringsfrekvens i stedet for å overbelaste systemet. Et kritisk dempet filter forvandler avlesningene til en organisk, kontinuerlig bevegelse. Rolig bevegelse gir myk folding; rask bevegelse gir umiddelbar reaksjon. Pauser du halvveis et øyeblikk, gjenvinner skrivebordet mykt skarpheten, og folder seg videre så snart du fortsetter å lukke.

ScreenCaptureKit leverer skrivebordsstrømmen i sanntid, mens Metal gjengir perspektivet, den progressive uskarpheten og sidekantene i stabile 60 bilder per sekund. Skjermopptaket er bare aktivt mens lokket lukkes eller er foldet, og stopper noen sekunder etter at lokket åpnes igjen, noe som også slukker den oransje opptaksindikatoren i macOS. Bildene forblir utelukkende i minnet på din Mac og blir aldri lagret eller lastet opp. Én gang om dagen sender Softfold et anonymt signal med en tilfeldig installasjons-ID, app- og macOS-versjon, Mac-modell samt informasjon om effekten ble brukt den dagen, utelukkende for å anslå antall aktive enheter. Ingenting fra skjermen, filer, IP-adresser eller personopplysninger lagres. Du kan når som helst slå av «Del anonym bruksstatistikk» i appvinduet.

Hele bevegelsesdesignet er beskrevet i [MOTION.md](../../MOTION.md).

## Bygg fra kildekode

Installer Xcode, og kjør deretter:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Utviklingssjekker er beskrevet i [CHECKS.md](../../CHECKS.md), og signerte utgivelser i [RELEASE.md](../../RELEASE.md).

## Bidra

Ideer, feilrapporter og pull-forespørsler er hjertelig velkomne. [Opprett en sak (issue)](https://github.com/ReffWu/softfold/issues) eller send inn en pull-forespørsel.

## Takk

Softfold startet som en forgrening av [Hinge](https://github.com/Noveum/hinge) av Noveum.ai under MIT-lisensen. Sensorens HID-identifikatorer og rapportstruktur ble først dokumentert av [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Lisens

[MIT](../../LICENSE)
