<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**درپوش را ببندید، تا میزکارتان به آرامی تا شود.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="دانلود Softfold برای مک">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>رایگان · مک‌بوک‌های مجهز به Apple Silicon · سیستم‌عامل macOS 14 یا بالاتر · دارای تأییدیه رسمی اپل</sub>

<sub>اگر Softfold را دوست دارید، یک ⭐ در GitHub به دیگران کمک می‌کند این پروژه را پیدا کنند.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · فارسی · [🌍 همه زبان‌ها](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="درپوش را ببندید، تا میزکارتان به آرامی تا شود.">
  </picture>
</p>

---

نرم‌افزار Softfold با لولای مک‌بوک شما همگام است. همزمان با پایین آوردن صفحه، میزکار زنده شما به نرمی به عقب متمایل می‌شود، از بالا به پایین محو می‌گردد و در تاریکی لبه‌ها ادغام می‌شود. با بالا بردن دوباره صفحه، همه‌چیز دقیقاً همان‌گونه و در همان جایی که رهایش کردید، با وضوح کامل بازمی‌گردد.

## دانلود

فایل [Softfold.dmg را دانلود کنید](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg)، آن را باز کرده و Softfold را به پوشه Applications منتقل کنید. این برنامه با Developer ID امضا شده و توسط اپل تأیید شده است، بنابراین همانند سایر برنامه‌های رسمی مک باز می‌شود.

در اولین اجرا، اجازه «ضبط صفحه» (Screen Recording) را در تنظیمات سیستم بدهید و آن را فعال کنید. از آن پس، با هر بار روشن شدن مک، برنامه به طور خودکار فعال خواهد شد.

هنگام اولین فعال‌سازی، زاویه فعلی صفحه به عنوان زاویه باز بودن ثبت می‌شود. برای تغییر آن، صفحه را در زاویه دلخواه قرار داده و روی **استفاده از زاویه فعلی** کلیک کنید. با کلید میانبر <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> می‌توانید در هر زمان این جلوه را خاموش یا روشن کنید.

## مدل‌های سازگار مک‌بوک

این نرم‌افزار به حسگر زاویه درپوش که اپل از سال ۲۰۱۹ افزوده است و نسخه macOS 14 یا بالاتر نیاز دارد. اگر مک شما فاقد حسگر باشد، Softfold به شما اطلاع می‌دهد.

| وضعیت | مدل‌ها |
| --- | --- |
| کاملاً فعال و تأییدشده | مک‌بوک پرو ۱۴ و ۱۶ اینچ با M1 Pro یا M1 Max (2021)، M2 Max (2023)، M3 Pro یا M3 Max (2023)، M4 Pro یا M4 Max (2024). مک‌بوک ایر با M4 (2025) یا M5 |
| دارای حسگر، هنوز آزمایش‌نشده | مک‌بوک پرو ۱۴ اینچ با M3، M4 یا M5. مک‌بوک پرو ۱۴ و ۱۶ اینچ با M5 Pro یا M5 Max. مک‌بوک ایر با M2 یا M3 |
| پشتیبانی نمی‌شود | مک‌بوک ایر با M1، تمام مک‌بوک پروهای ۱۳ اینچ، مک‌بوک‌های اینتل، مک‌بوک ۱۲ اینچ، مک‌های رومیزی |

مک‌بوک پرو ۱۶ اینچی ۲۰۱۹ نیز این حسگر را دارد، اما نسخه ارائه‌شده صرفاً برای پردازنده‌های Apple Silicon توسعه یافته است.

برای اطمینان، این دستور را در ترمینال اجرا کنید. خطی که با «las» پایان می‌یابد نشان‌دهنده پشتیبانی دستگاه است:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

آیا آن را روی مدل‌های ردیف وسط آزمایش کردید؟ [تجربه خود را با ما در میان بگذارید](https://github.com/ReffWu/softfold/issues).

## نحوه عملکرد

برنامه زاویه لولا را از طریق IOKit HID با دقت صدم درجه می‌خواند. یک فیلتر میراکننده دقیق این اطلاعات را به حرکتی طبیعی و پیوسته تبدیل می‌کند. شیب آرام، تاشدن نرم. شیب تند، واکنش آنی. فریم‌ها تنها در رم پردازش می‌شوند و هرگز ذخیره یا ارسال نمی‌گردند. روزی یک بار یک سیگنال ناشناس برای برآورد مک‌های فعال ارسال می‌شود و هیچ داده شخصی گردآوری نمی‌شود.

جزئیات کامل طراحی حرکت در [MOTION.md](../../MOTION.md) آمده است.

## کامپایل از منبع

پس از نصب Xcode، دستورات زیر را اجرا کنید:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

بررسی‌های فنی در [CHECKS.md](../../CHECKS.md) و مراحل انتشار در [RELEASE.md](../../RELEASE.md) تشریح شده است.

## مشارکت

پیشنهادات و گزارش اشکالات همواره مورد استقبال است. [یک Issue باز کنید](https://github.com/ReffWu/softfold/issues) یا pull request بفرستید.

## تقدیر و تشکر

این پروژه به عنوان انشعابی از [Hinge](https://github.com/Noveum/hinge) تحت مجوز MIT آغاز شد. شناسه حسگر لولا برای نخستین بار در [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor) مستند شده است.

## مجوز

[MIT](../../LICENSE)
