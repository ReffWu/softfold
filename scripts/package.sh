#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
make build
if [ -n "${SOFTFOLD_BUILD_NUMBER:-}" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $SOFTFOLD_BUILD_NUMBER" build/Softfold.app/Contents/Info.plist
  identity="${SIGN_IDENTITY:-$(security find-identity -v -p codesigning | awk -F'"' '/Apple Development/ {print $2; exit}')}"
  codesign --force --sign "${identity:--}" build/Softfold.app
fi
stage="$(mktemp -d "${TMPDIR:-/tmp}/softfold-package.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
mkdir -p dist
ditto build/Softfold.app "$stage/Softfold.app"
ln -s /Applications "$stage/Applications"
hdiutil create -ov -volname Softfold -srcfolder "$stage" -format UDZO dist/Softfold.dmg
codesign --verify --deep --strict build/Softfold.app
(cd dist && shasum -a 256 Softfold.dmg > Softfold.dmg.sha256)
