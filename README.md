<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Close the lid, and your desktop folds away softly.**

English · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

[![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue?logo=apple&style=flat-square)](#which-macbooks-work)
[![Apple silicon](https://img.shields.io/badge/Apple%20silicon-arm64-black?style=flat-square)](#which-macbooks-work)
[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg?style=flat-square)](LICENSE)

</div>

---

Softfold follows your MacBook's hinge. As you lower the screen, your live desktop tilts back with it, blurs from the top down and fades into the dark edges. Lift it again and everything comes back, sharp and exactly where you left it.

## Download

[Download Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), open it and drag Softfold into Applications. The app is signed with a Developer ID and notarized by Apple, so it opens like any other app.

On first launch, allow Screen Recording, reopen Softfold if macOS asks, and turn it on. It turns itself back on the next time you open it.

The starting open angle is 100°. Prefer something else? Get comfortable and click **Set open position**. Softfold remembers it. <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> turns it on or off from anywhere. Prefer a light frame around the icon? Switch it under **General > About > App icon**.

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

Softfold reads the lid angle over IOKit HID in hundredths of a degree where the sensor reports them, following the sensor's own refresh cadence instead of polling blindly. A critically damped filter turns those readings into continuous motion. Slow tilt, slow fold. Quick tilt, quick fold.

ScreenCaptureKit supplies the live desktop, and Metal renders the perspective, the progressive blur and the side fill at 60 fps. Capture only runs while the lid is closing or folded and stops a few seconds after it opens again, which also clears the screen recording indicator. Frames stay in memory on your Mac. No recordings, no uploads, no analytics.

The full motion design is in [MOTION.md](MOTION.md).

## Languages

English, Simplified Chinese, Traditional Chinese, Japanese, Korean, German, French, Spanish, Italian, Brazilian Portuguese, Russian, Dutch, Turkish, Polish, Arabic and Vietnamese. Softfold follows your Mac's language, or pick one under **General > Controls > Language**.

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
