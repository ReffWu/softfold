<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Close the lid, and your desktop folds away softly.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Download for Mac">
  </picture>
</a>

<sub>Free · MacBook with Apple silicon · macOS 14 or later · Notarized by Apple</sub>

<sub>If you like Softfold, a ⭐ on GitHub helps more people discover it.</sub>

English · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Close the lid, and your desktop folds away softly.">
  </picture>
</p>

---

Softfold follows your MacBook's hinge. As you lower the screen, your live desktop tilts back with it, blurs from the top down and fades into the dark edges. Lift it again and everything comes back, sharp and exactly where you left it.

## Download

[Download Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), open it and drag Softfold into Applications. The app is signed with a Developer ID and notarized by Apple, so it opens like any other app.

On first launch, allow Screen Recording, reopen Softfold if macOS asks, and turn it on. It turns itself back on the next time you open it, and starts with your Mac from then on.

The first time you turn Softfold on, it takes the open angle from your lid. To change it later, hold the lid where you like it and click **Use Current Angle**. <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> turns it on or off from anywhere.

## Which MacBooks work

Softfold needs the lid angle sensor that Apple added in 2019, exposed on Apple silicon through the sensor coprocessor, plus macOS 14 or later. If your Mac has no sensor, Softfold tells you.

| Status | Models |
| --- | --- |
| Works, confirmed by users | 14 and 16 inch MacBook Pro with M1 Pro or M1 Max (2021), M2 Max (2023), M3 Pro or M3 Max (2023), M4 Pro or M4 Max (2024). MacBook Air with M4 (2025) or M5 |
| Has the sensor, not confirmed yet | 14 inch MacBook Pro with M3, M4 or M5. 14 and 16 inch MacBook Pro with M5 Pro or M5 Max. MacBook Air with M2 or M3 |
| Not supported | MacBook Air with M1, every 13 inch MacBook Pro (Intel, M1 and M2), Intel MacBook Pro, 12 inch MacBook, MacBook Neo, desktop Macs |

The 2019 16 inch MacBook Pro has the sensor too, but the released app is built for Apple silicon only.

Not sure? Run this in Terminal. A line that ends in `las` means Softfold can read your lid:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Tried it on a model in the middle row? [Tell us how it went](https://github.com/ReffWu/softfold/issues).

## How it works

Softfold reads the lid angle over IOKit HID in hundredths of a degree where the sensor reports them, following the sensor's own refresh cadence instead of polling blindly. A critically damped filter turns those readings into continuous motion. Slow tilt, slow fold. Quick tilt, quick fold. Stop partway for a second and the desktop eases back into focus, then folds again as soon as you keep closing.

ScreenCaptureKit supplies the live desktop, and Metal renders the perspective, the progressive blur and the side fill at 60 fps. Capture only runs while the lid is closing or folded and stops a few seconds after it opens again, which also clears the screen recording indicator. Frames stay in memory on your Mac and are never recorded or uploaded. Once a day Softfold sends an anonymous heartbeat with a random install ID, the app and macOS versions, the Mac model and whether the fold was used that day, so we can count active Macs. No screen content, files, IP addresses or personal information are stored. Turn off Share anonymous usage statistics in the Softfold window to stop it.

The full motion design is in [MOTION.md](MOTION.md).

## Languages

English, Simplified Chinese, Traditional Chinese, Japanese, Korean, German, French, Spanish, Italian, Brazilian Portuguese, Russian, Dutch, Turkish, Polish, Arabic and Vietnamese. Softfold follows your Mac's language, or pick one in the Softfold window.

## Build from source

Install Xcode, then:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Development checks are described in [CHECKS.md](CHECKS.md), and signed releases in [RELEASE.md](RELEASE.md).

## Contributing

Ideas, bug reports and pull requests are welcome. [Open an issue](https://github.com/ReffWu/softfold/issues) or send a PR.

## Credits

Softfold began as a fork of [Hinge](https://github.com/Noveum/hinge) by Noveum.ai, released under the MIT License. The lid sensor's HID identifiers and report layout were first documented by [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## License

[MIT](LICENSE)
