<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Luk skærmen, og dit skrivebord folder sig blidt væk.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Hent Softfold til Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook med Apple Silicon · macOS 14 eller nyere · Notariseret af Apple</sub>

<sub>Hvis du kan lide Softfold, hjælper en ⭐ på GitHub andre med at opdage projektet.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Dansk · [🌍 Flere sprog](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Luk skærmen, og dit skrivebord folder sig blidt væk.">
  </picture>
</p>

---

Softfold følger hængslet på din MacBook. Når du sænker skærmen, vipper dit aktive skrivebord tilbage i samme takt, bliver gradvist sløret fra oven og toner roligt ud i de mørke kanter. Løft skærmen igen, og alt vender krystalklart tilbage, præcis hvor du forlod det.

## Hent appen

[Hent Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), åbn filen, og træk Softfold til mappen Programmer. Appen er signeret med Developer ID og notariseret af Apple, så den åbner trygt og sikkert ligesom alle andre Mac-apps.

Første gang du åbner appen, giver du tilladelse til «Skærmoptagelse» i Systemindstillinger, genstarter Softfold hvis macOS anmoder om det, og slår den til. Herefter starter den automatisk sammen med din Mac og forbliver klar.

Første gang du aktiverer Softfold, registreres skærmens aktuelle vinkel som åbningsvinkel. Hvis du vil ændre det senere, placerer du skærmen i den ønskede position og klikker på **Brug aktuel vinkel**. Genvejen <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> lader dig slå effekten til eller fra når som helst.

## Hvilke MacBook-modeller virker

Softfold kræver den vinkelsensor til skærmlåget, som Apple tilføjede i 2019 (tilgængelig på Apple Silicon via sensorens hjælpeprocessor) samt macOS 14 eller nyere. Hvis din Mac mangler sensoren, giver Softfold dig direkte besked.

| Status | Modeller |
| --- | --- |
| Virker, bekræftet af brugere | 14" og 16" MacBook Pro med M1 Pro eller M1 Max (2021), M2 Max (2023), M3 Pro eller M3 Max (2023), M4 Pro eller M4 Max (2024). MacBook Air med M4 (2025) eller M5 |
| Har sensoren, endnu ikke bekræftet | 14" MacBook Pro med M3, M4 eller M5. 14" og 16" MacBook Pro med M5 Pro eller M5 Max. MacBook Air med M2 eller M3 |
| Understøttes ikke | MacBook Air med M1, alle 13" MacBook Pro (Intel, M1 og M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, stationære Mac-computere |

16-tommer MacBook Pro fra 2019 har også denne sensor, men den udgivne app er udelukkende bygget til Apple Silicon.

I tvivl? Kør denne kommando i Terminal. En linje, der slutter på «las», betyder, at Softfold kan aflæse dit skærmlåg:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Har du prøvet på en model i den midterste række? [Del gerne din oplevelse](https://github.com/ReffWu/softfold/issues).

## Sådan virker det

Softfold aflæser lågets vinkel via IOKit HID med en nøjagtighed på en hundredendedel grad, og synkroniserer med sensorens egen opdateringsfrekvens i stedet for at belaste systemet med unødige forespørgsler. Et kritisk dæmpet filter omsætter målingerne til en organisk, glidende bevægelse. Rolig sænkning giver en blid foldning; hurtig bevægelse giver øjeblikkelig repons. Stopper du et øjeblik halvvejs, genfinder skrivebordet blidt sit fokus, og folder sig videre så snart du fortsætter med at lukke.

ScreenCaptureKit leverer skrivebordsvisningen i realtid, og Metal gengiver perspektivet, den progressive sløring og sidekanternes udfyldning i stabile 60 billeder/sekund. Skærmoptagelsen er kun aktiv mens låget bevæger sig eller er lukket, og stopper få sekunder efter genåbning, hvilket også slukker den orange optagelsesindikator i macOS. Billederne findes udelukkende i din Macs arbejdshukommelse og bliver aldrig gemt på disken eller uploadet. Én gang om dagen sender Softfold et anonymt signal med et tilfældigt installations-ID, app- og macOS-version, Mac-model og om effekten blev anvendt den dag, udelukkende for at vurdere antallet af aktive computere. Der gemmes intet skærmindhold, filer, IP-adresser eller personlige oplysninger. Du kan slå funktionen fra i app-vinduet til enhver tid.

Det komplette bevægelsesdesign kan ses i [MOTION.md](../../MOTION.md).

## Byg fra kildekode

Installer Xcode, og kør:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Udviklingskontroller er beskrevet i [CHECKS.md](../../CHECKS.md), og signerede udgivelser i [RELEASE.md](../../RELEASE.md).

## Bidrag

Ideer, fejlrapporter og pull requests er meget velkomne. [Opret et issue](https://github.com/ReffWu/softfold/issues) eller send en pull request.

## Tak

Softfold begyndte som en fork af [Hinge](https://github.com/Noveum/hinge) af Noveum.ai under MIT-licensen. Lågsensorens HID-identifikatorer og rapportstruktur blev oprindeligt dokumenteret af [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licens

[MIT](../../LICENSE)
