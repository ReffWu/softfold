#!/usr/bin/env python3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

LANGUAGES = [
    {
        "code": "en",
        "name": "English",
        "flag": "🇺🇸",
        "notes": [
            "Fixed Touch ID & Apple Pay compatibility: Desktop overlay now stays hidden off-screen while the lid is open, preventing macOS anti-overlay security policies from suppressing biometric prompts.",
            "Optimized canvas state management during Mission Control Spaces switching and sleep-wake cycles.",
        ],
    },
    {
        "code": "zh-Hans",
        "name": "简体中文",
        "flag": "🇨🇳",
        "notes": [
            "彻底修复 Touch ID 与 Apple Pay 兼容性：优化折叠画布生命周期，未合盖时保持离屏隐藏，杜绝触发 macOS 防覆盖安全保护导致生物识别提示被阻断。",
            "优化 Spaces 多桌面切换与系统睡眠唤醒时的画布状态管理。",
        ],
    },
    {
        "code": "zh-Hant",
        "name": "繁體中文",
        "flag": "🇭🇰",
        "notes": [
            "徹底修復 Touch ID 與 Apple Pay 相容性：最佳化折疊畫布生命週期，未闔蓋時保持離屏隱藏，杜絕觸發 macOS 防覆蓋安全保護導致生物辨識提示被阻斷。",
            "最佳化 Spaces 多桌面切換與系統睡眠喚醒時的畫布狀態管理。",
        ],
    },
    {
        "code": "ja",
        "name": "日本語",
        "flag": "🇯🇵",
        "notes": [
            "Touch ID および Apple Pay との互換性を修正：開蓋時はオーバーレイウインドウを画面外に非表示にし、macOS のセキュリティポリシーによる生体認証の阻害を防止しました。",
            "Spaces（操作スペース）の切り替え時およびスリープ復帰時における描画レイヤー管理を最適化。",
        ],
    },
    {
        "code": "ko",
        "name": "한국어",
        "flag": "🇰🇷",
        "notes": [
            "Touch ID 및 Apple Pay 호환성 해결: 상판이 열려 있을 때는 오버레이 창을 화면에서 완전히 숨겨 macOS 보안 정책으로 인한 생체 인식 차단을 방지했습니다.",
            "Spaces 다중 데스크탑 전환 및 잠자기 해제 시의 렌더링 캔버스 상태 관리 최적화.",
        ],
    },
    {
        "code": "de",
        "name": "Deutsch",
        "flag": "🇩🇪",
        "notes": [
            "Touch ID & Apple Pay-Kompatibilität behoben: Das Desktop-Overlay bleibt bei geöffnetem Display ausgeblendet, um eine Blockierung der biometrischen Authentifizierung durch macOS-Sicherheitsrichtlinien zu verhindern.",
            "Zustandsverwaltung bei Spaces-Wechseln und Ruhezustand-Wiederaufnahme optimiert.",
        ],
    },
    {
        "code": "fr",
        "name": "Français",
        "flag": "🇫🇷",
        "notes": [
            "Compatibilité Touch ID et Apple Pay corrigée : la superposition d’écran reste masquée lorsque l’écran est ouvert, évitant ainsi le blocage des invites biométriques par la sécurité macOS.",
            "Gestion optimisée de l’état du rendu lors du basculement d’espaces Spaces et de la sortie de veille.",
        ],
    },
    {
        "code": "es",
        "name": "Español",
        "flag": "🇪🇸",
        "notes": [
            "Compatibilidad con Touch ID y Apple Pay corregida: la capa superpuesta permanece oculta cuando la tapa está abierta, evitando que las directivas de seguridad de macOS bloqueen la autenticación biométrica.",
            "Gestión optimizada del lienzo durante el cambio de Spaces y la reactivación tras el reposo.",
        ],
    },
    {
        "code": "it",
        "name": "Italiano",
        "flag": "🇮🇹",
        "notes": [
            "Compatibilità con Touch ID e Apple Pay risolta: l’overlay dello schermo rimane nascosto a coperchio aperto, evitando che le policy di sicurezza di macOS blocchino i prompt biometrici.",
            "Gestione dello stato del canvas ottimizzata durante il cambio di Spaces e il risveglio dallo stop.",
        ],
    },
    {
        "code": "pt-BR",
        "name": "Português (Brasil)",
        "flag": "🇧🇷",
        "notes": [
            "Compatibilidade com Touch ID e Apple Pay corrigida: a sobreposição permanece oculta enquanto a tampa estiver aberta, evitando o bloqueio da biometria pelas políticas de segurança do macOS.",
            "Gerenciamento aprimorado de tela durante a alternância de Spaces e o retorno do repouso.",
        ],
    },
    {
        "code": "ru",
        "name": "Русский",
        "flag": "🇷🇺",
        "notes": [
            "Исправлена совместимость с Touch ID и Apple Pay: окно наложения скрывается при открытой крышке, что предотвращает блокировку биометрии политиками безопасности macOS.",
            "Оптимизировано управление состоянием экрана при переключении рабочих столов Spaces и выходе из режима сна.",
        ],
    },
    {
        "code": "nl",
        "name": "Nederlands",
        "flag": "🇳🇱",
        "notes": [
            "Compatibiliteit met Touch ID en Apple Pay hersteld: de overlay blijft verborgen wanneer het scherm open is, waardoor biometrische verificatie niet langer wordt geblokkeerd.",
            "Statusbeheer geoptimaliseerd bij het wisselen van Spaces en het ontwaken uit de sluimerstand.",
        ],
    },
    {
        "code": "tr",
        "name": "Türkçe",
        "flag": "🇹🇷",
        "notes": [
            "Touch ID ve Apple Pay uyumluluğu düzeltildi: Kapak açıkken katman gizli tutularak macOS güvenlik politikalarının biyometrik doğrulamayı engellemesi önlendi.",
            "Spaces masaüstü geçişleri ve uyku modundan çıkış sırasında tuval durum yönetimi optimize edildi.",
        ],
    },
    {
        "code": "pl",
        "name": "Polski",
        "flag": "🇵🇱",
        "notes": [
            "Naprawiono zgodność z Touch ID i Apple Pay: nakładka pozostaje ukryta przy otwartej pokrywie, zapobiegając blokowaniu uwierzytelniania biometrycznego przez mechanizmy bezpieczeństwa macOS.",
            "Zoptymalizowano zarządzanie stanem warstwy podczas przełączania Spaces i wybudzania komputera.",
        ],
    },
    {
        "code": "ar",
        "name": "العربية",
        "flag": "🇸🇦",
        "notes": [
            "إصلاح التوافق مع Touch ID و Apple Pay: تظل نافذة التراكب مخفية أثناء فتح الغطاء، مما يمنع سياسات أمان macOS من حظر المصادقة الحيوية.",
            "تحسين إدارة طبقة العرض أثناء التنقل بين مساحات Spaces والاستيقاظ من وضع السكون.",
        ],
    },
    {
        "code": "vi",
        "name": "Tiếng Việt",
        "flag": "🇻🇳",
        "notes": [
            "Khắc phục khả năng tương thích với Touch ID & Apple Pay: Lớp phủ màn hình luôn được ẩn khi nắp máy mở, tránh kích hoạt chính sách bảo mật của macOS gây chặn xác thực sinh trắc học.",
            "Tối ưu hóa quản lý trạng thái hiển thị khi chuyển đổi Spaces và đánh thức máy.",
        ],
    },
    {
        "code": "sv",
        "name": "Svenska",
        "flag": "🇸🇪",
        "notes": [
            "Touch ID- och Apple Pay-kompatibilitet åtgärdad: Överlägget förblir dolt när skärmen är öppen, vilket förhindrar att macOS säkerhetspolicy blockerar biometrisk autentisering.",
            "Optimerad tillståndshantering vid byte av Spaces och återaktivering från vila.",
        ],
    },
    {
        "code": "nb",
        "name": "Norsk Bokmål",
        "flag": "🇳🇴",
        "notes": [
            "Touch ID- og Apple Pay-kompatibilitet rettet: Skjermoverlegget forblir skjult når lokket er åpent, slik at macOS-sikkerhet ikke blokkerer biometrisk verifisering.",
            "Optimalisert tilstandshåndtering under bytte av Spaces og ved oppvåkning fra dvale.",
        ],
    },
    {
        "code": "da",
        "name": "Dansk",
        "flag": "🇩🇰",
        "notes": [
            "Touch ID og Apple Pay-kompatibilitet rettet: Skærmoverlejringen forbliver skjult, når låget er åbent, så macOS-sikkerhedspolitik ikke blokerer biometrisk godkendelse.",
            "Optimeret tilstandshåndtering ved skift af Spaces og opvågning fra vågeblus.",
        ],
    },
    {
        "code": "fi",
        "name": "Suomi",
        "flag": "🇫🇮",
        "notes": [
            "Touch ID- ja Apple Pay -yhteensopivuus korjattu: Kerros pysyy piilossa kannen ollessa auki, mikä estää macOS:n tietoturvaa estämästä biometristä tunnistautumista.",
            "Optimoitu tilanhallinta Spaces-työpöytien vaihdossa ja lepotilasta herätessä.",
        ],
    },
    {
        "code": "uk",
        "name": "Українська",
        "flag": "🇺🇦",
        "notes": [
            "Виправлено сумісність із Touch ID та Apple Pay: оверлей залишається прихованим при відкритій кришці, що запобігає блокуванню біометрії політикою безпеки macOS.",
            "Оптимізовано керування станом полотна під час перемикання Spaces та виходу зі сну.",
        ],
    },
    {
        "code": "cs",
        "name": "Čeština",
        "flag": "🇨🇿",
        "notes": [
            "Opravena kompatibilita s Touch ID a Apple Pay: překryvná vrstva zůstává při otevřeném víku skrytá, což brání bezpečnostním zásadám macOS v blokování biometrického ověření.",
            "Optimalizována správa stavu při přepínání ploch Spaces a probuzení z režimu spánku.",
        ],
    },
    {
        "code": "ro",
        "name": "Română",
        "flag": "🇷🇴",
        "notes": [
            "Compatibilitate Touch ID și Apple Pay rezolvată: stratul suprapus rămâne ascuns când ecranul este deschis, prevenind blocarea autentificării biometrice de către securitatea macOS.",
            "Gestionare optimizată a stării ecranului la comutarea între Spaces și revenirea din repaus.",
        ],
    },
    {
        "code": "hu",
        "name": "Magyar",
        "flag": "🇭🇺",
        "notes": [
            "Javított Touch ID és Apple Pay kompatibilitás: az átfedő ablak rejtve marad nyitott fedél esetén, megelőzve a biometrikus hitelesítés blokkolását a macOS biztonsági mechanizmusai által.",
            "Optimalizált állapotkezelés a Spaces váltásakor és alvó állapotból való ébredéskor.",
        ],
    },
    {
        "code": "el",
        "name": "Ελληνικά",
        "flag": "🇬🇷",
        "notes": [
            "Διορθώθηκε η συμβατότητα με Touch ID και Apple Pay: η επικάλυψη παραμένει κρυφή όσο το καπάκι είναι ανοιχτό, αποτρέποντας τον αποκλεισμό της βιομετρικής πιστοποίησης από το macOS.",
            "Βελτιστοποιήθηκε η διαχείριση κατάστασης κατά την εναλλαγή Spaces και την αφύπνιση.",
        ],
    },
    {
        "code": "hi",
        "name": "हिन्दी",
        "flag": "🇮🇳",
        "notes": [
            "Touch ID और Apple Pay संगतता ठीक की गई: ढक्कन खुला रहने पर ओवरले छिपा रहता है, जिससे macOS सुरक्षा नीतियां बायोमेट्रिक प्रमाणीकरण को अवरुद्ध नहीं करती हैं।",
            "Spaces डेस्कटॉप बदलने और स्लीप से जागने के दौरान स्क्रीन स्थिति प्रबंधन में सुधार।",
        ],
    },
    {
        "code": "bn",
        "name": "বাংলা",
        "flag": "🇧🇩",
        "notes": [
            "Touch ID এবং Apple Pay সামঞ্জস্যতা ঠিক করা হয়েছে: ঢাকনা খোলা থাকার সময় ওভারলে উইন্ডো লুকানো থাকে যাতে বায়োমেট্রিক প্রম্পট বাধাপ্রাপ্ত না হয়।",
            "Spaces পরিবর্তন এবং স্লিপ মোড থেকে ওঠার সময় ক্যানভাস নিয়ন্ত্রণ উন্নত করা হয়েছে।",
        ],
    },
    {
        "code": "ta",
        "name": "தமிழ்",
        "flag": "🇮🇳",
        "notes": [
            "Touch ID மற்றும் Apple Pay இணக்கத்தன்மை சரிசெய்யப்பட்டது: மூடி திறந்திருக்கும் போது மேலடுக்கு மறைக்கப்பட்டு, பயோமெட்ரிக் அங்கீகாரம் தடைபடாமல் தடுக்கப்படுகிறது.",
            "Spaces டெஸ்க்டாப் மாற்றம் மற்றும் உறக்கத்திலிருந்து எழும்போது திரையின் நிலை மேம்படுத்தப்பட்டது.",
        ],
    },
    {
        "code": "ur",
        "name": "اردو",
        "flag": "🇵🇰",
        "notes": [
            "Touch ID اور Apple Pay مطابقت درست کی گئی: ڈھکن کھلا ہونے پر اوورلے چھپا رہتا ہے تاکہ بائیو میٹرک تصدیق میں رکاوٹ نہ آئے۔",
            "Spaces ڈیسک ٹاپ سوئچنگ اور سلیپ موڈ کے دوران ڈسپلے کی کارکردگی بہتر بنائی گئی۔",
        ],
    },
    {
        "code": "fa",
        "name": "فارسی",
        "flag": "🇮🇷",
        "notes": [
            "رفع مشکل سازگاری با Touch ID و Apple Pay: لایه همپوشانی در زمان باز بودن درب مخفی می‌ماند تا از مسدود شدن تأیید هویت بیومتریک جلوگیری شود.",
            "بهینه‌سازی مدیریت وضعیت لایه در هنگام جابه‌جایی بین Spaces و بیداری از حالت خواب.",
        ],
    },
    {
        "code": "he",
        "name": "עברית",
        "flag": "🇮🇱",
        "notes": [
            "תוקנה תאימות Touch ID ו-Apple Pay: שכבת התצוגה נשארת מוסתרת כשהמכסה פתוח, כדי למנוע ממדיניות האבטחה של macOS לחסום אימות ביומטרי.",
            "ניהול מצב תצוגה מותאם בעת מעבר בין Spaces והתעוררות משינה.",
        ],
    },
    {
        "code": "th",
        "name": "ไทย",
        "flag": "🇹🇭",
        "notes": [
            "แก้ไขความเข้ากันได้กับ Touch ID และ Apple Pay: หน้าต่างซ้อนทับจะถูกซ่อนไว้เมื่อเปิดฝาจอ ป้องกันไม่ให้ระบบความปลอดภัยของ macOS ปิดกั้นการยืนยันตัวตนด้วยลายนิ้วมือ",
            "ปรับปรุงการจัดการสถานะหน้าจอขณะสลับ Spaces และปลุกเครื่องจากโหมดสลีป",
        ],
    },
    {
        "code": "id",
        "name": "Bahasa Indonesia",
        "flag": "🇮🇩",
        "notes": [
            "Kompatibilitas Touch ID & Apple Pay diperbaiki: Hamparan layar tetap tersembunyi saat layar terbuka, mencegah kebijakan keamanan macOS memblokir autentikasi biometrik.",
            "Pengelolaan status kanvas dioptimalkan saat berpindah Spaces dan bangun dari mode tidur.",
        ],
    },
    {
        "code": "ms",
        "name": "Bahasa Melayu",
        "flag": "🇲🇾",
        "notes": [
            "Keserasian Touch ID & Apple Pay diperbaiki: Lapisan paparan kekal tersembunyi semasa penutup dibuka, mengelakkan dasar keselamatan macOS daripada menyekat pengesahan biometrik.",
            "Pengurusan status kanvas dioptimumkan semasa bertukar Spaces dan bangun daripada mod tidur.",
        ],
    },
    {
        "code": "fil",
        "name": "Filipino",
        "flag": "🇵🇭",
        "notes": [
            "Inayos ang compatibility ng Touch ID at Apple Pay: Nananatiling nakatago ang overlay habang nakabukas ang screen upang maiwasan ang pagharang ng macOS sa biometric prompts.",
            "Na-optimize ang pamamahala ng estado habang lumilipat ng Spaces at gumigising mula sa sleep.",
        ],
    },
    {
        "code": "sw",
        "name": "Kiswahili",
        "flag": "🇰🇪",
        "notes": [
            "Upatanifu wa Touch ID na Apple Pay umerekebishwa: Dirisha la kufunika linabaki limefichwa skrini ikiwa wazi, kuzuia usalama wa macOS kuzuia uthibitishaji wa alama ya kidole.",
            "Usimamizi wa hali ya skrini umeboreshwa wakati wa kubadilisha Spaces na kuamka kutoka usingizini.",
        ],
    },
    {
        "code": "af",
        "name": "Afrikaans",
        "flag": "🇿🇦",
        "notes": [
            "Touch ID- en Apple Pay-versoenbaarheid herstel: Oorleg bly versteek terwyl die deksel oop is om te verhoed dat macOS-sekuriteit biometriese verifikasie blokkeer.",
            "Statusbestuur geoptimaliseer tydens die wisseling van Spaces en herstel vanaf slaapmodus.",
        ],
    },
    {
        "code": "la",
        "name": "Lingua Latina",
        "flag": "🏛️",
        "notes": [
            "Compatibilitas Touch ID et Apple Pay correcta: fenestra tegens latet dum operculum patet, ne securitas macOS confirmationem biometricam impediat.",
            "Administratio status screeni inter spatia Spaces mutanda et post somnum optimizata.",
        ],
    },
    {
        "code": "eo",
        "name": "Esperanto",
        "flag": "🟢",
        "notes": [
            "Kongrueco kun Touch ID kaj Apple Pay riparita: La supertavolo restas kaŝita kiam la kovrilo estas malfermita, malhelpante sekurecan blokadon de biometria konfirmo.",
            "Optimumigita statmastrumado dum ŝanĝo de Spaces kaj vekiĝo el dormreĝimo.",
        ],
    },
]


def generate_markdown(version: str) -> str:
    en = next(lang for lang in LANGUAGES if lang["code"] == "en")
    zh = next(lang for lang in LANGUAGES if lang["code"] == "zh-Hans")

    lines = [
        f"## Softfold {version}",
        "",
        "### What's New / 新特性",
        "",
        "**English** 🇺🇸",
        "",
    ]
    for note in en["notes"]:
        lines.append(f"- {note}")

    lines.extend(
        [
            "",
            "**简体中文** 🇨🇳",
            "",
        ]
    )
    for note in zh["notes"]:
        lines.append(f"- {note}")

    lines.extend(
        [
            "",
            "<details>",
            "<summary>🌍 <strong>Read in other languages / 查看其他 37 门语言更新日志</strong></summary>",
            "",
        ]
    )

    for lang in LANGUAGES:
        if lang["code"] in ("en", "zh-Hans"):
            continue
        lines.extend(
            [
                f"### {lang['flag']} {lang['name']}",
                "",
            ]
        )
        for note in lang["notes"]:
            lines.append(f"- {note}")
        lines.append("")

    lines.append("</details>")
    return "\n".join(lines)


def generate_html(version: str) -> str:
    en = next(lang for lang in LANGUAGES if lang["code"] == "en")
    zh = next(lang for lang in LANGUAGES if lang["code"] == "zh-Hans")

    html_parts = [
        '<div style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; font-size: 13px; line-height: 1.5; color: #1d1d1f;">',
        f'<h3 style="margin-top: 0; font-size: 15px; font-weight: 600;">Softfold {version}</h3>',
        '<div style="margin-bottom: 12px;">',
        f'<p style="margin: 4px 0; font-weight: 600;">{zh["flag"]} {zh["name"]}:</p>',
        '<ul style="margin: 4px 0 8px 18px; padding: 0;">',
    ]
    for note in zh["notes"]:
        html_parts.append(f"  <li>{note}</li>")
    html_parts.extend(
        [
            "</ul>",
            "</div>",
            '<div style="margin-bottom: 12px;">',
            f'<p style="margin: 4px 0; font-weight: 600;">{en["flag"]} {en["name"]}:</p>',
            '<ul style="margin: 4px 0 8px 18px; padding: 0;">',
        ]
    )
    for note in en["notes"]:
        html_parts.append(f"  <li>{note}</li>")
    html_parts.extend(
        [
            "</ul>",
            "</div>",
            '<details style="margin-top: 12px; font-size: 12px; color: #515154;">',
            '<summary style="cursor: pointer; font-weight: 500; color: #0066cc;">🌍 All 39 Languages / 全部 39 门语言更新日志</summary>',
            '<div style="max-height: 220px; overflow-y: auto; margin-top: 8px; padding: 8px; background: rgba(0,0,0,0.03); border-radius: 6px;">',
        ]
    )

    for lang in LANGUAGES:
        html_parts.append(
            f'<p style="margin: 6px 0 2px; font-weight: 600;">{lang["flag"]} {lang["name"]}:</p>'
        )
        html_parts.append('<ul style="margin: 2px 0 6px 18px; padding: 0;">')
        for note in lang["notes"]:
            html_parts.append(f"  <li>{note}</li>")
        html_parts.append("</ul>")

    html_parts.extend(["</div>", "</details>", "</div>"])
    return "\n".join(html_parts)


def main():
    version = sys.argv[1] if len(sys.argv) > 1 else "1.19"
    dist_dir = ROOT / "dist"
    dist_dir.mkdir(parents=True, exist_ok=True)
    feed_dir = ROOT / "build" / "feed"
    feed_dir.mkdir(parents=True, exist_ok=True)

    md_content = generate_markdown(version)
    md_file = dist_dir / "release-notes.md"
    md_file.write_text(md_content, encoding="utf-8")
    print(f"Generated {md_file}")

    html_content = generate_html(version)
    html_file = feed_dir / "Softfold.html"
    html_file.write_text(html_content, encoding="utf-8")
    print(f"Generated {html_file}")


if __name__ == "__main__":
    main()
