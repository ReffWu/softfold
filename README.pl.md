<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Przymknij pokrywę, a biurko miękko się złoży.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Pobierz Softfold na Maca">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Bezpłatnie · MacBook z Apple Silicon · macOS 14 lub nowszy · Notaryzowane przez Apple</sub>

<sub>Jeśli podoba Ci się Softfold, gwiazdka ⭐ na GitHubie pomoże innym odkryć ten projekt.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · Polski · [العربية](README.ar.md) · [Tiếng Việt](README.vi.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Przymknij pokrywę, a biurko miękko się złoży.">
  </picture>
</p>

---

Softfold podąża za zawiasem Twojego MacBooka. Gdy opuszczasz ekran, Twoje aktywne biurko odchyla się wraz z nim do tyłu, stopniowo rozmywa się od góry i płynnie wtapia w ciemne krawędzie. Otwórz pokrywę ponownie, a wszystko wróci na swoje miejsce, idealnie ostre i dokładnie tak, jak zostało zostawione.

## Pobieranie

[Pobierz Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), otwórz plik i przeciągnij Softfold do folderu Programy (Aplikacje). Aplikacja jest podpisana certyfikatem Developer ID oraz znotaryzowana przez Apple, dzięki czemu otwiera się bez problemu jak każdy natywny program na Macu.

Przy pierwszym uruchomieniu zezwól na «Nagrywanie ekranu» w Ustawieniach systemowych, w razie potrzeby uruchom program ponownie i włącz go. Od tej pory Softfold będzie uruchamiał się automatycznie wraz z Twoim Makiem i pozostanie w gotowości.

Gdy włączysz Softfold po raz pierwszy, bieżący kąt pokrywy zostanie zapamiętany jako kąt otwarcia. Aby zmienić go później, ustaw ekran w wygodnej pozycji i kliknij **Użyj bieżącego kąta**. Skrót <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> pozwala włączyć lub wyłączyć efekt w dowolnym momencie.

## Obsługiwane modele MacBooka

Softfold wymaga czujnika kąta otwarcia pokrywy, który Apple montuje od 2019 roku (w układach Apple Silicon obsługiwanego przez koprocesor czujników), oraz systemu macOS 14 lub nowszego. Jeśli Twój Mac nie ma takiego czujnika, Softfold od razu Cię o tym poinformuje.

| Status | Modele |
| --- | --- |
| Działa, potwierdzone przez użytkowników | MacBook Pro 14" i 16" z M1 Pro lub M1 Max (2021), M2 Max (2023), M3 Pro lub M3 Max (2023), M4 Pro lub M4 Max (2024). MacBook Air z M4 (2025) lub M5 |
| Ma czujnik, jeszcze niepotwierdzone | MacBook Pro 14" z M3, M4 lub M5. MacBook Pro 14" i 16" z M5 Pro lub M5 Max. MacBook Air z M2 lub M3 |
| Nieobsługiwane | MacBook Air z M1, wszystkie MacBooki Pro 13" (Intel, M1 i M2), MacBooki Pro z procesorami Intel, MacBook 12", MacBook Neo, komputery stacjonarne Mac |

16-calowy MacBook Pro z 2019 roku również posiada ten czujnik, jednak oficjalna wersja została skompilowana wyłącznie dla architektury Apple Silicon.

Nie masz pewności? Uruchom to polecenie w Terminalu. Linia kończąca się na «las» oznacza, że Softfold może odczytać położenie Twojej pokrywy:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Wypróbowałeś aplikację na modelu ze środkowego wiersza? [Podziel się swoimi wrażeniami](https://github.com/ReffWu/softfold/issues).

## Zasada działania

Softfold odczytuje kąt pokrywy za pośrednictwem IOKit HID z dokładnością do setnych części stopnia, dostosowując się do natywnej częstotliwości odświeżania czujnika zamiast obciążać system pustymi zapytaniami. Filtr o tłumieniu krytycznym przekształca te dane w płynny, organiczny ruch. Wolne opuszczanie - delikatne składanie. Szybki ruch - natychmiastowa reakcja. Jeśli zatrzymasz się w połowie na sekundę, biurko płynnie odzyskuje ostrość, po czym znów zaczyna się składać, gdy tylko wznowisz ruch zamykania.

ScreenCaptureKit dostarcza obraz biurka w czasie rzeczywistym, a Metal renderuje perspektywę, progresywne rozmycie i boczne wypełnienie w płynnych 60 kl./s. Przechwytywanie działa wyłącznie podczas ruchu lub złożenia ekranu i zatrzymuje się kilka sekund po ponownym otwarciu, co gasi pomarańczowy wskaźnik nagrywania w macOS. Klatki pozostają wyłącznie w pamięci RAM i nigdy nie są zapisywane na dysku ani przesyłane do sieci. Raz dziennie Softfold wysyła anonimowy sygnał z losowym identyfikatorem instalacji, wersjami aplikacji i systemu macOS, modelem komputera oraz informacją o użyciu efektu w danym dniu, wyłącznie w celu szacowania liczby aktywnych komputerów Mac. Żadne zrzuty ekranu, pliki, adresy IP ani dane osobowe nie są gromadzone. W każdej chwili możesz wyłączyć opcję «Udostępniaj anonimowe statystyki» w oknie programu.

Pełna koncepcja animacji została opisana w dokumencie [MOTION.md](MOTION.md).

## Obsługiwane języki

Angielski, chiński uproszczony, chiński tradycyjny, japoński, koreański, niemiecki, francuski, hiszpański, włoski, portugalski brazylijski, rosyjski, niderlandzki, turecki, polski, arabski i wietnamski. Softfold automatycznie dopasowuje się do języka systemu Maca lub pozwala wybrać preferowany język w oknie aplikacji.

## Kompilacja ze źródeł

Zainstaluj Xcode, a następnie wykonaj:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Procedury weryfikacji deweloperskiej opisano w [CHECKS.md](CHECKS.md), a podpisywanie wydań w [RELEASE.md](RELEASE.md).

## Współtworzenie

Pomysły, zgłoszenia błędów oraz pull requesty są bardzo mile widziane. [Otwórz zgłoszenie (issue)](https://github.com/ReffWu/softfold/issues) lub prześlij pull request.

## Podziękowania

Projekt Softfold powstał jako fork repozytorium [Hinge](https://github.com/Noveum/hinge) autorstwa Noveum.ai, udostępnionego na licencji MIT. Identyfikatory HID czujnika kąta pokrywy oraz układ raportów zostały po raz pierwszy opisane w projekcie [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licencja

[MIT](LICENSE)
