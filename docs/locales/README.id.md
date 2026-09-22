<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Tutup layarnya, dan desktop Anda akan terlipat dengan lembut.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Unduh Softfold untuk Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook dengan Apple Silicon · macOS 14 atau lebih baru · Dinotarisasi oleh Apple</sub>

<sub>Jika Anda menyukai Softfold, ⭐ di GitHub akan membantu orang lain menemukan proyek ini.</sub>

[English](../../README.md) · [简体中文](../../README.zh-CN.md) · Bahasa Indonesia · [🌍 Semua Bahasa](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Tutup layarnya, dan desktop Anda akan terlipat dengan lembut.">
  </picture>
</p>

---

Softfold bergerak selaras dengan engsel MacBook Anda. Saat Anda menurunkan layar, desktop aktif Anda ikut condong ke belakang, perlahan mengabur dari atas ke bawah dan memudar ke dalam tepi gelap. Angkat kembali layarnya, dan semua kembali jernih, tepat di tempat Anda meninggalkannya.

## Unduh

[Unduh Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), buka filenya, dan seret Softfold ke folder Aplikasi (Applications). Aplikasi ini ditandatangani dengan Developer ID dan dinotarisasi oleh Apple, sehingga dapat dibuka dengan aman layaknya aplikasi Mac bawaan lainnya.

Saat pertama kali dibuka, berikan izin «Perekaman Layar» di Pengaturan Sistem, buka ulang Softfold jika diminta oleh macOS, lalu aktifkan. Setelah itu, aplikasi akan berjalan otomatis saat Mac menyala dan selalu siap digunakan.

Saat pertama kali diaktifkan, Softfold menyimpan sudut layar saat ini sebagai sudut terbuka. Untuk mengubahnya nanti, posisikan layar pada sudut yang diinginkan lalu klik **Gunakan Sudut Saat Ini**. Pintasan <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> memungkinkan Anda menyalakan atau mematikan efek kapan saja.

## Model MacBook yang Didukung

Softfold memerlukan sensor sudut penutup yang disematkan Apple sejak 2019 (tersedia di Apple Silicon melalui prosesor pendamping sensor) serta macOS 14 atau versi lebih baru. Jika Mac Anda tidak memiliki sensor ini, Softfold akan langsung memberi tahu Anda.

| Status | Model |
| --- | --- |
| Berfungsi, dikonfirmasi pengguna | MacBook Pro 14" dan 16" dengan M1 Pro atau M1 Max (2021), M2 Max (2023), M3 Pro atau M3 Max (2023), M4 Pro atau M4 Max (2024). MacBook Air dengan M4 (2025) atau M5 |
| Memiliki sensor, belum dikonfirmasi | MacBook Pro 14" dengan M3, M4, atau M5. MacBook Pro 14" dan 16" dengan M5 Pro atau M5 Max. MacBook Air dengan M2 atau M3 |
| Tidak didukung | MacBook Air dengan M1, semua MacBook Pro 13" (Intel, M1, dan M2), MacBook Pro berbasis Intel, MacBook 12", MacBook Neo, Mac desktop |

MacBook Pro 16 inci tahun 2019 juga memiliki sensor ini, namun versi rilis dikompilasi khusus untuk arsitektur Apple Silicon.

Ragu? Jalankan perintah ini di Terminal. Baris yang berakhiran «las» menandakan bahwa Softfold dapat membaca sensor layar Anda:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Sudah mencobanya pada model di baris tengah? [Bagikan pengalaman Anda](https://github.com/ReffWu/softfold/issues).

## Cara Kerja

Softfold membaca sudut penutup melalui IOKit HID dengan ketepatan seperseratus derajat, mengikuti laju pembaruan alami sensor. Filter teredam kritis (critically damped filter) mengubah pembacaan tersebut menjadi gerakan yang organik dan mulus. Gerakan perlahan menghasilkan lipatan lembut; gerakan cepat direspons seketika. Jika Anda berhenti sejenak di tengah jalan, desktop perlahan kembali tajam, dan mulai melipat kembali saat Anda melanjutkan menutupnya.

ScreenCaptureKit menyediakan tampilan desktop langsung dan Metal merender perspektif 3D, keburaman progresif, dan bayangan tepi pada 60 fps stabil. Perekaman layar hanya aktif saat layar bergerak atau dalam posisi terlipat, dan berhenti beberapa detik setelah dibuka kembali, yang juga mematikan indikator perekaman oranye di macOS. Bingkai gambar hanya berada di RAM Mac dan tidak pernah disimpan atau diunggah. Sekali sehari, Softfold mengirimkan sinyal anonim untuk memperkirakan jumlah perangkat aktif. Tidak ada konten layar, file, alamat IP, atau data pribadi yang dikumpulkan. Anda dapat mematikan fungsi statistik ini kapan saja di jendela aplikasi.

Desain gerak lengkap dijelaskan dalam [MOTION.md](../../MOTION.md).

## Kompilasi dari Kode Sumber

Pasang Xcode, lalu jalankan:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Pemeriksaan pengembangan dijelaskan di [CHECKS.md](../../CHECKS.md) dan rilis tertandatangani di [RELEASE.md](../../RELEASE.md).

## Kontribusi

Ide, laporan bug, dan pull request selalu disambut dengan baik. [Buka issue](https://github.com/ReffWu/softfold/issues) atau kirimkan pull request.

## Ucapan Terima Kasih

Softfold berawal sebagai fork dari [Hinge](https://github.com/Noveum/hinge) oleh Noveum.ai di bawah Lisensi MIT. Pengidentifikasi HID sensor penutup pertama kali didokumentasikan oleh proyek [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Lisensi

[MIT](../../LICENSE)
