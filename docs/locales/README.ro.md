<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Coboară ecranul, iar biroul tău se pliază lin.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Descarcă Softfold pentru Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratuit · MacBook cu Apple Silicon · macOS 14 sau mai recent · Notarizat de Apple</sub>

<sub>Dacă îți place Softfold, o ⭐ pe GitHub îi ajută pe alții să descopere proiectul.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Română · [🌍 Toate limbile](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Coboară ecranul, iar biroul tău se pliază lin.">
  </picture>
</p>

---

Softfold urmărește fidel balamaua MacBook-ului tău. Pe măsură ce cobori ecranul, biroul tău activ se înclină înapoi odată cu el, devine treptat difuz de sus în jos și se estompează în marginile întunecate. Ridică din nou ecranul și totul revine impecabil, exact acolo unde ai lăsat.

## Descărcare

[Descarcă Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), deschide fișierul și trage Softfold în dosarul Aplicații (Applications). Aplicația este semnată cu un Developer ID și notarizată de Apple, deschizându-se în deplină siguranță ca orice aplicație nativă de Mac.

La prima lansare, permite accesul la «Înregistrare ecran» în Configurări sistem, redeschide Softfold dacă macOS solicită acest lucru și activează-l. De atunci înainte, va porni automat odată cu Mac-ul tău.

Prima dată când activezi Softfold, unghiul actual al ecranului devine unghiul de deschidere memorat. Pentru a-l modifica ulterior, poziționează ecranul în unghiul preferat și apasă pe **Utilizează unghiul curent**. Scurtătura <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> îți permite să activezi sau să dezactivezi efectul oricând.

## Ce modele de MacBook sunt compatibile

Softfold necesită senzorul de unghi al capacului introdus de Apple din 2019 (accesibil pe cipurile Apple Silicon prin coprocesorul de senzori) și macOS 14 sau mai recent. Dacă Mac-ul tău nu are acest senzor, Softfold te anunță imediat.

| Stare | Modele |
| --- | --- |
| Funcțional, confirmat de utilizatori | MacBook Pro de 14" și 16" cu M1 Pro sau M1 Max (2021), M2 Max (2023), M3 Pro sau M3 Max (2023), M4 Pro sau M4 Max (2024). MacBook Air cu M4 (2025) sau M5 |
| Senzor prezent, încă neconfirmat | MacBook Pro de 14" cu M3, M4 sau M5. MacBook Pro de 14" și 16" cu M5 Pro sau M5 Max. MacBook Air cu M2 sau M3 |
| Neacceptat | MacBook Air cu M1, toate modelele MacBook Pro de 13" (Intel, M1 și M2), MacBook Pro cu Intel, MacBook de 12", MacBook Neo, Mac-uri desktop |

MacBook Pro de 16 inchi din 2019 dispune de asemenea de acest senzor, însă versiunea publicată este compilată exclusiv pentru arhitectura Apple Silicon.

Nu ești sigur? Rulează această comandă în Terminal. Un rând care se termină în «las» indică faptul că Softfold poate citi unghiul capacului tău:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Ai încercat pe un model din rândul din mijloc? [Spune-ne cum a funcționat](https://github.com/ReffWu/softfold/issues).

## Cum funcționează

Softfold citește unghiul capacului prin IOKit HID cu o precizie de sutimi de grad, adaptându-se la ritmul nativ de împrospătare al senzorului. Un filtru cu amortizare critică transformă aceste măsurători într-o mișcare cursivă și organică. O coborâre lentă creează o pliere delicată; o mișcare rapidă oferă o reacție imediată. Dacă faci o scurtă pauză la jumătatea cursei, biroul își recapătă lin claritatea, continuând plierea de îndată ce reiei închiderea.

ScreenCaptureKit furnizează fluxul biroului în timp real, iar motorul Metal randează perspectiva, estomparea progresivă și marginile ambientale la o rată stabilă de 60 cps. Captura de ecran funcționează doar în timpul mișcării capacului sau când este pliat și se oprește la câteva secunde după redeschiderea completă, ceea ce stinge și indicatorul portocaliu de înregistrare din macOS. Cadrele rămân exclusiv în memoria RAM și nu sunt salvate pe disc sau transmise pe internet. O dată pe zi, Softfold trimite un semnal anonim cu un ID aleatoriu pentru a estima numărul de Mac-uri active. Nu se stochează conținut de pe ecran, fișiere, adrese IP sau date personale. Poți dezactiva această funcție în fereastra aplicației oricând.

Designul complet al animației este descris în [MOTION.md](../../MOTION.md).

## Compilare din codul sursă

Instalează Xcode și execută:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Verificările de dezvoltare sunt prezentate în [CHECKS.md](../../CHECKS.md), iar versiunile semnate în [RELEASE.md](../../RELEASE.md).

## Contribuții

Ideile, raportările de erori și pull request-urile sunt binevenite. [Deschide o problemă (issue)](https://github.com/ReffWu/softfold/issues) sau trimite un pull request.

## Mulțumiri

Softfold a început ca o bifurcație (fork) a proiectului [Hinge](https://github.com/Noveum/hinge) de la Noveum.ai sub licența MIT. Identificatorii HID ai senzorului de capac și structura rapoartelor au fost documentate pentru prima dată de proiectul [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licență

[MIT](../../LICENSE)
