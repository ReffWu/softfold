<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**أغلق الشاشة، وسيطوى سطح مكتبك برقة وهدوء.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="تنزيل Softfold لأجهزة Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>مجاني · أجهزة MacBook بشريحة Apple Silicon · نظام macOS 14 أو أحدث · موثق ومعتمد من Apple</sub>

<sub>إذا أعجبك Softfold، فإن وضع ⭐ على GitHub يساعد المزيد من الأشخاص على اكتشافه.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · [Polski](README.pl.md) · العربية · [Tiếng Việt](README.vi.md) · [🌍 جميع اللغات الـ 39](docs/locales/README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="أغلق الشاشة، وسيطوى سطح مكتبك برقة وهدوء.">
  </picture>
</p>

---

يتحرك Softfold بتناغم تام مع مفصل شاشة جهاز MacBook الخاص بك. كلما أنزلت الشاشة، يميل سطح مكتبك الحي إلى الخلف برقة، ويتلاشى تدريجياً من الأعلى ليذوب في الحواف الداكنة. ارفع الشاشة مجدداً وسيعود كل شيء كما كان، بدقة كاملة وفي نفس الموضع الذي تركته تماماً.

## التنزيل والاستخدام

[قم بتنزيل Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg)، وافتحه ثم اسحب Softfold إلى مجلد التطبيقات (Applications). التطبيق موقّع برمز Developer ID وموثق رسمياً من Apple، لذا يفتح بسلاسة وأمان كأي تطبيق أصلي على Mac.

عند التشغيل لأول مرة، اسمح بصلاحية «تسجيل الشاشة» من إعدادات النظام، وأعد فتح Softfold إذا طلب macOS ذلك، ثم قم بتفعيله. بعد ذلك سيبدأ تلقائياً مع تشغيل جهاز Mac ويبقى جاهزاً للاستخدام.

في المرة الأولى لتفعيل Softfold، يتخذ التطبيق من زاوية الشاشة الحالية زاوية الفتح المعتمدة. لتغييرها لاحقاً، اضبط الشاشة على الزاوية التي تناسبك واضغط على **استخدام الزاوية الحالية**. يتيح لك الاختصار <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> تشغيل التأثير أو إيقافه في أي وقت ومن أي مكان.

## موديلات MacBook المتوافقة

يتطلب Softfold مستشعر زاوية الشاشة الذي أضافته Apple منذ عام 2019 (المتاح في أجهزة Apple Silicon عبر معالج المستشعرات المساعد)، بالإضافة إلى macOS 14 أو أحدث. إذا كان جهازك لا يحتوي على هذا المستشعر، فسيخبرك Softfold بذلك مباشرة.

| الحالة | الموديلات |
| --- | --- |
| يعمل، مؤكد من قبل المستخدمين | MacBook Pro مقاس 14 و16 بوصة بمعالج M1 Pro أو M1 Max (2021)، M2 Max (2023)، M3 Pro أو M3 Max (2023)، M4 Pro أو M4 Max (2024). MacBook Air بمعالج M4 (2025) أو M5 |
| يحتوي على المستشعر، غير مؤكد بعد | MacBook Pro مقاس 14 بوصة بمعالج M3 أو M4 أو M5. MacBook Pro مقاس 14 و16 بوصة بمعالج M5 Pro أو M5 Max. MacBook Air بمعالج M2 أو M3 |
| غير مدعوم | MacBook Air بمعالج M1، جميع أجهزة MacBook Pro مقاس 13 بوصة (Intel وM1 وM2)، أجهزة MacBook Pro بمعالجات Intel، MacBook مقاس 12 بوصة، MacBook Neo، أجهزة Mac المكتبية |

يحتوي جهاز MacBook Pro مقاس 16 بوصة لعام 2019 على هذا المستشعر أيضاً، إلا أن النسخة المطروحة مصممة حصرياً لأجهزة Apple Silicon.

لست متأكداً؟ شغّل هذا الأمر في مبنى الأوامر Terminal. ظهور سطر ينتهي بـ «las» يعني أن Softfold يمكنه قراءة زاوية شاشتك:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

هل جربته على طراز من الصف الأوسط؟ [شاركنا تجربتك](https://github.com/ReffWu/softfold/issues).

## كيف يعمل؟

يقرأ Softfold زاوية الشاشة عبر IOKit HID بدقة تصل إلى جزء من مئة من الدرجة، متبعاً تردد التحديث التلقائي للمستشعر بدلاً من الاستعلام المتكرر العشوائي. يقوم مرشح تخميد دقيق بتحويل هذه القراءات إلى حركة انسيابية عضوية. خفض بطيء يعني طياً هادئاً، وخفض سريع يعني طياً فورياً. إذا توقفت في منتصف الحركة لثانية واحدة، يستعيد سطح المكتب وضوحه بهدوء، ثم يكمل الطي بمجرد متابعة الإغلاق.

يوفر ScreenCaptureKit بثاً مباشراً لسطح المكتب، ويتولى محرك Metal معالجة المنظور والتمويه التدريجي والتعبئة الجانبية بمعدل 60 إطاراً في الثانية. لا يعمل التقاط الشاشة إلا أثناء حركة الشاشة أو عندما تكون مطوية، ويتوقف تماماً بعد ثوانٍ من إعادة فتحها، مما يؤدي أيضاً إلى إخفاء مؤشر التسجيل البرتقالي في macOS. تبقى الإطارات في الذاكرة العشوائية للجهاز فقط ولا يتم تسجيلها أو حفظها على القرص أو رفعها إطلاقاً. يرسل Softfold نبضة دورية مجهولة الهوية بمعرّف تثبيت عشوائي وإصدار التطبيق ونظام macOS وطراز الجهاز وما إذا تم استخدام التأثير في ذلك اليوم، وذلك لتقدير عدد الأجهزة النشطة فقط. لا يتم تخزين أي محتوى للشاشة أو ملفات أو عناوين IP أو بيانات شخصية. يمكنك إيقاف ذلك عبر إلغاء تفعيل «مشاركة إحصاءات الاستخدام المجهولة» من نافذة التطبيق في أي وقت.

تفاصيل التصميم الحركي كاملة متاحة في [MOTION.md](MOTION.md).

## اللغات المدعومة

الإنجليزية، الصينية المبسطة، الصينية التقليدية، اليابانية، الكورية، الألمانية، الفرنسية، الإسبانية، الإيطالية، البرتغالية البرازيلية، الروسية، الهولندية، التركية، البولندية، العربية، والفيتنامية. يتبع Softfold لغة النظام تلقائياً أو يمكنك اختيار لغتك المفضلة من نافذة التطبيق.

## البناء من المصدر

قم بتثبيت Xcode، ثم نفّذ الأوامر التالية:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

تم توثيق اختبارات التطوير في [CHECKS.md](CHECKS.md)، وإجراءات الإصدارات الموقعة في [RELEASE.md](RELEASE.md).

## المساهمة في المشروع

نرحب بجميع الأفكار وبلاغات الأخطاء وطلبات السحب (Pull Requests). [افتح تذكرة (Issue)](https://github.com/ReffWu/softfold/issues) أو أرسل مساهمتك.

## شكر وتقدير

بدأ Softfold كاشتقاق (Fork) من مشروع [Hinge](https://github.com/Noveum/hinge) من Noveum.ai بموجب ترخيص MIT. تم توثيق معرّفات HID لمستشعر زاوية الشاشة وهيكل البيانات لأول مرة بواسطة مشروع [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## الترخيص

[MIT](LICENSE)
