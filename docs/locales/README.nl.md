<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Klap het scherm dicht, en je bureaublad vouwt zich zachtjes weg.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Softfold voor Mac downloaden">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook met Apple Silicon · macOS 14 of nieuwer · Genotariseerd door Apple</sub>

<sub>Vind je Softfold prettig werken? Een ⭐ op GitHub helpt meer mensen het te ontdekken.</sub>

[English](../../README.md) · Nederlands · [Deutsch](README.de.md) · [Français](README.fr.md) · [🌍 Alle 39 talen](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Klap het scherm dicht, en je bureaublad vouwt zich zachtjes weg.">
  </picture>
</p>

---

Softfold beweegt mee met het scharnier van je MacBook. Als je het scherm laat zakken, helt je actieve bureaublad mee naar achteren, vervaagt geleidelijk van bovenaf en vloeit weg in de donkere randen. Til het scherm weer op en alles keert haarscherp terug, exact zoals je het hebt achtergelaten.

## Download

[Download Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), open het bestand en sleep Softfold naar de map Apps (Applicaties). De app is ondertekend met een Developer ID en genotariseerd door Apple, waardoor hij net zo betrouwbaar opent als elke andere native Mac-app.

Geef bij de eerste start toestemming voor Schermopname in Systeeminstellingen, herstart Softfold indien macOS daarom vraagt en zet de app aan. Voortaan start Softfold automatisch mee op met je Mac en blijft stand-by.

De eerste keer dat je Softfold inschakelt, wordt de huidige hoek van je scherm als openingshoek opgeslagen. Wil je dit later aanpassen, zet het scherm dan in de gewenste stand en klik op **Huidige hoek gebruiken**. Met <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> schakel je het effect overal direct in of uit.

## Geschikte MacBook-modellen

Softfold vereist de dekselhoeksensor die Apple vanaf 2019 inbouwt (op Apple Silicon benaderbaar via de sensor-coprocessor), gecombineerd met macOS 14 of nieuwer. Als je Mac niet over deze sensor beschikt, meldt Softfold dit direct.

| Status | Modellen |
| --- | --- |
| Werkt, bevestigd door gebruikers | 14" en 16" MacBook Pro met M1 Pro of M1 Max (2021), M2 Max (2023), M3 Pro of M3 Max (2023), M4 Pro of M4 Max (2024). MacBook Air met M4 (2025) of M5 |
| Sensor aanwezig, nog niet bevestigd | 14" MacBook Pro met M3, M4 of M5. 14" en 16" MacBook Pro met M5 Pro of M5 Max. MacBook Air met M2 of M3 |
| Niet ondersteund | MacBook Air met M1, alle 13" MacBook Pro's (Intel, M1 en M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, desktop-Macs |

De 16-inch MacBook Pro uit 2019 bevat de sensor eveneens, maar de uitgebrachte versie is uitsluitend gebouwd voor de Apple Silicon-architectuur.

Twijfel je? Voer dit commando uit in Terminal. Een regel die eindigt op «las» betekent dat Softfold je dekselhoek kan uitlezen:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Uitgeprobeerd op een model uit de middelste rij? [Deel je ervaring met ons](https://github.com/ReffWu/softfold/issues).

## Hoe het werkt

Softfold leest de dekselhoek via IOKit HID tot op honderdsten van een graad nauwkeurig uit, exact afgestemd op de verversingsfrequentie van de sensor in plaats van onnodig te pollen. Een kritisch gedempt filter vertaalt deze metingen naar een natuurlijke, vloeiende beweging. Rustig kantelen, zacht vouwen. Snelle beweging, direct wegvouwen. Pauzeer je halverwege even, dan herstelt het bureaublad subtiel zijn scherpte, om weer door te vouwen zodra je verder sluit.

ScreenCaptureKit levert het live bureaublad en Metal berekent het perspectief, de progressieve vervaging en de randvulling met stabiele 60 fps. De schermopname draait alleen tijdens het bewegen of in gevouwen toestand en stopt enkele seconden na het openen, waardoor ook de oranje opname-indicator in macOS dooft. Beelden blijven uitsluitend in het werkgeheugen en worden nooit opgeslagen of verzonden. Eén keer per dag stuurt Softfold een anonieme heartbeat met een willekeurige installatie-ID, app- en macOS-versie, het Mac-model en of het effect die dag is gebruikt, louter om actieve Macs in te schatten. Er worden geen scherminhalten, bestanden, IP-adressen of persoonlijke gegevens opgeslagen. Schakel «Deel anonieme gebruiksstatistieken» in het Softfold-venster uit om dit te deactiveren.

Het volledige bewegingsontwerp vind je in [MOTION.md](../../MOTION.md).

## Ondersteunde talen

Engels, Vereenvoudigd Chinees, Traditioneel Chinees, Japans, Koreaans, Duits, Frans, Spaans, Italiaans, Braziliaans-Portugees, Russisch, Nederlands, Turks, Pools, Arabisch en Vietnamees. Softfold volgt de systeemtaal van je Mac of kan handmatig worden gekozen in het app-venster.

## Bouwen vanuit de broncode

Installeer Xcode en voer uit:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Ontwikkelcontroles staan beschreven in [CHECKS.md](../../CHECKS.md), en ondertekende releases in [RELEASE.md](../../RELEASE.md).

## Bijdragen

Ideeën, probleemmeldingen en pull requests zijn van harte welkom. [Open een issue](https://github.com/ReffWu/softfold/issues) of dien een pull request in.

## Credits

Softfold begon als een fork van [Hinge](https://github.com/Noveum/hinge) door Noveum.ai, uitgegeven onder de MIT-licentie. De HID-identificatoren en het rapportformaat van de dekselhoeksensor werden oorspronkelijk gedocumenteerd door [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licentie

[MIT](../../LICENSE)
