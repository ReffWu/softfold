<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Hajtsd le a kijelzőt, és az íróasztalod lágyan összehajlik.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Softfold letöltése Macre">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Ingyenes · MacBook Apple Silicon chippel · macOS 14 vagy újabb · Apple által hitelesítve</sub>

<sub>Ha tetszik a Softfold, egy ⭐ a GitHubon segít másoknak is rátalálni.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Magyar · [🌍 Összes nyelv](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Hajtsd le a kijelzőt, és az íróasztalod lágyan összehajlik.">
  </picture>
</p>

---

A Softfold együtt mozog a MacBook zsanérjával. Amikor lehajtod a kijelzőt, az élő íróasztalod vele együtt dől hátra, felülről lefelé finoman elmosódik, és beleolvad a sötét szegélyekbe. Hajtsd fel újra, és minden azonnal visszatér, élesen és pontosan úgy, ahogyan hagytad.

## Letöltés

[Töltsd le a Softfold.dmg fájlt](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), nyisd meg, és húzd a Softfoldot az Alkalmazások mappába. Az alkalmazást Developer ID tanúsítvánnyal írták alá és az Apple hitelesítette (közjegyzőzte), így biztonságosan nyílik meg, mint bármely natív Mac-app.

Az első indításkor engedélyezd a «Képernyőfelvétel» jogosultságot a Rendszerbeállításokban, indítsd újra a Softfoldot ha a macOS kéri, majd kapcsold be. Ezt követően a Mac bekapcsolásakor automatikusan elindul a háttérben.

Az első bekapcsoláskor a Softfold a kijelző aktuális dőlésszögét menti el nyitott szögként. Később a módosításhoz állítsd a kijelzőt a kívánt helyzetbe, majd kattints az **Aktuális szög használata** gombra. A <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> billentyűparanccsal az effektus bármikor ki- és bekapcsolható.

## Támogatott MacBook modellek

A Softfoldhoz a kijelző dőlésszög-érzékelője szükséges, amelyet az Apple 2019 óta épít be a gépekbe (Apple Silicon modelleken az érzékelő-társprocesszoron keresztül érhető el), valamint legalább macOS 14 rendszer. Ha a gépedben nincs ilyen érzékelő, a Softfold azonnal jelzi.

| Állapot | Modellek |
| --- | --- |
| Működik, a felhasználók megerősítették | 14" és 16" MacBook Pro M1 Pro vagy M1 Max (2021), M2 Max (2023), M3 Pro vagy M3 Max (2023), M4 Pro vagy M4 Max (2024). MacBook Air M4 (2025) vagy M5 |
| Rendelkezik érzékelővel, még nincs megerősítve | 14" MacBook Pro M3, M4 vagy M5. 14" és 16" MacBook Pro M5 Pro vagy M5 Max. MacBook Air M2 vagy M3 |
| Nem támogatott | MacBook Air M1, az összes 13" MacBook Pro (Intel, M1 és M2), Intel MacBook Pro, 12" MacBook, MacBook Neo, asztali Mac gépek |

A 2019-es 16 hüvelykes MacBook Pro szintén rendelkezik az érzékelővel, a hivatalos verzió azonban kizárólag az Apple Silicon architektúrára készült.

Nem vagy biztos benne? Futtasd ezt a parancsot a Terminálban. Ha a sor végén az «las» szöveg látható, a Softfold képes olvasni a kijelződ szögét:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Kipróbáltad a középső sor valamelyik modelljén? [Oszd meg velünk a tapasztalataidat](https://github.com/ReffWu/softfold/issues).

## Hogyan működik?

A Softfold a kijelző szögét IOKit HID felületen keresztül olvassa le századfokos pontossággal, igazodva az érzékelő saját frissítési ritmusához a rendszer felesleges terhelése nélkül. Egy kritikusan csillapított szűrő a nyers adatokat szerves, folyamatos mozgássá alakítja. Lassú lehajtás esetén lágy összecsukódás; gyors mozdulat esetén azonnali reakció. Ha félúton egy másodpercre megállsz, az íróasztal lágyan visszanyeri az élességét, majd amint folytatod a zárást, újra hajlani kezd.

A ScreenCaptureKit biztosítja az élő íróasztal-képet, a Metal grafikus motor pedig stabil 60 képkocka/másodperc sebességgel rendereli a perspektívát, a fokozatos elmosódást és az oldalsó kitöltést. A képernyőrögzítés kizárólag a mozgás ideje alatt vagy lehajtott állapotban fut, és a felnyitást követően néhány másodpercen belül leáll, ami a macOS narancssárga rögzítésjelzőjét is kikapcsolja. A képkockák kizárólag a Mac memóriájában maradnak, nem kerülnek mentésre vagy továbbításra. A Softfold naponta egyszer küld egy névtelen statisztikai jelet az aktív gépek számának becslésére. Semmilyen képernyőtartalom, fájl, IP-cím vagy személyes adat nem kerül rögzítésre. A funkció bármikor kikapcsolható az ablakban.

A teljes mozgástervezést a [MOTION.md](../../MOTION.md) dokumentum tartalmazza.

## Fordítás forráskódból

Telepítsd az Xcode-ot, majd futtasd:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

A fejlesztési ellenőrzéseket a [CHECKS.md](../../CHECKS.md), az aláírt kiadásokat pedig a [RELEASE.md](../../RELEASE.md) ismerteti.

## Közreműködés

Ötleteket, hibajelentéseket és pull requesteket örömmel fogadunk. [Nyiss egy hibajegyet (issue)](https://github.com/ReffWu/softfold/issues) vagy küldj egy pull requestet.

## Köszönetnyilvánítás

A Softfold a Noveum.ai által MIT licenc alatt kiadott [Hinge](https://github.com/Noveum/hinge) elágazásaként indult. A kijelzőszög-érzékelő HID-azonosítóit és jelentésformátumát elsőként a [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor) projekt dokumentálta.

## Licenc

[MIT](../../LICENSE)
