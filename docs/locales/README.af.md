<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Laat sak die skerm, en jou werkskerm vou sagkens weg.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Laai Softfold af vir Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook met Apple Silicon · macOS 14 of nuwer · Deur Apple genotariseer</sub>

<sub>As jy van Softfold hou, help 'n ⭐ op GitHub ander om die projek te ontdek.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Afrikaans · [🌍 Alle Tale](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Laat sak die skerm, en jou werkskerm vou sagkens weg.">
  </picture>
</p>

---

Softfold volg die skarnier van jou MacBook op 'n heeltemal natuurlike manier. Soos jy die skerm laat sak, leun jou lewendige werkskerm saam agtertoe, raak geleidelik dof van bo na onder en vervaag in die donker kante. Lig die skerm weer op, en alles keer vlymskerp terug, presies waar jy dit gelos het.

## Aflaai

[Laai Softfold.dmg af](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), maak die lêer oop en sleep Softfold na die Toepassings-vouer (Applications). Die toepassing is met 'n Developer ID onderteken en deur Apple genotariseer, so dit open veilig soos enige ander Mac-toepassing.

Gee met die eerste bekendstelling toestemming vir «Skermopname» in Stelselinstellings, heropen Softfold as macOS dit versoek, en skakel dit aan. Van daar af sal dit outomaties saam met jou Mac begin.

Die eerste keer wat jy Softfold aanskakel, word die huidige skermhoek as oophoudende verwysingshoek gestoor. Om dit later te verander, plaas die deksel in die gewenste posisie en klik op **Gebruik Huidige Hoek**. Die kortpad <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> stel jou in staat om die effek enige tyd aan of af te skakel.

## Ondersteunde MacBook-modelle

Softfold benodig die dekselhoeksensor wat Apple sedert 2019 ingebou het (toeganklik op Apple Silicon via die sensor-koprosessor) en macOS 14 of nuwer. As jou Mac nie die sensor het nie, sal Softfold jou dadelik inlig.

| Status | Modelle |
| --- | --- |
| Werk, bevestig deur gebruikers | 14" en 16" MacBook Pro met M1 Pro of M1 Max (2021), M2 Max (2023), M3 Pro of M3 Max (2023), M4 Pro of M4 Max (2024). MacBook Air met M4 (2025) of M5 |
| Het die sensor, nog nie bevestig | 14" MacBook Pro met M3, M4 of M5. 14" en 16" MacBook Pro met M5 Pro of M5 Max. MacBook Air met M2 of M3 |
| Word nie ondersteun nie | MacBook Air met M1, alle 13" MacBook Pro's (Intel, M1 en M2), Intel MacBook Pro's, 12" MacBook, MacBook Neo, lessenaar-Macs |

Die 16-duim MacBook Pro van 2019 het ook hierdie sensor, maar die amptelike weergawe is uitsluitlik vir Apple Silicon saamgestel.

Onseker? Voer hierdie opdrag in Terminal uit. 'n Reël wat eindig op «las» beteken dat Softfold jou deksel kan lees:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Het jy dit op 'n model in die middelste ry probeer? [Deel jou ervaring met ons](https://github.com/ReffWu/softfold/issues).

## Hoe dit werk

Softfold lees die dekselhoek via IOKit HID tot 'n honderdste van 'n graad akkuraat, aangepas by die sensor se natuurlike verversingsfrekwensie. 'n Krities gedempte filter omskep die data in 'n gladde, natuurlike beweging. Stadige kanteling skep 'n sagte vou; vinnige beweging gee 'n onmiddellike reaksie. As jy halfpad vir 'n sekonde stilhou, herstel die werkskerm sy skerpte, en vou weer sodra jy aanhou toemaak.

ScreenCaptureKit verskaf die intydse werkskerm en Metal verwerk die perspektief en dofheid teen 'n bestendige 60 rps. Die opname loop slegs tydens beweging of in gevoude toestand en stop enkele sekondes na heropening. Beelde bly slegs in die RAM en word nooit gestoor of opgelaai nie. Daagliks stuur Softfold 'n anonieme sein om aktiewe toestelle te skat. Geen persoonlike data word versamel nie.

Die volledige bewegingsontwerp is beskikbaar in [MOTION.md](../../MOTION.md).

## Bou vanaf bronkode

Installeer Xcode en voer uit:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Ontwikkelingskontroles is in [CHECKS.md](../../CHECKS.md) en getekende weergawes in [RELEASE.md](../../RELEASE.md).

## Bydraes

Idees, foutverslae en pull requests is altyd baie welkom. [Maak 'n issue oop](https://github.com/ReffWu/softfold/issues) of stuur 'n pull request.

## Erkenning

Softfold het begin as 'n vurk (fork) van [Hinge](https://github.com/Noveum/hinge) deur Noveum.ai onder die MIT-lisensie. Dekselsensor-identifiseerders is eers deur die [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor)-projek gedokumenteer.

## Lisensie

[MIT](../../LICENSE)
