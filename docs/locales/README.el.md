<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Κατεβάστε την οθόνη, και το γραφείο εργασίας σας διπλώνει απαλά.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Λήψη του Softfold για Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Δωρεάν · MacBook με Apple Silicon · macOS 14 ή νεότερη έκδοση · Επικυρωμένο από την Apple</sub>

<sub>Αν σας αρέσει το Softfold, ένα ⭐ στο GitHub βοηθά περισσότερους χρήστες να το ανακαλύψουν.</sub>

[English](../../README.md) · [简体中文](README.zh-CN.md) · Ελληνικά · [🌍 Όλες οι γλώσσες](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Κατεβάστε την οθόνη, και το γραφείο εργασίας σας διπλώνει απαλά.">
  </picture>
</p>

---

Το Softfold ακολουθεί με απόλυτη φυσικότητα τον μεντεσέ του MacBook σας. Καθώς κατεβάζετε την οθόνη, το ζωντανό γραφείο εργασίας γέρνει προς τα πίσω, θολώνει σταδιακά από πάνω προς τα κάτω και σβήνει στις σκοτεινές άκρες. Σηκώστε ξανά την οθόνη και όλα επιστρέφουν κρυστάλλινα, ακριβώς εκεί που τα αφήσατε.

## Λήψη

[Κατεβάστε το Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), ανοίξτε το αρχείο και σύρετε το Softfold στον φάκελο Εφαρμογές (Applications). Η εφαρμογή είναι υπογεγραμμένη με Developer ID και επικυρωμένη (notarized) από την Apple, ανοίγοντας με ασφάλεια όπως κάθε επίσημη εφαρμογή για Mac.

Κατά την πρώτη εκκίνηση, επιτρέψτε την «Εγγραφή οθόνης» στις Ρυθμίσεις συστήματος, ανοίξτε ξανά το Softfold αν σας ζητηθεί από το macOS και ενεργοποιήστε το. Έκτοτε, θα ξεκινά αυτόματα μαζί με το Mac σας και θα παραμένει έτοιμο.

Την πρώτη φορά που ενεργοποιείτε το Softfold, καταγράφει την τρέχουσα γωνία της οθόνης ως γωνία αναφοράς. Για να την αλλάξετε αργότερα, φέρτε την οθόνη στην επιθυμητή θέση και κάντε κλικ στην επιλογή **Χρήση τρέχουσας γωνίας**. Η συντόμευση <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> σας επιτρέπει να ενεργοποιείτε ή να απενεργοποιείτε το εφέ ανά πάσα στιγμή.

## Συμβατά μοντέλα MacBook

Το Softfold απαιτεί τον αισθητήρα γωνίας καπακιού που πρόσθεσε η Apple από το 2019 (διαθέσιμος στο Apple Silicon μέσω του συνεπεξεργαστή αισθητήρων) και macOS 14 ή νεότερο. Αν το Mac σας δεν διαθέτει τον αισθητήρα, το Softfold σας ενημερώνει άμεσα.

| Κατάσταση | Μοντέλα |
| --- | --- |
| Λειτουργεί, επιβεβαιωμένο από χρήστες | MacBook Pro 14" και 16" με M1 Pro ή M1 Max (2021), M2 Max (2023), M3 Pro ή M3 Max (2023), M4 Pro ή M4 Max (2024). MacBook Air με M4 (2025) ή M5 |
| Διαθέτει αισθητήρα, μη επιβεβαιωμένο | MacBook Pro 14" με M3, M4 ή M5. MacBook Pro 14" και 16" με M5 Pro ή M5 Max. MacBook Air με M2 ή M3 |
| Δεν υποστηρίζεται | MacBook Air με M1, όλα τα MacBook Pro 13" (Intel, M1 και M2), MacBook Pro με Intel, MacBook 12", MacBook Neo, επιτραπέζιοι υπολογιστές Mac |

Το MacBook Pro 16 ιντσών του 2019 διαθέτει επίσης τον αισθητήρα, αλλά η επίσημη έκδοση είναι μεταγλωττισμένη αποκλειστικά για την αρχιτεκτονική Apple Silicon.

Δεν είστε σίγουροι; Εκτελέστε αυτήν την εντολή στο Τερματικό (Terminal). Μια γραμμή που τελειώνει σε «las» σημαίνει ότι το Softfold μπορεί να επικοινωνήσει με τον αισθητήρα σας:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Το δοκιμάσατε σε μοντέλο της μεσαίας σειράς; [Μοιραστείτε την εμπειρία σας μαζί μας](https://github.com/ReffWu/softfold/issues).

## Πώς λειτουργεί

Το Softfold διαβάζει τη γωνία του καπακιού μέσω IOKit HID με ακρίβεια εκατοστού της μοίρας, ακολουθώντας τον ρυθμό ανανέωσης του ίδιου του αισθητήρα χωρίς περιττή επιβάρυνση. Ένα φίλτρο κρίσιμης απόσβεσης μετατρέπει τις μετρήσεις σε μια αρμονική, συνεχή κίνηση. Αργή κλίση - απαλή αναδίπλωση. Γρήγορη κίνηση - άμεση απόκριση. Αν σταματήσετε στα μισά για ένα δευτερόλεπτο, το γραφείο εργασίας ανακτά ομαλά την καθαρότητά του και συνεχίζει να διπλώνει μόλις συνεχίσετε το κλείσιμο.

Το ScreenCaptureKit παρέχει τη ροή του γραφείου εργασίας σε πραγματικό χρόνο και το Metal αναλαμβάνει την τρισδιάστατη προοπτική, τη σταδιακή θόλωση και τη διαβάθμιση των άκρων σε σταθερά 60 fps. Η καταγραφή λειτουργεί μόνο κατά την κίνηση ή σε διπλωμένη κατάσταση και σταματά δευτερόλεπτα μετά το πλήρες άνοιγμα, σβήνοντας και τη σχετική πορτοκαλί ένδειξη του macOS. Τα καρέ παραμένουν αποκλειστικά στη μνήμη RAM του Mac και δεν αποθηκεύονται ούτε μεταδίδονται στο δίκτυο. Μία φορά την ημέρα, το Softfold στέλνει ένα ανώνυμο σήμα με ένα τυχαίο αναγνωριστικό για την εκτίμηση των ενεργών συσκευών. Κανένα περιεχόμενο οθόνης, αρχείο, διεύθυνση IP ή προσωπικό δεδομένο δεν αποθηκεύεται. Μπορείτε να απενεργοποιήσετε αυτή τη λειτουργία ανά πάσα στιγμή.

Ο πλήρης κινητικός σχεδιασμός περιγράφεται στο [MOTION.md](../../MOTION.md).

## Μεταγλώττιση από τον πηγαίο κώδικα

Εγκαταστήστε το Xcode και εκτελέστε:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Οι έλεγχοι ανάπτυξης περιγράφονται στο [CHECKS.md](../../CHECKS.md) και οι υπογεγραμμένες εκδόσεις στο [RELEASE.md](../../RELEASE.md).

## Συνεισφορά

Ιδέες, αναφορές σφαλμάτων και pull requests είναι πάντοτε ευπρόσδεκτα. [Ανοίξτε ένα issue](https://github.com/ReffWu/softfold/issues) ή στείλτε ένα pull request.

## Ευχαριστίες

Το Softfold ξεκίνησε ως fork του [Hinge](https://github.com/Noveum/hinge) από τη Noveum.ai υπό την άδεια MIT. Τα αναγνωριστικά HID του αισθητήρα και η δομή αναφορών τεκμηριώθηκαν αρχικά από το έργο [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Άδεια χρήσης

[MIT](../../LICENSE)
