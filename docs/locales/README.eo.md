<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Mallevu la ekranon, kaj via labortablo milde faldiĝas.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Elŝuti Softfold por Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Senpaga · MacBook kun Apple Silicon · macOS 14 aŭ pli nova · Notariita de Apple</sub>

<sub>Se Softfold plaĉas al vi, ⭐ en GitHub helpas aliajn malkovri la projekton.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Esperanto · [🌍 Ĉiuj Lingvoj](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Mallevu la ekranon, kaj via labortablo milde faldiĝas.">
  </picture>
</p>

---

Softfold harmonie sekvas la ĉarniron de via MacBook. Dum vi mallevas la ekranon, via viva labortablo kliniĝas malantaŭen kune kun ĝi, iom post iom malklariĝas de supre malsupren kaj milde dissolviĝas en la malhelajn randojn. Levu la ekranon denove, kaj ĉio revenas kristale klara, precize tie, kie vi lasis ĝin.

## Elŝuto

[Elŝutu Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), malfermu la dosieron kaj trenu Softfold en la dosierujon Aplikoj (Applications). La aplikaĵo estas subskribita per Developer ID kaj notariita de Apple, do ĝi malfermiĝas sekure kiel ĉiu indiĝena Mac-aplikaĵo.

Ĉe la unua lanĉo, permesu «Ekranan Registradon» en Sistemaj Agordoj, remalfermu Softfold se macOS tion petas, kaj aktivigu ĝin. Ekde tiam, ĝi aŭtomate funkcios kiam via Mac ekfunkcios.

Kiam vi unuafoje ŝaltas Softfold, la aktuala angulo de la ekrano estas registrita kiel la komenca malferma angulo. Por ŝanĝi ĝin poste, metu la ekranon en la deziratan pozicion kaj alklaku **Uzi Nunajn Angulojn**. La klavkombino <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> ebligas al vi ŝalti aŭ malŝalti la efikon iam ajn.

## Subtenataj modeloj de MacBook

Softfold postulas la kovrilangulan sentilon, kiun Apple aldonis ekde 2019 (atingebla sur Apple Silicon per la sentila kunprocesoro), kaj macOS 14 aŭ pli novan. Se via Mac malhavas ĉi tiun sentilon, Softfold tuj sciigos vin.

| Stato | Modeloj |
| --- | --- |
| Funkcias, konfirmita de uzantoj | 14" kaj 16" MacBook Pro kun M1 Pro aŭ M1 Max (2021), M2 Max (2023), M3 Pro aŭ M3 Max (2023), M4 Pro aŭ M4 Max (2024). MacBook Air kun M4 (2025) aŭ M5 |
| Havas sentilon, ankoraŭ ne konfirmita | 14" MacBook Pro kun M3, M4 aŭ M5. 14" kaj 16" MacBook Pro kun M5 Pro aŭ M5 Max. MacBook Air kun M2 aŭ M3 |
| Ne subtenata | MacBook Air kun M1, ĉiuj 13" MacBook Pro (Intel, M1 kaj M2), MacBook Pro kun Intel, 12" MacBook, MacBook Neo, labortablaj Mac-komputiloj |

La 16-cola MacBook Pro de 2019 ankaŭ havas ĉi tiun sentilon, sed la eldonita versio estas kompilita ekskluzive por la arkitekturo Apple Silicon.

Ĉu vi ne certas? Rulu ĉi tiun komandon en Terminalo. Linio finiĝanta per «las» signifas, ke Softfold povas legi vian sentilon:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Ĉu vi provis ĝin sur modelo en la meza vico? [Kunhavigu vian sperton kun ni](https://github.com/ReffWu/softfold/issues).

## Kiel ĝi funkcias

Softfold legas la angulon per IOKit HID kun precizeco de centono de grado, adaptiĝante al la natura refreŝiga ritmo de la sentilo. Kritike malseketigita filtrilo transformas la mezurojn en organikan, daŭran movon. Malrapida mallevo kreas mildan faldon; rapida movo donas tujan respondon. Se vi paŭzas duonvoje dum sekundo, la labortablo milde reakiras sian klarecon, kaj plufaldiĝas tuj kiam vi daŭrigas fermon.

ScreenCaptureKit provizas la vivan labortablan bildon kaj Metal bildigas la tridimensian perspektivon je stabilaj 60 bildoj/sekundo. La ekrankaptado funkcias nur dum la movo aŭ kiam la ekrano estas faldita, kaj haltas kelkajn sekundojn post la malfermo. Kadroj restas nur en la ĉefmemoro (RAM) de via Mac kaj neniam estas konservataj aŭ alŝutataj. Unufoje tage Softfold sendas anoniman signalon por taksi aktivajn aparatojn. Neniuj personaj datumoj estas kolektataj.

La kompleta mova dezajno estas dokumentita en [MOTION.md](../../MOTION.md).

## Kompili el fontkodo

Instalu Xcode kaj rulu:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Evoluaj kontroloj estas priskribitaj en [CHECKS.md](../../CHECKS.md) kaj subskribitaj eldonoj en [RELEASE.md](../../RELEASE.md).

## Kontribui

Ideo, cimraportoj kaj pull request-oj estas ĉiam bonvenaj. [Malfermu problemon (issue)](https://github.com/ReffWu/softfold/issues) aŭ sendu pull request.

## Dankoj

Softfold komenciĝis kiel forko de [Hinge](https://github.com/Noveum/hinge) de Noveum.ai sub la Permesilo MIT. La identigiloj de la kovrila sentilo estis unue dokumentitaj de la projekto [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Permesilo

[MIT](../../LICENSE)
