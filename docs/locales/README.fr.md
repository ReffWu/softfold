<div align="center">

<img src="../icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Rabattez l'écran, et votre bureau s'incline tout en douceur.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/download-en-dark.png">
    <img src="../readme/download-en-light.png" height="52" alt="Télécharger Softfold pour Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Gratuit · MacBook avec puce Apple Silicon · macOS 14 ou version ultérieure · Notarisé par Apple</sub>

<sub>Si vous appréciez Softfold, une ⭐ sur GitHub aide d'autres personnes à le découvrir.</sub>

[English](../../README.md) · [Deutsch](README.de.md) · Français · [Español](README.es.md) · [🌍 Toutes les 39 langues](README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../readme/hero-en-dark.webp">
    <img src="../readme/hero-en-light.webp" alt="Rabattez l'écran, et votre bureau s'incline tout en douceur.">
  </picture>
</p>

---

Softfold épouse le mouvement de la charnière de votre MacBook. Lorsque vous abaissez l’écran, votre bureau actif bascule avec lui vers l’arrière, devient progressivement flou depuis le haut et s'estompe délicatement dans les bordures sombres. Soulevez l'écran à nouveau : tout revient en place, net et exactement là où vous l'aviez laissé.

## Téléchargement

[Téléchargez Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), ouvrez-le et glissez Softfold dans vos Applications. L'application est signée avec un Developer ID et notarisée par Apple, s'ouvrant en toute sécurité comme n'importe quelle application native.

Au premier lancement, autorisez l’Enregistrement de l’écran dans les Réglages Système, rouvrez l'application si macOS vous y invite, puis activez-la. Elle démarrera ensuite automatiquement avec votre Mac et restera prête à l'emploi.

La première fois que vous activez Softfold, l'angle actuel de votre écran devient la référence d'ouverture. Pour le modifier ultérieurement, placez l'écran dans la position souhaitée et cliquez sur **Utiliser l'angle actuel**. Le raccourci <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> vous permet d'activer ou désactiver l'effet à tout moment.

## Modèles de MacBook compatibles

Softfold requiert le capteur d'angle d'ouverture intégré par Apple depuis 2019 (accessible sur les puces Apple Silicon via le coprocesseur de capteurs), ainsi que macOS 14 ou version ultérieure. Si votre Mac ne dispose pas de ce capteur, Softfold vous en informera directement.

| État | Modèles |
| --- | --- |
| Confirmé et fonctionnel | MacBook Pro 14" et 16" avec M1 Pro ou M1 Max (2021), M2 Max (2023), M3 Pro ou M3 Max (2023), M4 Pro ou M4 Max (2024). MacBook Air avec M4 (2025) ou M5 |
| Capteur présent, non confirmé | MacBook Pro 14" avec M3, M4 ou M5. MacBook Pro 14" et 16" avec M5 Pro ou M5 Max. MacBook Air avec M2 ou M3 |
| Non compatible | MacBook Air avec M1, tous les MacBook Pro 13" (Intel, M1 et M2), MacBook Pro Intel, MacBook 12", MacBook Neo, Mac de bureau |

Le MacBook Pro 16 pouces de 2019 intègre également ce capteur, mais cette version distribuée est exclusivement conçue pour l'architecture Apple Silicon.

Un doute ? Exécutez cette commande dans le Terminal. Une ligne se terminant par « las » indique que Softfold peut communiquer avec votre capteur :

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Vous l'avez testé sur un modèle de la ligne intermédiaire ? [Faites-nous part de vos retours](https://github.com/ReffWu/softfold/issues).

## Fonctionnement technique

Softfold lit l'angle d'ouverture via IOKit HID au centième de degré près, en respectant la cadence native du capteur sans scrutation aveugle. Un filtre à amortissement critique transforme ces mesures en une dynamique fluide et organique. Une inclinaison lente crée un repli délicat ; un mouvement rapide déclenche un repli instantané. Marquez une courte pause en cours de fermeture, et le bureau retrouve doucement sa netteté, avant de replonger dès que vous poursuivez le mouvement.

ScreenCaptureKit fournit le flux du bureau en temps réel, et Metal assure le rendu de la perspective, du flou progressif et du remplissage latéral à 60 ips constants. La capture ne s'exécute que lors de la fermeture ou du pliage, et s'arrête quelques secondes après la réouverture, ce qui éteint immédiatement l'indicateur d'enregistrement orange de macOS. Les images restent exclusivement dans la mémoire vive de votre Mac : aucun flux n'est enregistré ni téléversé. Une fois par jour, Softfold envoie un signal d'activité anonyme (contenant un identifiant aléatoire d'installation, la version de l'application et de macOS, le modèle de Mac et l'utilisation de l'effet) pour estimer le nombre de Mac actifs. Aucun contenu d'écran, fichier, adresse IP ou donnée personnelle n'est stocké. Vous pouvez désactiver « Partager les statistiques d'utilisation anonymes » dans la fenêtre de Softfold à tout moment.

La conception complète des animations est détaillée dans [MOTION.md](../../MOTION.md).

## Langues prises en charge

Anglais, chinois simplifié, chinois traditionnel, japonais, coréen, allemand, français, espagnol, italien, portugais brésilien, russe, néerlandais, turc, polonais, arabe et vietnamien. Softfold s'adapte automatiquement à la langue de votre Mac ou se configure directement dans la fenêtre de l'application.

## Compiler depuis les sources

Installez Xcode, puis exécutez :

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Les vérifications de développement sont décrites dans [CHECKS.md](../../CHECKS.md), et les versions signées dans [RELEASE.md](../../RELEASE.md).

## Contribuer

Vos idées, signalements de bogues et requêtes de tirage (pull requests) sont les bienvenus. [Ouvrez un ticket](https://github.com/ReffWu/softfold/issues) ou proposez une pull request.

## Remerciements

Softfold est à l'origine un fork de [Hinge](https://github.com/Noveum/hinge) par Noveum.ai, publié sous licence MIT. Les identifiants HID et le format de rapport du capteur d'angle d'ouverture ont été documentés pour la première fois par [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Licence

[MIT](../../LICENSE)
