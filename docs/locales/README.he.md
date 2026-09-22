<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**הורידו את המסך, ושולחן העבודה שלכם יתקפל ברכות.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="הורדת Softfold עבור Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>חינם · מחשבי MacBook עם Apple Silicon · מערכת macOS 14 ומעלה · מאומת על ידי Apple</sub>

<sub>אם אהבתם את Softfold, סימון ⭐ ב-GitHub יעזור למשתמשים נוספים להכיר אותו.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · עברית · [🌍 כל השפות](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="הורידו את המסך, ושולחן העבודה שלכם יתקפל ברכות.">
  </picture>
</p>

---

Softfold עוקב בהרמוניה מושלמת אחר ציר המסך של ה-MacBook שלכם. כאשר אתם מורידים את המסך, שולחן העבודה הפעיל נוטה לאחור ביחד איתו, מיטשטש בהדרגה מלמעלה ונמוג אל הקצוות הכהים. הרימו את המסך שוב והכל ישוב לחדות מלאה, בדיוק במקום שבו עזבתם.

## הורדה

[הורידו את Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), פתחו את הקובץ וגררו את Softfold לתיקיית היישומים (Applications). היישום חתום באמצעות Developer ID ומאומת על ידי Apple, ונפתח בבטחה כמו כל יישום Mac רגיל.

בהפעלה הראשונה יש לאשר «הקלטת מסך» בהגדרות המערכת, לפתוח מחדש את Softfold במידת הצורך ולהפעיל אותו. מכאן ואילך הוא יפעל אוטומטית בכל הפעלה של ה-Mac.

בפעם הראשונה שתפעילו את Softfold, זווית המסך הנוכחית תיקבע כזווית הפתיחה. כדי לשנות זאת בהמשך, כוונו את המסך לזווית הרצויה ולחצו על **השתמש בזווית הנוכחית**. קיצור המקשים <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> מאפשר להפעיל או לכבות את האפקט בכל רגע.

## דגמי MacBook נתמכים

Softfold דורש את חיישן זווית המכסה שנוסף על ידי Apple החל משנת 2019 ומערכת macOS 14 ומעלה. אם ב-Mac שלכם אין חיישן זה, Softfold יודיע לכם על כך מיד.

| סטטוס | דגמים |
| --- | --- |
| פועל, אומת על ידי משתמשים | MacBook Pro בגודל 14" ו-16" עם M1 Pro או M1 Max (2021), M2 Max (2023), M3 Pro או M3 Max (2023), M4 Pro או M4 Max (2024). MacBook Air עם M4 (2025) או M5 |
| החיישן קיים, טרם אומת | MacBook Pro בגודל 14" עם M3, M4 או M5. MacBook Pro בגודל 14" ו-16" עם M5 Pro או M5 Max. MacBook Air עם M2 או M3 |
| אינו נתמך | MacBook Air עם M1, כל דגמי MacBook Pro בגודל 13", דגמי Intel, MacBook 12", MacBook Neo, מחשבי Mac שולחניים |

ב-MacBook Pro בגודל 16 אינץ' מ-2019 קיים החיישן, אך הגרסה הרשמית מהודרת בלעדית עבור מעבדי Apple Silicon.

אינכם בטוחים? הריצו פקודה זו ב-Terminal. שורה המסתימת ב-«las» מאשרת ש-Softfold מסוגל לתקשר עם החיישן שלכם:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

בדקתם על דגם מהשורה האמצעית? [שתפו אותנו בחוויה שלכם](https://github.com/ReffWu/softfold/issues).

## כיצד זה עובד

התוכנה קוראת את זווית הציר דרך IOKit HID בדיוק של מאיות המעלה, ומתאימה את עצמה לתדירות הרענון של החיישן. מסנן ריסון קריטי מתרגם את הנתונים לתנועה אורגנית ורציפה. הטיה אטית יוצרת קיפול עדין; תנועה מהירה מביאה לתגובה מידית. אם תעצרו לרגע באמצע, שולחן העבודה יחזור לחדות באופן חלק, וימשיך להתקפל ברגע שתמשיכו לסגור.

ScreenCaptureKit מספק את תצוגת שולחן העבודה ומנוע Metal מעבד את הפרספקטיבה בקצב יציב של 60 פריימים לשנייה. לכידת המסך פועלת רק בעת תנועה ומפסיקה שניות לאחר הפתיחה. התמונות מעובדות בזיכרון ה-RAM בלבד ואינן נשמרות לעולם. פעם ביום נשלח אות אנונימי לצורך הערכת מכשירים פעילים. שום מידע אישי אינו נאסף.

תכנון התנועה המלא מפורט ב-[MOTION.md](../../MOTION.md).

## הידור מקוד המקור

התקינו את Xcode ולאחר מכן הריצו:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

בדיקות הפיתוח מתוארות ב-[CHECKS.md](../../CHECKS.md) והפצות חתומות ב-[RELEASE.md](../../RELEASE.md).

## תרומה לפרויקט

רעיונות, דיווחי תקלות ובקשות משיכה (pull requests) יתקבלו בברכה. [פתחו issue](https://github.com/ReffWu/softfold/issues) או שלחו pull request.

## תודות

פרויקט Softfold החל כפיצול (fork) מ-[Hinge](https://github.com/Noveum/hinge) מאת Noveum.ai ברישיון MIT. מזהי החיישן תועדו לראשונה על ידי פרויקט [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## רישיון

[MIT](../../LICENSE)
