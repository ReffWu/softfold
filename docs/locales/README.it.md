<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Abbassa lo schermo, e la tua scrivania si ripiega dolcemente.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Scarica Softfold per Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratis · MacBook con Apple Silicon · macOS 14 o successivo · Notarizzato da Apple</sub>

<sub>Se apprezzi Softfold, una ⭐ su GitHub aiuta più persone a scoprirlo.</sub>

[English](../../README.md) · [Français](README.fr.md) · Italiano · [Español](README.es.md) · [🌍 Tutte le 39 lingue](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Abbassa lo schermo, e la tua scrivania si ripiega dolcemente.">
  </picture>
</p>

---

Softfold asseconda il movimento della cerniera del tuo MacBook. Quando abbassi lo schermo, la tua scrivania in tempo reale si inclina all'indietro insieme ad esso, sfuma gradualmente dall'alto verso il basso e svanisce nei bordi scuri. Riapri lo schermo e tutto torna al suo posto, nitido ed esattamente dove lo avevi lasciato.

## Download

[Scarica Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), aprilo e trascina Softfold nella cartella Applicazioni. L'app è firmata con Developer ID e notarizzata da Apple, aprendosi con la consueta semplicità di qualunque app nativa.

Al primo avvio, consenti l'accesso a «Registrazione schermo» nelle Impostazioni di Sistema, riapri Softfold se richiesto da macOS e attivalo. Da quel momento in poi, si avvierà automaticamente all'accensione del Mac e rimarrà sempre pronto.

La prima volta che attivi Softfold, l'angolo corrente dello schermo viene impostato come riferimento di apertura. Per modificarlo in seguito, posiziona lo schermo all'inclinazione desiderata e fai clic su **Usa angolo attuale**. Premi <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> per attivare o disattivare l'effetto da qualsiasi schermata.

## Modelli di MacBook supportati

Softfold richiede il sensore dell'angolo del coperchio integrato da Apple a partire dal 2019 (accessibile sui chip Apple Silicon tramite il coprocessore di sensori) e macOS 14 o versioni successive. Se il tuo Mac non dispone di questo sensore, Softfold te lo comunicherà subito.

| Stato | Modelli |
| --- | --- |
| Funzionante, confermato dagli utenti | MacBook Pro da 14" e 16" con M1 Pro o M1 Max (2021), M2 Max (2023), M3 Pro o M3 Max (2023), M4 Pro o M4 Max (2024). MacBook Air con M4 (2025) o M5 |
| Sensore presente, non ancora confermato | MacBook Pro da 14" con M3, M4 o M5. MacBook Pro da 14" e 16" con M5 Pro o M5 Max. MacBook Air con M2 o M3 |
| Non supportato | MacBook Air con M1, tutti i MacBook Pro da 13" (Intel, M1 e M2), MacBook Pro con processori Intel, MacBook da 12", MacBook Neo, Mac fissi |

Anche il MacBook Pro da 16 pollici del 2019 dispone del sensore, ma la versione distribuita è ottimizzata esclusivamente per Apple Silicon.

Hai qualche dubbio? Esegui questo comando nel Terminale. Se appare una riga che termina con «las», significa che Softfold può comunicare con il tuo sensore:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

L'hai provato su un modello della seconda riga? [Raccontaci come è andata](https://github.com/ReffWu/softfold/issues).

## Come funziona

Softfold legge l'angolo del coperchio tramite IOKit HID con la precisione di centesimi di grado, sincronizzandosi con la cadenza naturale del sensore invece di eseguire interrogazioni a vuoto. Un filtro a smorzamento critico converte i dati in un movimento fluido e organico. Inclinazione lenta, chiusura dolce. Movimento rapido, chiusura immediata. Se ti fermi a metà corsa per un istante, la scrivania torna morbidamente a fuoco, per poi riprendere a ripiegarsi non appena continui a chiudere.

ScreenCaptureKit fornisce la scrivania dal vivo e Metal elabora la prospettiva tridimensionale, la sfocatura progressiva e la finitura laterale a 60 fps continui. La cattura dello schermo è attiva unicamente durante il movimento o a coperchio piegato, e si arresta pochi istanti dopo la riapertura, spegnendo anche l'indicatore arancione di registrazione di macOS. I fotogrammi risiedono esclusivamente nella RAM del Mac e non vengono mai salvati su disco né inviati online. Una volta al giorno, Softfold invia un heartbeat anonimo con un ID di installazione casuale, le versioni dell'app e di macOS, il modello di Mac e l'eventuale attivazione dell'effetto nella giornata, al solo scopo di stimare il numero di Mac attivi. Nessun contenuto dello schermo, file, indirizzo IP o dato personale viene registrato. Puoi disattivare «Condividi statistiche d'uso anonime» direttamente nella finestra di Softfold in qualunque momento.

Il motion design completo è descritto in dettaglio in [MOTION.md](../../MOTION.md).

## Lingue supportate

Inglese, cinese semplificato, cinese tradizionale, giapponese, coreano, tedesco, francese, spagnolo, italiano, portoghese brasiliano, russo, olandese, turco, polacco, arabo e vietnamita. Softfold si adatta automaticamente alla lingua del sistema oppure puoi scegliere la lingua preferita nella finestra dell'app.

## Compilare dal codice sorgente

Installa Xcode, quindi esegui:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

I controlli di sviluppo sono descritti in [CHECKS.md](../../CHECKS.md), mentre le versioni firmate in [RELEASE.md](../../RELEASE.md).

## Come contribuire

Idee, segnalazioni di bug e pull request sono sempre le benvenute. [Apri una issue](https://github.com/ReffWu/softfold/issues) o invia una pull request.

## Ringraziamenti

Softfold è nato come fork di [Hinge](https://github.com/Noveum/hinge) di Noveum.ai, rilasciato con licenza MIT. Gli identificatori HID e il layout dei report del sensore del coperchio sono stati documentati per la prima volta da [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licenza

[MIT](../../LICENSE)
