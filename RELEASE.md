# Shipping Softfold

Releases are built on a Mac that has the Developer ID Application certificate for team `37V2HFG7YT` in its keychain and an Apple account signed in to Xcode. Nothing is signed or published by CI.

## Version

Bump `CFBundleShortVersionString` and `CFBundleVersion` in `Info.plist` and commit.

## Build, sign and notarize

```sh
make release
```

`scripts/release.sh` archives the Release configuration with Xcode, signs it with the Developer ID Application certificate and the hardened runtime, submits it to Apple's notary service through the Xcode account, waits for the notarized app, checks it with `stapler` and `spctl`, and packs it into `dist/Softfold.dmg` with a SHA-256 checksum.

The Xcode account can notarize the app but not the disk image, so by default the disk image stays unsigned around the notarized, stapled app. A signed disk image that is not notarized would fail Gatekeeper, which is worse than an unsigned one. To sign, notarize and staple the disk image too, store a notary credential once and pass its name:

```sh
xcrun notarytool store-credentials Softfold --apple-id <apple-id> --team-id 37V2HFG7YT
NOTARY_PROFILE=Softfold make release
```

## Updates

Softfold updates itself with [Sparkle](https://sparkle-project.org). The app reads `appcast.xml` from the latest GitHub release, so publishing a release is what publishes an update. After notarization, `scripts/release.sh` runs Sparkle's `generate_appcast`, which signs the disk image with the EdDSA private key stored in the login keychain. The matching public key is `SUPublicEDKey` in `Info.plist`. Never replace that key, or every copy already installed will reject new updates.

Every release needs a higher `CFBundleVersion` than the one before, since Sparkle compares build numbers.

## Publish

```sh
scripts/release.sh --publish
```

This does everything above and then creates the GitHub release `v<version>` with the disk image, its checksum and `appcast.xml`, marked as latest. The README download links point at `releases/latest`, so they follow the new release automatically.

## Local builds

`make build` builds `build/Softfold.app` with Xcode, including the Sparkle package, signed with an Apple Development identity when one is installed and ad-hoc otherwise. `scripts/package.sh` wraps that build in `dist/Softfold.dmg` without notarization, for quick testing.

## App icon

`make icon` regenerates `Resources/Assets.xcassets/AppIcon.appiconset` and `docs/icon.png` from `scripts/make-icon.py`. It needs Python with Pillow and NumPy.
