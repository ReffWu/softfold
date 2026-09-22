<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Ibaba ang takip, at banayad na matitiklop ang iyong desktop.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="I-download ang Softfold para sa Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Libre · MacBook na may Apple Silicon · macOS 14 o mas bago · Notarized ng Apple</sub>

<sub>Kung nagustuhan mo ang Softfold, makatutulong ang ⭐ sa GitHub para matuklasan ito ng iba.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Filipino · [🌍 Lahat ng Wika](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Ibaba ang takip, at banayad na matitiklop ang iyong desktop.">
  </picture>
</p>

---

Sumusunod ang Softfold sa bisagra ng iyong MacBook. Habang ibinababa mo ang screen, ang iyong live desktop ay sumasabay sa paghilig paurong, dahan-dahang lumalabo mula sa itaas pababa at banayad na humahalo sa madidilim na gilid. Iangat muli ang screen at babalik ang lahat nang malinaw, eksakto kung saan mo ito iniwan.

## Pag-download

[I-download ang Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), buksan ang file at i-drag ang Softfold sa folder ng Applications. Ang app ay nilagdaan gamit ang Developer ID at notarized ng Apple, kaya bubukas ito nang ligtas tulad ng iba pang Mac app.

Sa unang pagbubukas, payagan ang «Pag-record ng Screen» sa Mga Setting ng System, muling buksan ang Softfold kung hihilingin ng macOS, at i-on ito. Mula noon, awtomatiko na itong magsisimula kasabay ng iyong Mac.

Sa unang pagkakataong i-on mo ang Softfold, ang kasalukuyang anggulo ng takip ang magiging batayan ng pagkabukas. Upang baguhin ito mamaya, ilagay ang takip sa nais na posisyon at i-click ang **Gamitin ang Kasalukuyang Anggulo**. Ang shortcut na <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> ay nagbibigay-daan sa iyo na i-on o i-off ang epekto anumang oras.

## Mga Suportadong Modelo ng MacBook

Kinakailangan ng Softfold ang lid angle sensor na idinagdag ng Apple mula noong 2019 (magagamit sa Apple Silicon sa pamamagitan ng sensor co-processor) at macOS 14 o mas bago. Kung walang sensor ang iyong Mac, aabisuhan ka agad ng Softfold.

| Katayuan | Mga Modelo |
| --- | --- |
| Gumagana, kinumpirma ng mga gumagamit | 14" at 16" MacBook Pro na may M1 Pro o M1 Max (2021), M2 Max (2023), M3 Pro o M3 Max (2023), M4 Pro o M4 Max (2024). MacBook Air na may M4 (2025) o M5 |
| May sensor, hindi pa nakukumpirma | 14" MacBook Pro na may M3, M4 o M5. 14" at 16" MacBook Pro na may M5 Pro o M5 Max. MacBook Air na may M2 o M3 |
| Hindi suportado | MacBook Air na may M1, lahat ng 13" MacBook Pro (Intel, M1 at M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, desktop Mac |

Ang 16-inch MacBook Pro ng 2019 ay mayroon ding sensor na ito, ngunit ang opisyal na bersyon ay binuo lamang para sa arkitektura ng Apple Silicon.

Hindi sigurado? Patakbuhin ang command na ito sa Terminal. Ang linyang nagtatapos sa «las» ay nangangahulugang nababasa ng Softfold ang iyong takip:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Nasubukan mo na ba sa isang modelo sa gitnang hanay? [Ibahagi ang iyong karanasan](https://github.com/ReffWu/softfold/issues).

## Paano Ito Gumagana

Binabasa ng Softfold ang anggulo ng takip sa pamamagitan ng IOKit HID nang may katumpakan sa bawat ikasandaang bahagi ng digri. Ang critically damped filter ay ginagawang tuluy-tuloy at natural na paggalaw ang mga sukat na ito. Mabagal na pagbaba - banayad na pagtiklop. Mabilis na paggalaw - mabilis na tugon. Kung hihinto ka sandali sa kalagitnaan, dahan-dahang babalik ang linaw ng desktop, at muling matitiklop kapag ipinagpatuloy mo ang pagsasara.

Ibinibigay ng ScreenCaptureKit ang live desktop feed at nirerender ng Metal ang perspective, progressive blur at anino sa gilid sa 60 fps. Gumagana lamang ang pag-record habang gumagalaw ang takip at hihinto ilang segundo pagkabukas. Ang frames ay nananatili lamang sa RAM at hindi kailanman ise-save o ia-upload. Minsan sa isang araw ay nagpapadala ang Softfold ng anonymous signal para tantiyahin ang mga aktibong Mac. Walang personal na data na kinokolekta.

Mababasa ang buong motion design sa [MOTION.md](../../MOTION.md).

## Pag-compile mula sa Source Code

I-install ang Xcode at patakbuhin:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Ang development checks ay nasa [CHECKS.md](../../CHECKS.md) at mga nilagdaang release sa [RELEASE.md](../../RELEASE.md).

## Pag-aambag

Ang mga ideya, ulat ng error, at pull request ay palaging malugod na tinatanggap. [Magbukas ng issue](https://github.com/ReffWu/softfold/issues) o magpadala ng pull request.

## Pagkilala

Nagsimula ang Softfold bilang fork ng [Hinge](https://github.com/Noveum/hinge) ng Noveum.ai sa ilalim ng Lisensyang MIT. Ang mga HID identifier ng lid sensor ay unang naitala ng proyektong [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Lisensya

[MIT](../../LICENSE)
