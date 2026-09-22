<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Tutup skrin, dan desktop anda akan terlipat dengan lembut.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Muat turun Softfold untuk Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Percuma · MacBook dengan Apple Silicon · macOS 14 atau lebih baharu · Dinotari oleh Apple</sub>

<sub>Jika anda menyukai Softfold, ⭐ di GitHub membantu orang lain menemui projek ini.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Bahasa Melayu · [🌍 Semua Bahasa](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Tutup skrin, dan desktop anda akan terlipat dengan lembut.">
  </picture>
</p>

---

Softfold bergerak seiring dengan engsel MacBook anda. Semasa anda menurunkan skrin, desktop langsung anda turut condong ke belakang, perlahan-lahan kabur dari atas ke bawah dan beransur-ansur pudar ke dalam sisi gelap. Angkat kembali skrin, dan segala-galanya kembali jelas, tepat di tempat anda meninggalkannya.

## Muat turun

[Muat turun Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), buka fail dan seret Softfold ke folder Aplikasi. Aplikasi ini ditandatangani dengan Developer ID dan dinotari oleh Apple, maka ia dibuka dengan selamat seperti aplikasi Mac asli yang lain.

Semasa pelancaran pertama, benarkan «Rakaman Skrin» dalam Seting Sistem, buka semula Softfold jika diminta oleh macOS dan hidupkannya. Selepas itu, ia akan bermula secara automatik bersama Mac anda dan sentiasa bersedia.

Pertama kali anda menghidupkan Softfold, sudut semasa skrin akan disimpan sebagai sudut buka. Untuk mengubahnya kemudian, tetapkan skrin pada kedudukan yang dikehendaki dan klik **Gunakan Sudut Semasa**. Pintasan <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> membolehkan anda menghidupkan atau mematikan kesan ini pada bila-bila masa.

## Model MacBook yang Disokong

Softfold memerlukan penderia sudut penutup yang ditambah oleh Apple sejak 2019 (boleh diakses pada Apple Silicon melalui pemproses bersama penderia) serta macOS 14 atau lebih baharu. Jika Mac anda tidak mempunyai penderia ini, Softfold akan memberitahu anda serta-merta.

| Status | Model |
| --- | --- |
| Berfungsi, disahkan oleh pengguna | MacBook Pro 14" dan 16" dengan M1 Pro atau M1 Max (2021), M2 Max (2023), M3 Pro atau M3 Max (2023), M4 Pro atau M4 Max (2024). MacBook Air dengan M4 (2025) atau M5 |
| Mempunyai penderia, belum disahkan | MacBook Pro 14" dengan M3, M4 atau M5. MacBook Pro 14" dan 16" dengan M5 Pro atau M5 Max. MacBook Air dengan M2 atau M3 |
| Tidak disokong | MacBook Air dengan M1, semua MacBook Pro 13" (Intel, M1 dan M2), MacBook Pro berasaskan Intel, MacBook 12", MacBook Neo, Mac meja |

MacBook Pro 16 inci 2019 turut mempunyai penderia ini, namun binaan rasmi dibangunkan khusus untuk seni bina Apple Silicon sahaja.

Tidak pasti? Jalankan arahan ini dalam Terminal. Baris yang berakhir dengan «las» bermakna Softfold boleh membaca penderia skrin anda:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Pernah mencuba pada model di baris tengah? [Kongsikan pengalaman anda](https://github.com/ReffWu/softfold/issues).

## Bagaimana ia Berfungsi

Softfold membaca sudut penutup melalui IOKit HID dengan ketepatan satu peratus darjah, mengikut kadar segar semula semula jadi penderia tanpa membebankan sistem. Penapis redaman kritikal (critically damped filter) menukar bacaan tersebut kepada pergerakan yang organik dan berterusan. Sendeng perlahan menghasilkan lipatan lembut; gerakan pantas memberikan tindak balas serta-merta. Jika anda berhenti seketika di pertengahan jalan, desktop perlahan-lahan kembali tajam, dan mula melipat semula sebaik sahaja anda meneruskan penutupan.

ScreenCaptureKit membekalkan paparan desktop masa nyata dan Metal memaparkan perspektif 3D, kekaburan progresif serta isian tepi pada 60 fps stabil. Tangkapan skrin hanya aktif semasa pergerakan atau dalam keadaan terlipat dan berhenti beberapa saat selepas dibuka semula. Bingkai hanya kekal dalam RAM dan tidak pernah disimpan atau dimuat naik. Sekali sehari Softfold menghantar isyarat tanpa nama untuk menganggar peranti aktif. Tiada data peribadi dikumpulkan.

Reka bentuk pergerakan lengkap boleh didapati di [MOTION.md](../../MOTION.md).

## Bina daripada Kod Sumber

Pasang Xcode dan jalankan:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Semakan pembangunan diperincikan dalam [CHECKS.md](../../CHECKS.md) dan keluaran ditandatangani dalam [RELEASE.md](../../RELEASE.md).

## Sumbangan

Cadangan, laporan pepijat dan pull request sentiasa dialu-alukan. [Buka issue](https://github.com/ReffWu/softfold/issues) atau hantar pull request.

## Penghargaan

Softfold bermula sebagai fork daripada [Hinge](https://github.com/Noveum/hinge) oleh Noveum.ai di bawah Lesen MIT. Pengecam penderia penutup pertama kali didokumentasikan oleh projek [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Lesen

[MIT](../../LICENSE)
