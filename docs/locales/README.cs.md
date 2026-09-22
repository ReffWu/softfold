<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Přivřete víko a vaše plocha se jemně složí.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Stáhnout Softfold pro Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Zdarma · MacBook s Apple Silicon · macOS 14 nebo novější · Notářsky ověřeno společností Apple</sub>

<sub>Pokud se vám Softfold líbí, ⭐ na GitHubu pomůže dalším lidem objevit tento projekt.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Čeština · [🌍 Všechny jazyky](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Přivřete víko a vaše plocha se jemně složí.">
  </picture>
</p>

---

Softfold věrně kopíruje pohyb pantu vašeho MacBooku. Když sklápíte displej, vaše živá plocha se naklání vzad společně s ním, odshora se postupně rozostřuje a přirozeně se vpíjí do tmavých okrajů. Zvedněte víko a vše je okamžitě zpět, dokonale ostré a přesně tam, kde jste skončili.

## Stažení

[Stáhněte si Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), otevřete soubor a přetáhněte aplikaci Softfold do složky Aplikace. Aplikace je podepsána certifikátem Developer ID a notářsky ověřena společností Apple, takže ji otevřete spolehlivě jako kterýkoli nativní program.

Při prvním spuštění povolte «Záznam obrazovky» v Nastavení systému, v případě vyzvání systémem macOS aplikaci znovu otevřete a zapněte ji. Od této chvíle se bude Softfold automaticky spouštět se startem vašeho Macu a zůstane v pohotovosti.

Při prvním zapnutí Softfold uloží stávající náklon víka jako výchozí úhel otevření. Pokud jej chcete později upravit, nastavte displej do vyhovující polohy a klikněte na **Použít aktuální úhel**. Zkratka <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> umožňuje efekt kdykoli zapnout nebo vypnout.

## Které modely MacBooku jsou podporovány

Softfold vyžaduje senzor úhlu víka, který Apple instaluje od roku 2019 (v čipech Apple Silicon obsluhovaný koprocesorem senzorů), a systém macOS 14 nebo novější. Pokud váš Mac tento senzor nemá, Softfold vás o tom ihned informuje.

| Stav | Modely |
| --- | --- |
| Funguje, potvrzeno uživateli | 14" a 16" MacBook Pro s M1 Pro nebo M1 Max (2021), M2 Max (2023), M3 Pro nebo M3 Max (2023), M4 Pro nebo M4 Max (2024). MacBook Air s M4 (2025) nebo M5 |
| Má senzor, dosud nepotvrzeno | 14" MacBook Pro s M3, M4 nebo M5. 14" a 16" MacBook Pro s M5 Pro nebo M5 Max. MacBook Air s M2 nebo M3 |
| Nepodporováno | MacBook Air s M1, všechny 13" MacBooky Pro (Intel, M1 a M2), MacBooky Pro s procesory Intel, 12" MacBook, MacBook Neo, stolní počítače Mac |

16palcový MacBook Pro z roku 2019 má tento senzor také, avšak vydaná aplikace je sestavena výhradně pro architekturu Apple Silicon.

Nejste si jistí? Spusťte tento příkaz v Terminálu. Řádek končící na «las» znamená, že Softfold dokáže číst data z vašeho víka:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Vyzkoušeli jste aplikaci na modelu z prostředního řádku? [Podělte se s námi o zkušenosti](https://github.com/ReffWu/softfold/issues).

## Jak to funguje

Softfold snímá úhel víka přes IOKit HID s přesností na setiny stupně a plně se přizpůsobuje vlastní obnovovací frekvenci senzoru. Kriticky tlumený filtr převádí surové hodnoty do organického, plynulého pohybu. Pomalé sklápění znamená jemné složení; rychlý pohyb přináší okamžitou reakci. Zastavíte-li se na okamžik v půli cesty, plocha plynule získá zpět svou ostrost a znovu se začne skládat, jakmile pokračujete v zavírání.

ScreenCaptureKit zprostředkovává živý obraz plochy a Metal renderuje prostorovou perspektivu, progresivní rozostření i tmavé okraje při stabilních 60 snímcích/s. Záznam obrazovky je aktivní výhradně při pohybu víka nebo ve složeném stavu a ukončí se několik sekund po úplném otevření, což zhasne i oranžový indikátor nahrávání v macOS. Snímky zůstávají pouze v operační paměti Macu a nikdy se neukládají na disk ani nepřenášejí přes síť. Softfold jednou denně odešle anonymní statistický signál s náhodným ID instalace za účelem odhadu aktivních zařízení. Neukládá se žádný obsah obrazovky, soubory, IP adresy ani osobní údaje. Funkci můžete v okně aplikace kdykoli vypnout.

Kompletní kinetický design naleznete v dokumentu [MOTION.md](../../MOTION.md).

## Sestavení ze zdrojových kódů

Nainstalujte Xcode a spusťte:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Vývojářské kontroly jsou popsány v [CHECKS.md](../../CHECKS.md) a podepsaná vydání v [RELEASE.md](../../RELEASE.md).

## Zapojení do vývoje

Nápady, hlášení chyb i pull requesty jsou srdečně vítány. [Otevřete issue](https://github.com/ReffWu/softfold/issues) nebo pošlete pull request.

## Poděkování

Projekt Softfold vznikl jako fork aplikace [Hinge](https://github.com/Noveum/hinge) od Noveum.ai pod licencí MIT. Identifikátory HID senzoru víka a strukturu hlášení poprvé zdokumentoval projekt [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licence

[MIT](../../LICENSE)
