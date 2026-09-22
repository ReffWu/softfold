<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Laske kansi alas, ja työpöytäsi taittuu pehmeästi pois.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Lataa Softfold Macille">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Ilmainen · MacBook ja Apple Silicon · macOS 14 tai uudempi · Applen notaari-vahvistama</sub>

<sub>Jos pidät Softfoldista, ⭐ GitHubissa auttaa useampia löytämään sen.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Suomi · [🌍 Kaikki kielet](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Laske kansi alas, ja työpöytäsi taittuu pehmeästi pois.">
  </picture>
</p>

---

Softfold myötäilee MacBookisi saranan liikettä. Kun lasket näyttöä alas, aktiivinen työpöytäsi kallistuu mukana taaksepäin, sumenee pehmeästi ylhäältä alaspäin ja sulautuu tummiin reunoihin. Nosta kansi uudelleen, ja kaikki palaa tarkkana takaisin juuri siihen, mihin sen jätit.

## Lataaminen

[Lataa Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), avaa tiedosto ja vedä Softfold Apit (Ohjelmat) -kansioon. Sovellus on allekirjoitettu Developer ID -tunnuksella ja Applen notaari-vahvistama, joten se avautuu luotettavasti kuten mikä tahansa Mac-sovellus.

Ensimmäisellä käynnistyskerralla salli «Näytön tallennus» Järjestelmäasetuksissa, avaa sovellus uudelleen jos macOS sitä pyytää, ja kytke se päälle. Tämän jälkeen Softfold käynnistyy automaattisesti Macisi mukana ja pysyy toimintavalmiina.

Kun otat Softfoldin käyttöön ensimmäisen kerran, kannen nykyinen asento tallennetaan auki-kulmaksi. Jos haluat muuttaa sitä myöhemmin, aseta näyttö haluamaasi kulmaan ja valitse **Käytä nykyistä kulmaa**. Pikanäppäimellä <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> kytket tehosteen päälle tai pois milloin vain.

## Tuetut MacBook-mallit

Softfold vaatii kannen kulma-anturin, jonka Apple esitteli vuonna 2019 (käytettävissä Apple Siliconissa anturien apusuorittimen kautta) sekä vähintään macOS 14 -käyttöjärjestelmän. Jos Macistasi puuttuu anturi, Softfold ilmoittaa siitä suoraan.

| Tila | Mallit |
| --- | --- |
| Toimii, käyttäjien vahvistama | 14" ja 16" MacBook Pro, joissa M1 Pro tai M1 Max (2021), M2 Max (2023), M3 Pro tai M3 Max (2023), M4 Pro tai M4 Max (2024). MacBook Air, jossa M4 (2025) tai M5 |
| Anturi löytyy, ei vielä vahvistettu | 14" MacBook Pro, jossa M3, M4 tai M5. 14" ja 16" MacBook Pro, jossa M5 Pro tai M5 Max. MacBook Air, jossa M2 tai M3 |
| Ei tuettu | MacBook Air (M1), kaikki 13" MacBook Prot (Intel, M1 ja M2), Intel-pohjaiset MacBook Prot, 12" MacBook, MacBook Neo, pöytä-Macit |

Vuoden 2019 16-tuumaisessa MacBook Prossa on myös kyseinen anturi, mutta julkaistu ohjelmistoversio on käännetty ainoastaan Apple Silicon -alustalle.

Etkö ole varma? Suorita tämä komento Päätteessä (Terminal). Rivi, joka päättyy merkintään «las», vahvistaa että Softfold voi lukea laitteesi anturia:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Kokeilitko keskirivin mallilla? [Kerro kokemuksesi meille](https://github.com/ReffWu/softfold/issues).

## Miten se toimii

Softfold lukee kannen kulman IOKit HID -rajapinnan kautta asteen sadasosan tarkkuudella, mukautuen anturin omaan päivitysrytmiin ilman turhaa järjestelmän kuormitusta. Kriittisesti vaimennettu suodatin muuttaa lukemat luonnolliseksi, yhtenäiseksi liikkeeksi. Hidas liike taittaa pehmeästi; nopea liike reagoi heti. Jos pysähdyt sekunniksi puoliväliin, työpöytä palauttaa terävyytensä, ja jatkaa taittumista heti kun jatkat kannen sulkemista.

ScreenCaptureKit toimittaa reaaliaikaisen työpöytänäkymän, ja Metal-moottori renderöi syvyysperspektiivin, asteittaisen sumennuksen ja reunojen häivytyksen vakaalla 60 fps -nopeudella. Näytön kaappaus on aktiivinen vain kannen liikkuessa tai taitettuna, ja se pysähtyy muutama sekunti avaamisen jälkeen, mikä sammuttaa myös macOS oranssin tallennusilmaisimen. Kuvaruudut pysyvät ainoastaan Macisi keskusmuistissa eikä niitä koskaan tallenneta levylle tai lähetetä verkkoon. Softfold lähettää kerran päivässä nimettömän tilastosignaalin satunnaisella tunnisteella aktiivisten laitteiden määrän arvioimiseksi. Mitään näyttösisältöä, tiedostoja, IP-osoitteita tai henkilötietoja ei kerätä. Voit poistaa toiminnon käytöstä ikkunasta milloin vain.

Täydellinen liikesuunnittelu löytyy tiedostosta [MOTION.md](../../MOTION.md).

## Käännä lähdekoodista

Asenna Xcode ja suorita:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Kehityksen tarkistukset on kuvattu tiedostossa [CHECKS.md](../../CHECKS.md) ja allekirjoitetut julkaisut tiedostossa [RELEASE.md](../../RELEASE.md).

## Osallistuminen

Ideat, virheilmoitukset ja pull requestit ovat lämpimästi tervetulleita. [Avaa issue](https://github.com/ReffWu/softfold/issues) tai lähetä pull request.

## Kiitokset

Softfold sai alkunsa Noveum.ai:n kehittämästä [Hinge](https://github.com/Noveum/hinge) -projektista MIT-lisenssillä. Kannen kulma-anturin HID-tunnisteet ja tietomuodot dokumentoi ensimmäisenä [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Lisenssi

[MIT](../../LICENSE)
