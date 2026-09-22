<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Stäng locket, och ditt skrivbord viks mjukt undan.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Ladda ner Softfold för Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook med Apple Silicon · macOS 14 eller senare · Notariserad av Apple</sub>

<sub>Om du gillar Softfold hjälper en ⭐ på GitHub andra att upptäcka projektet.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Svenska · [🌍 Fler språk](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Stäng locket, och ditt skrivbord viks mjukt undan.">
  </picture>
</p>

---

Softfold följer gångjärnet på din MacBook. När du sänker skärmen lutar ditt aktiva skrivbord bakåt i takt med rörelsen, blir gradvis suddigt uppifrån och tonar mjukt bort i de mörka sidorna. Fäll upp skärmen igen och allt återvänder knivskarpt, precis där du lämnade det.

## Ladda ner

[Ladda ner Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), öppna filen och dra Softfold till mappen Program. Appen är signerad med Developer ID och notariserad av Apple, så den öppnas tryggt precis som alla andra Mac-appar.

Vid första start ger du tillstånd till Skärminspelning i Systeminställningar, startar om Softfold om macOS ber om det och slår på appen. Därefter startar den automatiskt tillsammans med din Mac och förblir redo i bakgrunden.

Första gången du aktiverar Softfold registreras skärmens nuvarande läge som öppen vinkel. Om du vill ändra det senare ställer du skärmen i önskad vinkel och klickar på **Använd nuvarande vinkel**. Snabbkommandot <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> låter dig slå på eller stänga av effekten när som helst.

## Vilka MacBook-modeller stöds

Softfold kräver den vinkelsensor för locket som Apple introducerade 2019 (tillgänglig på Apple Silicon via sensorns hjälpprocessor) samt macOS 14 eller senare. Om din Mac saknar sensorn meddelar Softfold dig om detta.

| Status | Modeller |
| --- | --- |
| Fungerar, bekräftat av användare | 14" och 16" MacBook Pro med M1 Pro eller M1 Max (2021), M2 Max (2023), M3 Pro eller M3 Max (2023), M4 Pro eller M4 Max (2024). MacBook Air med M4 (2025) eller M5 |
| Har sensorn, ännu inte bekräftat | 14" MacBook Pro med M3, M4 eller M5. 14" och 16" MacBook Pro med M5 Pro eller M5 Max. MacBook Air med M2 eller M3 |
| Stöds inte | MacBook Air med M1, alla 13" MacBook Pro (Intel, M1 och M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, stationära Mac-datorer |

16-tums MacBook Pro från 2019 har också sensorn, men den officiella versionen är enbart kompilerad för Apple Silicon.

Är du osäker? Kör detta kommando i Terminalen. Om en rad slutar med «las» kan Softfold läsa av ditt lock:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Har du provat på en modell i den mellersta raden? [Dela gärna med dig av din upplevelse](https://github.com/ReffWu/softfold/issues).

## Så fungerar det

Softfold läser av lockets vinkel via IOKit HID med en precision på en hundradels grad, synkroniserad med sensorns egen uppdateringsfrekvens. Ett kritiskt dämpat filter förvandlar mätvärdena till en organisk och kontinuerlig rörelse. Långsam sänkning ger en mjuk vikning; snabb rörelse ger omedelbar respons. Pausar du mitt i rörelsen ett ögonblick återfår skrivbordet mjukt sitt fokus, och viks sedan vidare så fort du fortsätter stänga.

ScreenCaptureKit levererar skrivbordsströmmen i realtid och Metal renderar perspektivet, den progressiva oskärpan och sidornas toning i jämna 60 bilder/s. Skärminspelningen körs enbart medan locket rör sig eller är stängt, och avslutas några sekunder efter att skärmen öppnats helt, vilket också släcker macOS orangea inspelningsindikator. Bildrutorna sparas enbart i Macens internminne och varken sparas på disk eller skickas över nätverket. En gång om dagen skickar Softfold en anonym signal med ett slumpmässigt installations-ID, app- och macOS-version, Mac-modell samt om effekten användes under dagen för att uppskatta antalet aktiva enheter. Inget skärminnehåll, filer, IP-adresser eller personuppgifter lagras. Du kan när som helst stänga av «Dela anonym användningsstatistik» i fönstret.

Hela rörelsedesignen finns dokumenterad i [MOTION.md](../../MOTION.md).

## Bygg från källkod

Installera Xcode och kör:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Utvecklingskontroller finns i [CHECKS.md](../../CHECKS.md) och signerade byggen i [RELEASE.md](../../RELEASE.md).

## Bidra

Idéer, felrapporter och pull requests välkomnas varmt. [Skapa ett ärende (issue)](https://github.com/ReffWu/softfold/issues) eller skicka en pull request.

## Tack

Softfold startade som en fork av [Hinge](https://github.com/Noveum/hinge) av Noveum.ai under MIT-licens. Lockets HID-identifierare och rapportlayout dokumenterades ursprungligen av [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licens

[MIT](../../LICENSE)
