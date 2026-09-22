#!/usr/bin/env python3
"""Generate multilingual release notes for Softfold releases (All 39 languages)."""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

LANGUAGES = [
    {
        "code": "en",
        "name": "English",
        "flag": "🇺🇸",
        "notes": [
            "Fixed silent startup hotkey: ⌃⌥H now registers immediately on login without opening Settings.",
            "Enhanced termination cleanup: GPU memory and lid sensor are released cleanly on quit/shutdown.",
            "Restored window on Dock click (Apple HIG): clicking Dock icon reopens Settings when closed.",
            "Native support for 39 world languages across app interface and documentation.",
            "Apple platform metadata compliance (NSHumanReadableCopyright and ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "zh-Hans",
        "name": "简体中文",
        "flag": "🇨🇳",
        "notes": [
            "修复开机静默启动快捷键：随系统自启时无需打开设置即可直接使用 ⌃⌥H 开关特效。",
            "完善退出资源回收：在后台静默运行时，退出、注销或关机会彻底释放传感器与显存。",
            "遵循 Apple HIG 窗口唤回体验：设置窗口关闭后，点击 Dock 图标即可平滑唤回主界面。",
            "深度原生支持全球 39 门文明与区域语言。",
            "对齐 Apple 平台规范元数据（NSHumanReadableCopyright 与 ITSAppUsesNonExemptEncryption）。",
        ],
    },
    {
        "code": "zh-Hant",
        "name": "繁體中文",
        "flag": "🇭🇰",
        "notes": [
            "修復開機靜默啟動快捷鍵：隨系統自啟時無需開啟設定即可直接使用 ⌃⌥H 開關特效。",
            "完善結束資源回收：在後台靜默運行時，結束、登出或關機會徹底釋放感測器與顯存。",
            "遵循 Apple HIG 視窗喚回體驗：設定視窗關閉後，點擊 Dock 圖示即可平滑喚回主介面。",
            "深度原生支援全球 39 門文明與區域語言。",
            "對齊 Apple 平台規範元資料（NSHumanReadableCopyright 與 ITSAppUsesNonExemptEncryption）。",
        ],
    },
    {
        "code": "ja",
        "name": "日本語",
        "flag": "🇯🇵",
        "notes": [
            "サイレント起動時のショートカットキーを修正：ログイン項目として起動した際、設定画面を開かずに ⌃⌥H で切り替え可能になりました。",
            "終了時のリソース解放を強化：バックグラウンド実行時のログアウトやシャットダウン時にも、センサーと GPU メモリを確実に解放します。",
            "Apple HIG に準拠したウインドウ再表示：設定ウインドウを閉じた後、Dock アイコンをクリックして即座に再表示できます。",
            "アプリ内外で世界 39 言語のネイティブ対応を完了。",
            "Apple プラットフォームのメタデータ標準（著作権表記および暗号化コンプライアンス）に準拠。",
        ],
    },
    {
        "code": "ko",
        "name": "한국어",
        "flag": "🇰🇷",
        "notes": [
            "백그라운드 시작 시 단축키 동작 수정: 설정 창을 열지 않고도 로그인 즉시 ⌃⌥H 단축키를 사용할 수 있습니다.",
            "앱 종료 시 리소스 정리 강화: 백그라운드 상태에서 종료, 로그아웃 또는 시스템 종료 시 센서와 GPU 메모리를 완전히 해제합니다.",
            "Apple HIG 창 다시 열기 지원: 설정 창이 닫힌 상태에서 Dock 아이콘을 클릭하면 창이 부드럽게 다시 열립니다.",
            "앱 및 문서 전반에 걸쳐 39개 언어를 네이티브로 완벽 지원.",
            "Apple 플랫폼 메타데이터 표준 준수(저작권 표기 및 암호화 준수 선언 추가).",
        ],
    },
    {
        "code": "de",
        "name": "Deutsch",
        "flag": "🇩🇪",
        "notes": [
            "Tastaturkurzbefehl beim Hintergrundstart korrigiert: ⌃⌥H reagiert nun sofort beim Systemstart, ohne dass das Einstellungsfenster geöffnet werden muss.",
            "Bereinigung beim Beenden verbessert: Sensor und GPU-Speicher werden beim Abmelden oder Herunterfahren vollständig freigegeben.",
            "Fenster nach Apple HIG wieder öffnen: Klick auf das Dock-Symbol stellt das geschlossene Einstellungsfenster wieder her.",
            "Vollständige native Unterstützung für 39 Weltsprachen.",
            "Apple-Metadatenstandards erfüllt (NSHumanReadableCopyright und ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "fr",
        "name": "Français",
        "flag": "🇫🇷",
        "notes": [
            "Raccourci corrigé au démarrage en arrière-plan : ⌃⌥H fonctionne dès la connexion sans avoir à ouvrir les Réglages.",
            "Libération complète des ressources à la fermeture : le capteur et la mémoire GPU sont parfaitement libérés à l'arrêt ou à la déconnexion.",
            "Réouverture de fenêtre selon les Apple HIG : un clic sur l'icône du Dock rouvre la fenêtre fermée.",
            "Prise en charge native de 39 langues mondiales dans l'application et la documentation.",
            "Conformité aux métadonnées Apple (NSHumanReadableCopyright et ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "es",
        "name": "Español",
        "flag": "🇪🇸",
        "notes": [
            "Atajo corregido en inicio silencioso: ⌃⌥H responde de inmediato al iniciar sesión sin necesidad de abrir Ajustes.",
            "Liberación de recursos mejorada al salir: el sensor y la memoria GPU se liberan completamente al cerrar sesión o apagar el equipo.",
            "Reapertura de ventana según Apple HIG: hacer clic en el icono del Dock vuelve a abrir la ventana de ajustes.",
            "Soporte nativo para 39 idiomas en la app y la documentación.",
            "Cumplimiento de estándares de metadatos de Apple (NSHumanReadableCopyright e ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "it",
        "name": "Italiano",
        "flag": "🇮🇹",
        "notes": [
            "Scorciatoia corretta all'avvio in background: ⌃⌥H risponde subito al login senza dover aprire Impostazioni.",
            "Pulizia risorse perfezionata alla chiusura: sensore e memoria GPU vengono rilasciati completamente allo spegnimento.",
            "Riapertura finestra conforme ad Apple HIG: clic sull'icona nel Dock per riaprire le Impostazioni.",
            "Supporto nativo a 39 lingue mondiali nell'app e nella documentazione.",
            "Conformità ai metadati Apple (NSHumanReadableCopyright e ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "pt-BR",
        "name": "Português (Brasil)",
        "flag": "🇧🇷",
        "notes": [
            "Atalho corrigido na inicialização em segundo plano: ⌃⌥H agora responde imediatamente ao iniciar sessão sem precisar abrir Ajustes.",
            "Limpeza de recursos aprimorada ao encerrar: o sensor e a memória GPU são liberados completamente ao desligar o Mac.",
            "Reabertura de janela conforme Apple HIG: clicar no ícone do Dock reabre a janela fechada.",
            "Suporte nativo completo a 39 idiomas mundiais.",
            "Conformidade com padrões de metadados da Apple (NSHumanReadableCopyright e ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "ru",
        "name": "Русский",
        "flag": "🇷🇺",
        "notes": [
            "Исправлено сочетание клавиш при автозапуске: ⌃⌥H теперь работает сразу после входа в систему без открытия Настроек.",
            "Надежное освобождение ресурсов: датчик и видеопамять полностью освобождаются при выходе или выключении.",
            "Восстановление окна по Apple HIG: клик по значку в Dock открывает закрытое окно настроек.",
            "Полная встроенная поддержка 39 языков мира.",
            "Соответствие стандартам метаданных Apple (NSHumanReadableCopyright и ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "nl",
        "name": "Nederlands",
        "flag": "🇳🇱",
        "notes": [
            "Sneltoets hersteld bij achtergrondstart: ⌃⌥H reageert direct na inloggen zonder Instellingen te openen.",
            "Geheugenopruiming bij afsluiten verbeterd: sensor en GPU-geheugen worden volledig vrijgegeven.",
            "Venster heropenen volgens Apple HIG: klik op het Dock-symbool herstelt het instellingenvenster.",
            "Volledige native ondersteuning voor 39 wereldtalen.",
            "Apple metadatastandaarden toegevoegd (NSHumanReadableCopyright en ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "tr",
        "name": "Türkçe",
        "flag": "🇹🇷",
        "notes": [
            "Arka planda başlatma kısayolu düzeltildi: ⌃⌥H artık Ayarlar penceresi açılmadan oturum açılışında çalışır.",
            "Çıkışta kaynak temizliği geliştirildi: sensör ve GPU belleği Mac kapatıldığında tamamen serbest bırakılır.",
            "Apple HIG pencere yeniden açma desteği: Dock simgesine tıklandığında kapalı pencere geri gelir.",
            "Uygulamada 39 dünya dili için tam yerel destek.",
            "Apple meta veri standartları eklendi (NSHumanReadableCopyright ve ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "pl",
        "name": "Polski",
        "flag": "🇵🇱",
        "notes": [
            "Naprawiono skrót przy cichym starcie: ⌃⌥H działa natychmiast po zalogowaniu bez otwierania Ustawień.",
            "Ulepszone zwalnianie zasobów przy zamykaniu: czujnik i pamięć GPU są w pełni zwalniane przy wyłączaniu.",
            "Ponowne otwieranie okna według Apple HIG: kliknięcie ikony w Docku przywraca okno.",
            "Pełne natywne wsparcie dla 39 języków świata.",
            "Zgodność z metadanymi Apple (NSHumanReadableCopyright i ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "ar",
        "name": "العربية",
        "flag": "🇸🇦",
        "notes": [
            "إصلاح اختصار البدء الصامت: يعمل ⌃⌥H الآن فور تسجيل الدخول دون الحاجة لفتح الإعدادات.",
            "تحسين تحرير الموارد عند الإنهاء: يتم إخلاء المستشعر وذاكرة الرسومات بالكامل عند إيقاف التشغيل.",
            "استعادة النافذة وفق معايير Apple HIG: النقر على أيقونة Dock يعيد فتح الإعدادات.",
            "دعم أصلي كامل لـ 39 لغة عالمية في التطبيق والتوثيق.",
            "الامتثال لمعايير بيانات Apple الوصفية (NSHumanReadableCopyright و ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "vi",
        "name": "Tiếng Việt",
        "flag": "🇻🇳",
        "notes": [
            "Sửa phím tắt khi khởi động ngầm: ⌃⌥H hoạt động ngay khi đăng nhập mà không cần mở Cài đặt.",
            "Giải phóng tài nguyên hoàn chỉnh khi thoát: cảm biến và bộ nhớ GPU được giải phóng triệt để khi tắt máy.",
            "Khôi phục cửa sổ theo chuẩn Apple HIG: nhấp vào biểu tượng trên Dock sẽ mở lại cửa sổ cài đặt.",
            "Hỗ trợ bản địa hoàn toàn cho 39 ngôn ngữ trên thế giới.",
            "Tuân thủ tiêu chuẩn siêu dữ liệu Apple (NSHumanReadableCopyright và ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "sv",
        "name": "Svenska",
        "flag": "🇸🇪",
        "notes": [
            "Snabbkommando vid tyst start åtgärdat: ⌃⌥H fungerar direkt vid inloggning utan att Inställningar öppnas.",
            "Resursfrigöring vid avslutning förbättrad: sensor och GPU-minne frigörs fullständigt vid avstängning.",
            "Återöppna fönster enligt Apple HIG: klicka på Dock-symbolen för att visa Inställningar.",
            "Fullt inbyggt stöd för 39 världsspråk.",
            "Uppfyller Apples metadatastandarder (NSHumanReadableCopyright och ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "nb",
        "name": "Norsk Bokmål",
        "flag": "🇳🇴",
        "notes": [
            "Hurtigtast ved stille oppstart rettet: ⌃⌥H fungerer umiddelbart ved innlogging uten å åpne Innstillinger.",
            "Ressursfrigjøring ved avslutning forbedret: sensor og GPU-minne frigjøres fullstendig ved avslutning.",
            "Gjenåpne vindu i henhold til Apple HIG: klikk på Dock-symbolet for å vise Innstillinger.",
            "Full innebygd støtte for 39 verdensspråk.",
            "Samsvar med Apples metadatastandarder (NSHumanReadableCopyright og ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "da",
        "name": "Dansk",
        "flag": "🇩🇰",
        "notes": [
            "Genvejstast ved stille start rettet: ⌃⌥H virker straks ved login uden at åbne Indstillinger.",
            "Ressourcefrigørelse ved afslutning forbedret: sensor og GPU-hukommelse frigøres fuldstændigt ved lukning.",
            "Genåbn vindue efter Apple HIG: klik på Dock-ikonet for at hente Indstillinger frem igen.",
            "Fuld indbygget understøttelse af 39 verdenssprog.",
            "Overholder Apples metadatastandarder (NSHumanReadableCopyright og ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "fi",
        "name": "Suomi",
        "flag": "🇫🇮",
        "notes": [
            "Taustakäynnistyksen pikanäppäin korjattu: ⌃⌥H toimii heti kirjautumisen jälkeen avaamatta Asetuksia.",
            "Resurssien vapautus suljettaessa parannettu: anturi ja näytönohjaimen muisti vapautetaan sammutettaessa.",
            "Ikkunan avaaminen uudelleen Apple HIG -standardin mukaisesti: Dock-kuvakkeen napsautus palauttaa ikkunan.",
            "Täysi natiivituki 39 maailmankielelle.",
            "Applen metatietostandardien mukaisuus (NSHumanReadableCopyright ja ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "uk",
        "name": "Українська",
        "flag": "🇺🇦",
        "notes": [
            "Виправлено гарячу клавішу тихого запуску: ⌃⌥H реагує відразу після входу без відкриття Параметрів.",
            "Повне звільнення ресурсів при виході: датчик та пам'ять GPU повністю звільняються при завершенні.",
            "Повторне відкриття вікна за Apple HIG: клік по іконці в Dock відновлює закрите вікно.",
            "Повна нативна підтримка 39 мов світу.",
            "Відповідність метаданим Apple (NSHumanReadableCopyright та ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "cs",
        "name": "Čeština",
        "flag": "🇨🇿",
        "notes": [
            "Oprava klávesové zkratky při tichém startu: ⌃⌥H reaguje ihned po přihlášení bez nutnosti otevírat Nastavení.",
            "Vylepšené uvolnění prostředků při ukončení: senzor a paměť GPU se zcela uvolní při vypnutí.",
            "Znovuotevření okna dle Apple HIG: kliknutím na ikonu v Docku obnovíte okno nastavení.",
            "Plná nativní podpora 39 světových jazyků.",
            "Soulad s metadaty Apple (NSHumanReadableCopyright a ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "ro",
        "name": "Română",
        "flag": "🇷🇴",
        "notes": [
            "Comandă rapidă remediată la pornirea silențioasă: ⌃⌥H funcționează imediat după autentificare fără a deschide Configurări.",
            "Eliberare îmbunătățită a resurselor la închidere: senzorul și memoria GPU sunt eliberate complet la oprire.",
            "Redeschiderea ferestrei conform Apple HIG: clic pe pictograma din Dock redeschide configurările.",
            "Asistență nativă completă pentru 39 de limbi.",
            "Conformitate cu metadatele Apple (NSHumanReadableCopyright și ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "hu",
        "name": "Magyar",
        "flag": "🇭🇺",
        "notes": [
            "Csendes indítási gyorsbillentyű javítva: a ⌃⌥H a Beállítások megnyitása nélkül is azonnal működik bejelentkezéskor.",
            "Erőforrások felszabadítása kilépéskor: az érzékelő és a GPU memória teljesen felszabadul leállításkor.",
            "Ablak újranyitása az Apple HIG szerint: a Dock ikonra kattintva a beállítások ablaka visszahívható.",
            "Teljes natív támogatás 39 világnyelven.",
            "Megfelelés az Apple metaadat-szabványainak (NSHumanReadableCopyright és ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "el",
        "name": "Ελληνικά",
        "flag": "🇬🇷",
        "notes": [
            "Διόρθωση συντόμευσης αθόρυβης εκκίνησης: το ⌃⌥H λειτουργεί αμέσως κατά τη σύνδεση χωρίς άνοιγμα των Ρυθμίσεων.",
            "Βελτιωμένη απελευθέρωση πόρων: ο αισθητήρας και η μνήμη GPU απελευθερώνονται πλήρως κατά τον τερματισμό.",
            "Επαναφορά παραθύρου κατά Apple HIG: κλικ στο εικονίδιο Dock επαναφέρει τις ρυθμίσεις.",
            "Πλήρης εγγενής υποστήριξη για 39 γλώσσες.",
            "Συμμόρφωση με τα πρότυπα μεταδεδομένων της Apple (NSHumanReadableCopyright και ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "hi",
        "name": "हिन्दी",
        "flag": "🇮🇳",
        "notes": [
            "बैकग्राउंड स्टार्टअप शॉर्टकट सुधारा गया: सेटिंग्स खोले बिना लॉग इन करते ही ⌃⌥H तुरंत काम करता है।",
            "बंद होने पर संसाधन साफ़: ऐप बंद या शटडाउन होने पर सेंसर और GPU मेमोरी पूरी तरह मुक्त हो जाती है।",
            "Apple HIG के अनुसार विंडो दोबारा खोलना: Dock आइकन पर क्लिक करके सेटिंग्स विंडो वापस लाएं।",
            "39 विश्व भाषाओं का पूर्ण मूल समर्थन।",
            "Apple मेटाडेटा मानकों का अनुपालन (NSHumanReadableCopyright और ITSAppUsesNonExemptEncryption)।",
        ],
    },
    {
        "code": "bn",
        "name": "বাংলা",
        "flag": "🇧🇩",
        "notes": [
            "সাইলেন্ট স্টার্টআপ শর্টকাট ঠিক করা হয়েছে: সেটিংস না খুলেই লগইন করার সাথে সাথে ⌃⌥H কাজ করে।",
            "বন্ধ করার সময় রিসোর্স রিলিজ উন্নত: প্রস্থান বা শাটডাউনে সেন্সর এবং জিপিইউ মেমরি সম্পূর্ণরূপে মুক্ত হয়।",
            "Apple HIG অনুযায়ী উইন্ডো পুনরায় খোলা: ডক আইকনে ক্লিক করে সেটিংস উইন্ডো ফিরিয়ে আনা যায়।",
            "৩৯টি বিশ্ব ভাষার জন্য পূর্ণ নেটিভ সমর্থন।",
            "Apple মেটাডেটা মানদণ্ডের সাথে সঙ্গতিপূর্ণ (NSHumanReadableCopyright এবং ITSAppUsesNonExemptEncryption)।",
        ],
    },
    {
        "code": "ta",
        "name": "தமிழ்",
        "flag": "🇮🇳",
        "notes": [
            "பின்னணி தொடக்க குறுக்குவழி சரிசெய்யப்பட்டது: அமைப்புகளைத் திறக்காமல் உள்நுழைந்தவுடன் ⌃⌥H செயல்படும்.",
            "வெளியேறும் போது வளங்கள் முழுமையாக விடுவிப்பு: சென்சார் மற்றும் GPU நினைவகம் சுத்தமாக விடுவிக்கப்படும்.",
            "Apple HIG படி சாளரத்தை மீண்டும் திறத்தல்: Dock ஐகானைக் கிளிக் செய்து அமைப்புகள் சாளரத்தை மீட்டெடுக்கலாம்.",
            "39 உலக மொழிகளுக்கான முழு பூர்வீக ஆதரவு.",
            "Apple மெட்டாடேட்டா தரநிலைகளுடன் இணக்கம் (NSHumanReadableCopyright மற்றும் ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "ur",
        "name": "اردو",
        "flag": "🇵🇰",
        "notes": [
            "بیک گراؤنڈ شارٹ کٹ کی درستگی: سیٹنگز کھولے بغیر لاگ ان ہوتے ہی ⌃⌥H کام کرتا ہے۔",
            "بند ہونے پر وسائل کی مکمل صفائی: شٹ ڈاؤن پر سینسر اور GPU میموری مکمل طور پر خالی ہو جاتی ہے۔",
            "Apple HIG کے مطابق ونڈو دوبارہ کھولنا: ڈوک آئیکن پر کلک کر کے سیٹنگز ونڈو واپس لائیں۔",
            "39 عالمی زبانوں کے لیے مکمل مقامی تعاون۔",
            "ایپل میٹا ڈیٹا معیارات کی تکمیل (NSHumanReadableCopyright اور ITSAppUsesNonExemptEncryption)۔",
        ],
    },
    {
        "code": "fa",
        "name": "فارسی",
        "flag": "🇮🇷",
        "notes": [
            "رفع مشکل کلید میانبر در شروع بی‌صدا: ⌃⌥H بلافاصله پس از ورود بدون نیاز به باز کردن تنظیمات کار می‌کند.",
            "آزادسازی کامل منابع هنگام خروج: حسگر و حافظه گرافیکی هنگام خاموش شدن کاملاً آزاد می‌شوند.",
            "باز کردن مجدد پنجره طبق Apple HIG: با کلیک روی آیکون داک، پنجره تنظیمات بازیابی می‌شود.",
            "پشتیبانی بومی از ۳۹ زبان جهان در برنامه و مستندات.",
            "سازگاری با استانداردهای فراداده اپل (NSHumanReadableCopyright و ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "he",
        "name": "עברית",
        "flag": "🇮🇱",
        "notes": [
            "תוקן קיצור הדרך בהפעלה שקטה: ⌃⌥H מגיב מיד עם ההתחברות ללא צורך בפתיחת חלון ההגדרות.",
            "פינוי משאבים משופר בסגירה: החיישן וזיכרון ה-GPU משתחררים לחלוטין בכיבוי.",
            "פתיחה מחדש של החלון לפי Apple HIG: לחיצה על סמל ה-Dock פותחת מחדש את ההגדרות.",
            "תמיכה מקורית מלאה ב-39 שפות עולם.",
            "תאימות לתקני המטא-נתונים של Apple (NSHumanReadableCopyright ו-ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "th",
        "name": "ไทย",
        "flag": "🇹🇭",
        "notes": [
            "แก้ไขปุ่มลัดเมื่อเริ่มระบบในพื้นหลัง: ⌃⌥H ใช้งานได้ทันทีหลังเข้าสู่ระบบโดยไม่ต้องเปิดหน้าต่างการตั้งค่า",
            "ปรับปรุงการคืนทรัพยากรเมื่อปิดแอป: เซ็นเซอร์และหน่วยความจำ GPU ได้รับการคืนอย่างสมบูรณ์เมื่อปิดเครื่อง",
            "เปิดหน้าต่างใหม่ตามมาตรฐาน Apple HIG: คลิกที่ไอคอน Dock เพื่อเรียกหน้าต่างการตั้งค่ากลับมา",
            "รองรับ 39 ภาษาทั่วโลกอย่างสมบูรณ์แบบในตัวแอป",
            "ปฏิบัติตามมาตรฐานข้อมูลเมตาของ Apple (NSHumanReadableCopyright และ ITSAppUsesNonExemptEncryption)",
        ],
    },
    {
        "code": "id",
        "name": "Bahasa Indonesia",
        "flag": "🇮🇩",
        "notes": [
            "Pintasan peluncuran senyap diperbaiki: ⌃⌥H langsung merespons saat login tanpa perlu membuka Pengaturan.",
            "Pembersihan sumber daya saat keluar ditingkatkan: sensor dan memori GPU dibebaskan sepenuhnya saat shutdown.",
            "Buka kembali jendela sesuai Apple HIG: klik ikon Dock untuk menampilkan kembali jendela Pengaturan.",
            "Dukungan asli penuh untuk 39 bahasa dunia di dalam aplikasi.",
            "Kepatuhan standar metadata Apple (NSHumanReadableCopyright dan ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "ms",
        "name": "Bahasa Melayu",
        "flag": "🇲🇾",
        "notes": [
            "Pintasan pelancaran senyap diperbaiki: ⌃⌥H berfungsi serta-merta semasa log masuk tanpa membuka Tetapan.",
            "Pembersihan sumber semasa keluar dipertingkatkan: sensor dan memori GPU dilepaskan sepenuhnya apabila ditutup.",
            "Buka semula tetingkap mengikut Apple HIG: klik ikon Dock untuk memaparkan semula Tetapan.",
            "Sokongan natif penuh untuk 39 bahasa dunia.",
            "Mematuhi piawaian metadata Apple (NSHumanReadableCopyright dan ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "fil",
        "name": "Filipino",
        "flag": "🇵🇭",
        "notes": [
            "Inayos ang shortcut sa silent startup: gumagana agad ang ⌃⌥H pagka-login nang hindi kailangang buksan ang Settings.",
            "Pinahusay na paglilinis ng mapagkukunan sa paglabas: ang sensor at memorya ng GPU ay ganap na nailalabas sa pag-shutdown.",
            "Muling buksan ang window ayon sa Apple HIG: i-click ang icon sa Dock upang buksan muli ang Settings.",
            "Buong katutubong suporta para sa 39 na wika sa daigdig.",
            "Pagsunod sa mga pamantayan ng metadata ng Apple (NSHumanReadableCopyright at ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "sw",
        "name": "Kiswahili",
        "flag": "🇰🇪",
        "notes": [
            "Njia ya mkato ya kuanza kimyakimya imerekebishwa: ⌃⌥H inafanya kazi mara moja unapoingia bila kufungua Mipangilio.",
            "Usafishaji wa rasilimali wakati wa kutoka umeboreshwa: kihisi na kumbukumbu ya GPU huachiliwa kabisa wakati wa kuzima.",
            "Kufungua tena dirisha kulingana na Apple HIG: bofya ikoni ya Dock ili kurejesha Mipangilio.",
            "Usaidizi kamili wa kiasili kwa lugha 39 za ulimwengu.",
            "Kuzingatia viwango vya metadata vya Apple (NSHumanReadableCopyright na ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "af",
        "name": "Afrikaans",
        "flag": "🇿🇦",
        "notes": [
            "Kortpad by stil begin herstel: ⌃⌥H reageer onmiddellik by aanmelding sonder om Instellings oop te maak.",
            "Hulpbronopruiming by afsluiting verbeter: sensor en GPU-geheue word volledig vrygestel by afskakeling.",
            "Heropen venster volgens Apple HIG: klik op die Dock-ikoon om Instellings weer te vertoon.",
            "Volledige inheemse ondersteuning vir 39 wêreldtale.",
            "Voldoen aan Apple-metadatastandaarde (NSHumanReadableCopyright en ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "la",
        "name": "Lingua Latina",
        "flag": "🏛️",
        "notes": [
            "Compendium silentii emendatum: ⌃⌥H statim in initium sessionis operatur sine praevia fenestrae aperitione.",
            "Purgatio opum perfecta in exitu: sensile et memoria graphica ad plenum liberantur in systematis conclusione.",
            "Fenestrae restitutio iuxta Apple HIG: preme imaginem Dock ut fenestram Praeferentiarum revoces.",
            "Sustentatio nativa omnium 39 linguarum orbis terrarum.",
            "Norma metadatorum Apple adimpleta (NSHumanReadableCopyright atque ITSAppUsesNonExemptEncryption).",
        ],
    },
    {
        "code": "eo",
        "name": "Esperanto",
        "flag": "🟢",
        "notes": [
            "Klavkombino ĉe silenta starto riparita: ⌃⌥H respondas tuj post ensaluto sen neceso malfermi Agordojn.",
            "Plibonigita purigado de rimedoj ĉe eliro: la sensilo kaj GPU-memoro estas plene liberigitaj ĉe sistemfino.",
            "Refenestrado laŭ Apple HIG: klaku sur la Dok-piktogramon por reiri al Agordoj.",
            "Plena indiĝena subteno por 39 mondaj lingvoj en la aplikaĵo.",
            "Konformo al metadatumaj normoj de Apple (NSHumanReadableCopyright kaj ITSAppUsesNonExemptEncryption).",
        ],
    },
]


def generate_markdown(version: str) -> str:
    """Build the GitHub Release Markdown note."""
    lines = [
        f"# Softfold {version}",
        "",
        "## 🇨🇳 简体中文 (Simplified Chinese)",
        "",
    ]
    zh = next(lang for lang in LANGUAGES if lang["code"] == "zh-Hans")
    for note in zh["notes"]:
        lines.append(f"- {note}")
    lines.extend(["", "## 🇺🇸 English", ""])
    en = next(lang for lang in LANGUAGES if lang["code"] == "en")
    for note in en["notes"]:
        lines.append(f"- {note}")

    lines.extend(
        [
            "",
            "---",
            "",
            "<details>",
            "<summary><strong>🌍 All 39 Languages Release Notes / 全球 39 门语言更新日志 (Click to expand)</strong></summary>",
            "",
        ]
    )

    for lang in LANGUAGES:
        lines.append(f"### {lang['flag']} {lang['name']} ({lang['code']})")
        lines.append("")
        for note in lang["notes"]:
            lines.append(f"- {note}")
        lines.append("")

    lines.extend(["</details>", ""])
    return "\n".join(lines)


def generate_html(version: str) -> str:
    """Build the Sparkle in-app HTML release notes."""
    html_parts = [
        '<div style="font-family: -apple-system, BlinkMacSystemFont, sans-serif; font-size: 13px; line-height: 1.5; color: #1d1d1f; padding: 4px 0;">',
        f'<h3 style="margin-top: 0; font-size: 16px; font-weight: 600;">Softfold {version}</h3>',
        '<div style="margin-bottom: 12px;">',
        '<p style="margin: 4px 0; font-weight: 600;">🇨🇳 简体中文：</p>',
        '<ul style="margin: 4px 0 10px 18px; padding: 0;">',
    ]
    zh = next(lang for lang in LANGUAGES if lang["code"] == "zh-Hans")
    for note in zh["notes"]:
        html_parts.append(f"  <li>{note}</li>")
    html_parts.extend(
        [
            "</ul>",
            '<p style="margin: 4px 0; font-weight: 600;">🇺🇸 English:</p>',
            '<ul style="margin: 4px 0 10px 18px; padding: 0;">',
        ]
    )
    en = next(lang for lang in LANGUAGES if lang["code"] == "en")
    for note in en["notes"]:
        html_parts.append(f"  <li>{note}</li>")
    html_parts.extend(
        [
            "</ul>",
            "</div>",
            '<details style="margin-top: 12px; font-size: 12px; color: #515154;">',
            "<summary style=\"cursor: pointer; font-weight: 500; color: #0066cc;\">🌍 All 39 Languages / 全部 39 门语言更新日志</summary>",
            '<div style="max-height: 220px; overflow-y: auto; margin-top: 8px; padding: 8px; background: rgba(0,0,0,0.03); border-radius: 6px;">',
        ]
    )

    for lang in LANGUAGES:
        html_parts.append(f'<p style="margin: 6px 0 2px; font-weight: 600;">{lang["flag"]} {lang["name"]}:</p>')
        html_parts.append('<ul style="margin: 2px 0 6px 18px; padding: 0;">')
        for note in lang["notes"]:
            html_parts.append(f"  <li>{note}</li>")
        html_parts.append("</ul>")

    html_parts.extend(["</div>", "</details>", "</div>"])
    return "\n".join(html_parts)


def main():
    version = sys.argv[1] if len(sys.argv) > 1 else "1.18"
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
