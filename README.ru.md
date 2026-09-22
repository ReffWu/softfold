<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Опустите крышку, и рабочий стол мягко складывается.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Скачать Softfold для Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Бесплатно · MacBook с чипом Apple Silicon · macOS 14 или новее · Нотариально заверено Apple</sub>

<sub>Если вам нравится Softfold, звезда ⭐ на GitHub поможет другим пользователям узнать о проекте.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · Русский · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · [Polski](README.pl.md) · [العربية](README.ar.md) · [Tiếng Việt](README.vi.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Опустите крышку, и рабочий стол мягко складывается.">
  </picture>
</p>

---

Softfold чутко реагирует на шарнир вашего MacBook. Когда вы опускаете крышку, рабочий стол в реальном времени отклоняется назад, плавно размывается сверху вниз и растворяется в темных боковых гранях. Поднимите экран снова, и всё мгновенно вернется на свои места, четко и ровно так, как вы оставили.

## Загрузка

[Скачайте Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), откройте образ и перетащите Softfold в папку «Программы». Приложение подписано сертификатом Developer ID и нотариально заверено Apple, поэтому открывается легко и безопасно, как любое стандартное приложение для macOS.

При первом запуске разрешите «Запись экрана» в Системных настройках, перезапустите Softfold по запросу macOS и включите его. Далее приложение будет автоматически запускаться вместе с Mac и оставаться готовым к работе.

При первом включении Softfold запоминает текущий угол наклона экрана как исходный. Чтобы изменить его позже, установите экран в удобное положение и нажмите **Использовать текущий угол**. Сочетание клавиш <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> позволяет быстро включать и выключать эффект в любой момент.

## Поддерживаемые модели MacBook

Softfold использует датчик угла открытия крышки, который Apple устанавливает с 2019 года (на чипах Apple Silicon он опрашивается через специальный сопроцессор датчиков), и требует macOS 14 или новее. Если в вашем Mac нет такого датчика, Softfold сразу предупредит об этом.

| Статус | Модели |
| --- | --- |
| Работает, подтверждено пользователями | 14" и 16" MacBook Pro с M1 Pro или M1 Max (2021), M2 Max (2023), M3 Pro или M3 Max (2023), M4 Pro или M4 Max (2024). MacBook Air с M4 (2025) или M5 |
| Датчик есть, пока не подтверждено | 14" MacBook Pro с M3, M4 или M5. 14" и 16" MacBook Pro с M5 Pro или M5 Max. MacBook Air с M2 или M3 |
| Не поддерживается | MacBook Air с M1, все 13" MacBook Pro (Intel, M1 и M2), MacBook Pro на Intel, 12" MacBook, MacBook Neo, настольные компьютеры Mac |

В 16-дюймовом MacBook Pro 2019 года датчик также установлен, однако текущая сборка скомпилирована исключительно для архитектуры Apple Silicon.

Сомневаетесь? Выполните эту команду в Терминале. Строка, оканчивающаяся на «las», означает, что Softfold может считывать угол наклона крышки вашего ноутбука:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Протестировали на модели из второй строки? [Поделитесь результатом](https://github.com/ReffWu/softfold/issues).

## Принцип работы

Softfold считывает угол наклона крышки через IOKit HID с точностью до сотых долей градуса, подстраиваясь под собственную частоту опроса датчика без лишних обращений. Фильтр с критическим затуханием превращает дискретные показания в плавное, непрерывное движение. Медленный наклон - мягкое складывание. Быстрый жест - мгновенная реакция. Задержите крышку на секунду на полпути, и рабочий стол мягко вернет резкость, а затем снова продолжит складываться, стоит продолжить движение.

ScreenCaptureKit передает поток рабочего стола в реальном времени, а фреймворк Metal визуализирует перспективу, прогрессивное размытие и боковые градиенты со стабильной частотой 60 кадров/с. Захват экрана активен только во время движения или в сложенном состоянии и прекращается через пару секунд после полного открытия, благодаря чему системный оранжевый индикатор записи гаснет. Кадры обрабатываются исключительно в оперативной памяти Mac, никогда не сохраняются на диск и не передаются по сети. Раз в сутки Softfold отправляет анонимный отчет со случайным идентификатором установки, версиями приложения и macOS, моделью Mac и фактом использования эффекта для подсчета активных устройств. Никакие снимки экрана, файлы, IP-адреса или персональные данные не сохраняются. Вы можете в любой момент отключить «Делиться анонимной статистикой» в окне приложения.

Подробное описание физики движения приведено в [MOTION.md](MOTION.md).

## Поддерживаемые языки

Английский, упрощенный китайский, традиционный китайский, японский, корейский, немецкий, французский, испанский, итальянский, бразильский португальский, русский, нидерландский, турецкий, польский, арабский и вьетнамский. Softfold автоматически подстраивается под язык системы или настраивается в окне приложения.

## Сборка из исходного кода

Установите Xcode, затем выполните:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Проверки в процессе разработки описаны в [CHECKS.md](CHECKS.md), а подписание релизов - в [RELEASE.md](RELEASE.md).

## Участие в разработке

Идеи, сообщения об ошибках и пулл-реквесты приветствуются. [Создайте issue](https://github.com/ReffWu/softfold/issues) или отправьте pull request.

## Благодарности

Проект Softfold начался как форк [Hinge](https://github.com/Noveum/hinge) от Noveum.ai, распространяемого под лицензией MIT. Идентификаторы HID и формат отчетов датчика угла наклона крышки были впервые задокументированы в проекте [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Лицензия

[MIT](LICENSE)
