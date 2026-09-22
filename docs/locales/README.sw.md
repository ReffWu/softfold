<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Shusha kifuniko, na dawati lako litakunjika kwa upole.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Pakua Softfold kwa Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Bure · MacBook yenye Apple Silicon · macOS 14 au mpya zaidi · Imethibitishwa na Apple</sub>

<sub>Kama unapenda Softfold, ⭐ kwenye GitHub inasaidia wengine kugundua mradi huu.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Kiswahili · [🌍 Lugha Zote](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Shusha kifuniko, na dawati lako litakunjika kwa upole.">
  </picture>
</p>

---

Softfold hufuata mwelekeo wa bawaba ya MacBook yako kwa asili kabisa. Unapoteremsha skrini, dawati lako la moja kwa moja huegemea nyuma sambamba na harakati hiyo, likififia polepole kutoka juu kwenda chini na kuyeyuka katika kingo zenye giza. Inua skrini tena, na kila kitu kinarudi kikiwa safi na angavu, pale pale ulipoishia.

## Pakua

[Pakua Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), fungua faili na uburute Softfold kwenye folda ya Applications. Programu imesainiwa kwa Developer ID na kuthibitishwa na Apple, hivyo hufunguka salama kama programu yoyote rasmi ya Mac.

Mara ya kwanza kuifungua, ruhusu «Kurekodi Skrini» kwenye Mipangilio ya Mfumo, fungua tena Softfold iwapo macOS itakuhitaji kufanya hivyo, na uiwashe. Kuanzia hapo, itaanza kiotomatiki wakati Mac yako inapowashwa.

Unapowasha Softfold kwa mara ya kwanza, pembe ya sasa ya skrini huchukuliwa kama pembe ya kufungua. Ili kuibadilisha baadaye, weka skrini kwenye nafasi unayopenda na ubofye **Tumia Pembe ya Sasa**. Njia ya mkato <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> inakuwezesha kuwasha au kuzima athari hii wakati wowote.

## Miundo ya MacBook Inayotumika

Softfold inahitaji kihisi cha pembe ya kifuniko ambacho Apple ilianza kukiweka tangu 2019 (kinachopatikana kwenye Apple Silicon kupitia kichakataji kisaidizi cha vihisi) pamoja na macOS 14 au mpya zaidi. Kama Mac yako haina kihisi hiki, Softfold itakufahamisha mara moja.

| Hali | Miundo |
| --- | --- |
| Inafanya kazi, imethibitishwa na watumiaji | MacBook Pro ya 14" na 16" yenye M1 Pro au M1 Max (2021), M2 Max (2023), M3 Pro au M3 Max (2023), M4 Pro au M4 Max (2024). MacBook Air yenye M4 (2025) au M5 |
| Ina kihisi, bado haijathibitishwa | MacBook Pro ya 14" yenye M3, M4 au M5. MacBook Pro ya 14" na 16" yenye M5 Pro au M5 Max. MacBook Air yenye M2 au M3 |
| Haitumiki | MacBook Air yenye M1, MacBook Pro zote za 13" (Intel, M1 na M2), MacBook Pro za Intel, MacBook ya 12", MacBook Neo, kompyuta za mezani za Mac |

MacBook Pro ya inchi 16 ya 2019 pia ina kihisi hiki, lakini toleo lililotolewa limeundwa mahsusi kwa ajili ya usanifu wa Apple Silicon pekee.

Huna uhakika? Endesha amri hii kwenye Terminal. Mstari unaoishia na «las» unamaanisha Softfold inaweza kusoma kihisi cha kifuniko chako:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Umejaribu kwenye muundo uliopo kwenye safu ya kati? [Shiriki uzoefu wako nasi](https://github.com/ReffWu/softfold/issues).

## Jinsi Inavyofanya Kazi

Softfold husoma pembe ya kifuniko kupitia IOKit HID kwa usahihi wa sehemu ya mia ya digrii, ikifuata kasi ya asili ya kihisi. Kichujio maalum hubadilisha usomaji huo kuwa mwendo endelevu na wa asili. Mteremsho wa polepole huleta mkunjo laini; harakati ya haraka huleta mwitikio wa papo hapo. Ukisimama katikati kwa sekunde moja, dawati hurejesha uwazi wake kwa utulivu, na kuendelea kukunja unapoendelea kufunga.

ScreenCaptureKit hutoa taswira ya moja kwa moja ya dawati na Metal huonyesha mwonekano wa pande tatu kwa kasi thabiti ya 60 fps. Kurekodi hufanyika wakati wa kusonga au kukunja tu na husimama sekunde chache baada ya kufunguliwa kikamilifu. Picha hubaki kwenye RAM pekee na hazihifadhiwi kamwe. Mara moja kwa siku hutuma ishara isiyo na jina ili kukadiria vifaa vinavyofanya kazi. Hakuna data ya kibinafsi inayokusanywa.

Ubunifu kamili wa mwendo unapatikana katika [MOTION.md](../../MOTION.md).

## Jenga kutoka kwenye Msimbo Chanzo

Sakinisha Xcode kisha endesha:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Ukaguzi wa maendeleo umeelezwa katika [CHECKS.md](../../CHECKS.md) na matoleo yaliyosainiwa katika [RELEASE.md](../../RELEASE.md).

## Kuchangia

Mawazo, ripoti za hitilafu na pull requests zinakaribishwa sana. [Fungua issue](https://github.com/ReffWu/softfold/issues) au tuma pull request.

## Shukrani

Softfold ilianza kama fork ya [Hinge](https://github.com/Noveum/hinge) kutoka Noveum.ai chini ya Leseni ya MIT. Vitambulisho vya kihisi vilirekodiwa mara ya kwanza na mradi wa [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Leseni

[MIT](../../LICENSE)
