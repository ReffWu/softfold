<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Kapağı indirin, masaüstünüz usulca katlansın.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Mac için Softfold İndir">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Ücretsiz · Apple Silicon MacBook · macOS 14 veya üzeri · Apple tarafından noter onaylı</sub>

<sub>Softfold'u beğendiyseniz, GitHub'da vereceğiniz bir ⭐ daha fazla kişinin keşfetmesine yardımcı olur.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Nederlands](README.nl.md) · Türkçe · [Polski](README.pl.md) · [العربية](README.ar.md) · [Tiếng Việt](README.vi.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Kapağı indirin, masaüstünüz usulca katlansın.">
  </picture>
</p>

---

Softfold, MacBook'unuzun menteşe hareketine kusursuzca eşlik eder. Ekranı aşağı doğru indirdikçe, canlı masaüstünüz geriye doğru eğilir, yukarıdan aşağıya doğru zarifçe bulanıklaşır ve kenarlardaki karanlığa karışır. Ekranı tekrar kaldırdığınızda her şey bıraktığınız yerde, capcanlı ve net bir şekilde sizi bekler.

## İndirme

[Softfold.dmg dosyasını indirin](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), açın ve Softfold'u Uygulamalar klasörüne sürükleyin. Uygulama bir Developer ID ile imzalanmış ve Apple tarafından noter onayından geçirilmiştir; bu sayede tüm yerel Mac uygulamaları gibi güvenle açılır.

İlk açılışta Sistem Ayarları'ndan «Ekran Kaydı» iznini verin, macOS isterse Softfold'u kapatıp yeniden açın ve aktif hale getirin. Bundan sonra Mac'iniz her başladığında otomatik olarak çalışacak ve açık kalacaktır.

Softfold'u ilk kez açtığınızda o anki kapak açısını referans açı kabul eder. Daha sonra değiştirmek isterseniz ekranı dilediğiniz açıya getirip **Geçerli Açıyı Kullan** seçeneğine tıklayın. <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> kısayolu ile dilediğiniz zaman açıp kapatabilirsiniz.

## Desteklenen MacBook Modelleri

Softfold, Apple'ın 2019'dan itibaren eklediği kapak açısı sensörüne (Apple Silicon aygıtlarında sensör yardımcı işlemcisi üzerinden okunur) ve macOS 14 veya daha yeni bir sürüme ihtiyaç duyar. Mac'inizde bu sensör bulunmuyorsa Softfold sizi uyarır.

| Durum | Modeller |
| --- | --- |
| Çalışıyor, kullanıcılar tarafından doğrulandı | M1 Pro veya M1 Max (2021), M2 Max (2023), M3 Pro veya M3 Max (2023), M4 Pro veya M4 Max (2024) çipli 14 ve 16 inç MacBook Pro. M4 (2025) veya M5 çipli MacBook Air |
| Sensör mevcut, henüz doğrulanmadı | M3, M4 veya M5 çipli 14 inç MacBook Pro. M5 Pro veya M5 Max çipli 14 ve 16 inç MacBook Pro. M2 veya M3 çipli MacBook Air |
| Desteklenmiyor | M1 çipli MacBook Air, tüm 13 inç MacBook Pro'lar (Intel, M1 ve M2), Intel işlemcili MacBook Pro'lar, 12 inç MacBook, MacBook Neo, masaüstü Mac'ler |

2019 model 16 inç MacBook Pro'da da bu sensör bulunmaktadır; ancak yayınlanan uygulama paketi yalnızca Apple Silicon mimarisi için derlenmiştir.

Emin değil misiniz? Terminal'de bu komutu çalıştırın. Çıktıda «las» ile biten bir satır varsa Softfold kapağınızı okuyabilir demektir:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Orta satırdaki modellerden birinde denediniz mi? [Deneyiminizi bizimle paylaşın](https://github.com/ReffWu/softfold/issues).

## Nasıl Çalışır?

Softfold, kapak açısını IOKit HID üzerinden derecenin yüzde biri hassasiyetinde okur ve körü körüne sorgulama yapmak yerine sensörün kendi yenileme temposuna uyum sağlar. Kritik sönümlemeli bir filtre, ham verileri kesintisiz ve organik bir harekete dönüştürür. Yavaş kapatırsanız usulca katlanır; hızlı kapatırsanız anında kaybolur. Kapatırken bir saniye duraklarsanız masaüstü yumuşakça netleşir, kapatmaya devam ettiğiniz an yeniden katlanmaya başlar.

ScreenCaptureKit canlı masaüstü akışını iletir ve Metal motoru; perspektif derinliğini, aşamalı bulanıklığı ve ortam kenar dolgusunu akıcı 60 fps hızında işler. Ekran yakalama yalnızca kapak kapanırken veya katlanmış durumdayken çalışır, kapak açıldıktan birkaç saniye sonra tamamen durur ve böylece macOS turuncu kayıt göstergesi de söner. Kareler yalnızca Mac'inizin RAM belleğinde işlenir; diske asla kaydedilmez ve internete yüklenmez. Softfold, aktif Mac sayısını belirleyebilmek için günde bir kez rastgele bir kurulum kimliği, uygulama ve macOS sürümü, Mac modeli ve o gün katlama efektinin kullanılıp kullanılmadığını içeren anonim bir sinyal gönderir. Hiçbir ekran görüntüsü, dosya, IP adresi veya kişisel veri toplanmaz. Softfold penceresindeki «Anonim kullanım istatistiklerini paylaş» ayarını kapatarak bunu dilediğiniz an durdurabilirsiniz.

Hareket tasarımının tüm ayrıntılarına [MOTION.md](MOTION.md) dosyasından ulaşabilirsiniz.

## Desteklenen Diller

İngilizce, Basitleştirilmiş Çince, Geleneksel Çince, Japonca, Korece, Almanca, Fransızca, İspanyolca, İtalyanca, Brezilya Portekizcesi, Rusça, Felemenkçe, Türkçe, Lehçe, Arapça ve Vietnamca. Softfold, Mac'inizin sistem diline otomatik uyum sağlar veya uygulama penceresinden dilediğiniz dili seçebilirsiniz.

## Kaynak Koddan Derleme

Xcode'u yükleyin ve ardından şu komutları çalıştırın:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Geliştirme kontrolleri [CHECKS.md](CHECKS.md), imzalı sürüm adımları ise [RELEASE.md](RELEASE.md) dosyasında açıklanmıştır.

## Katkıda Bulunma

Fikirler, hata bildirimleri ve pull request'ler her zaman memnuniyetle karşılanır. [Bir issue açın](https://github.com/ReffWu/softfold/issues) veya pull request gönderin.

## Teşekkürler

Softfold, Noveum.ai tarafından MIT Lisansı altında geliştirilen [Hinge](https://github.com/Noveum/hinge) projesinin bir çatalı (fork) olarak başlamıştır. Kapak açısı sensörünün HID tanımlayıcıları ve rapor yapısı ilk olarak [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor) tarafından belgelenmiştir.

## Lisans

[MIT](LICENSE)
