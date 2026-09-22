<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Опустіть кришку, і робочий стіл м'яко згорнеться.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Завантажити Softfold для Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Безкоштовно · MacBook з чипом Apple Silicon · macOS 14 або новіша · Нотаріально засвідчено Apple</sub>

<sub>Якщо вам подобається Softfold, зірочка ⭐ на GitHub допоможе більшій кількості людей дізнатися про проєкт.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Українська · [🌍 Всі мови](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Опустіть кришку, і робочий стіл м'яко згорнеться.">
  </picture>
</p>

---

Softfold чуйно рухається разом із шарніром вашого MacBook. Коли ви опускаєте екран, ваш активний робочий стіл плавно нахиляється назад, м'яко розмивається зверху вниз і поступово розчиняється в темних бокових гранях. Підніміть екран знову, і все повернеться кришталево чітким, саме там, де ви зупинилися.

## Завантаження

[Завантажте Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), відкрийте файл і перетягніть Softfold до папки «Програми». Програма підписана сертифікатом Developer ID і нотаріально засвідчена Apple, тож вона відкривається безпечно, як будь-яка нативна програма для Mac.

Під час першого запуску надайте дозвіл на «Запис екрана» в Системних параметрах, перезапустіть Softfold на вимогу macOS та ввімкніть його. Після цього він запускатиметься автоматично під час увімкнення вашого Mac.

Під час першого увімкнення Softfold фіксує поточний кут нахилу кришки як кут відкриття. Щоб змінити його пізніше, встановіть екран у бажане положення і натисніть **Використати поточний кут**. Комбінація клавіш <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> дозволяє вмикати або вимикати ефект будь-якої миті.

## Які моделі MacBook підтримуються

Softfold використовує датчик кута відкриття кришки, який Apple встановлює з 2019 року (на пристроях Apple Silicon доступний через співпроцесор датчиків), та потребує macOS 14 або новішої версії. Якщо у вашому Mac немає такого датчика, Softfold повідомить про це.

| Стан | Моделі |
| --- | --- |
| Працює, підтверджено користувачами | 14" та 16" MacBook Pro з M1 Pro або M1 Max (2021), M2 Max (2023), M3 Pro або M3 Max (2023), M4 Pro або M4 Max (2024). MacBook Air з M4 (2025) або M5 |
| Датчик є, ще не підтверджено | 14" MacBook Pro з M3, M4 або M5. 14" та 16" MacBook Pro з M5 Pro або M5 Max. MacBook Air з M2 або M3 |
| Не підтримується | MacBook Air з M1, усі 13" MacBook Pro (Intel, M1 та M2), MacBook Pro з процесорами Intel, 12" MacBook, MacBook Neo, настільні комп'ютери Mac |

16-дюймовий MacBook Pro 2019 року також має цей датчик, проте випущена версія скомпільована виключно для архітектури Apple Silicon.

Не впевнені? Виконайте цю команду в Терміналі. Рядок, що закінчується на «las», означає, що Softfold може зчитувати датчик вашої кришки:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Спробували на моделі із середнього рядка? [Поділіться своїм досвідом](https://github.com/ReffWu/softfold/issues).

## Як це працює

Softfold зчитує кут нахилу кришки через IOKit HID із точністю до сотих часток градуса, підлаштовуючись під власну частоту оновлення датчика. Фільтр із критичним затуханням перетворює показники на плавний, органічний рух. Повільний нахил - м'яке згортання. Швидкий жест - миттєва реакція. Якщо ви затримаєтеся на півдорозі на секунду, робочий стіл лагідно відновить різкість, і знову почне згортатися, щойно ви продовжите закривати кришку.

ScreenCaptureKit передає потік робочого столу в реальному часі, а графічний рушій Metal візуалізує перспективу, прогресивне розмиття та бічні переходи зі стабільною швидкістю 60 кадрів/с. Захоплення екрана активне лише під час руху або в складеному стані та припиняється за кілька секунд після повного відкриття, завдяки чому помаранчевий індикатор запису в macOS гасне. Кадри обробляються виключно в оперативній пам'яті вашого Mac і ніколи не зберігаються на диск і не завантажуються в мережу. Раз на день Softfold надсилає анонімний сигнал із випадковим ідентифікатором інсталяції, версіями програми та macOS, моделлю Mac і фактом використання ефекту, виключно для оцінки кількості активних пристроїв. Жоден вміст екрана, файли, IP-адреси чи персональні дані не зберігаються. Ви можете вимкнути збір статистики у вікні програми будь-коли.

Повний опис фізики руху наведено в документі [MOTION.md](../../MOTION.md).

## Збірка з вихідного коду

Установіть Xcode, потім виконайте:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Перевірки розробки описано в [CHECKS.md](../../CHECKS.md), а підписані випуски - в [RELEASE.md](../../RELEASE.md).

## Співпраця

Ідеї, повідомлення про помилки та pull request-и завжди вітаються. [Створіть issue](https://github.com/ReffWu/softfold/issues) або надішліть pull request.

## Подяки

Softfold виник як форк проєкту [Hinge](https://github.com/Noveum/hinge) від Noveum.ai під ліцензією MIT. Ідентифікатори HID та формат звітів датчика кута нахилу кришки вперше описано в проєкті [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Ліцензія

[MIT](../../LICENSE)
