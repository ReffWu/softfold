#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

team="${TEAM_ID:-37V2HFG7YT}"
version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Info.plist)"
archive="build/Softfold.xcarchive"
options="build/export-options.plist"
submitted="build/submitted"
notarized="build/notarized"
packages="build/SourcePackages"
feed="build/feed"

rm -rf "$archive" "$submitted" "$notarized" "$feed" dist
mkdir -p build dist

xcodebuild archive -quiet \
  -project Softfold.xcodeproj -scheme Softfold -configuration Release \
  -archivePath "$archive" -destination 'generic/platform=macOS' \
  -clonedSourcePackagesDirPath "$packages"

cat > "$options" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>developer-id</string>
  <key>destination</key>
  <string>upload</string>
  <key>signingStyle</key>
  <string>manual</string>
  <key>signingCertificate</key>
  <string>Developer ID Application</string>
  <key>teamID</key>
  <string>${team}</string>
</dict>
</plist>
PLIST

xcodebuild -exportArchive -allowProvisioningUpdates \
  -archivePath "$archive" -exportOptionsPlist "$options" -exportPath "$submitted"

for _ in $(seq 1 60); do
  if xcodebuild -exportNotarizedApp -allowProvisioningUpdates \
    -archivePath "$archive" -exportPath "$notarized" >/dev/null 2>&1; then
    break
  fi
  echo "Waiting for Apple to notarize Softfold $version"
  sleep 30
done
test -d "$notarized/Softfold.app"

codesign --verify --deep --strict "$notarized/Softfold.app"
xcrun stapler validate "$notarized/Softfold.app"
spctl --assess --type execute "$notarized/Softfold.app"

stage="$(mktemp -d "${TMPDIR:-/tmp}/softfold-release.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
ditto "$notarized/Softfold.app" "$stage/Softfold.app"
ln -s /Applications "$stage/Applications"
hdiutil create -quiet -ov -volname Softfold -srcfolder "$stage" -format UDZO dist/Softfold.dmg
if [ -n "${NOTARY_PROFILE:-}" ]; then
  codesign --force --timestamp --sign "Developer ID Application: XIN SHENG WU ($team)" dist/Softfold.dmg
  xcrun notarytool submit dist/Softfold.dmg --keychain-profile "$NOTARY_PROFILE" --wait
  xcrun stapler staple dist/Softfold.dmg
fi
(cd dist && shasum -a 256 Softfold.dmg > Softfold.dmg.sha256)

mkdir -p "$feed"
cp dist/Softfold.dmg "$feed/"
"$packages/artifacts/sparkle/Sparkle/bin/generate_appcast" "$feed" \
  --download-url-prefix "https://github.com/ReffWu/softfold/releases/download/v$version/"
grep -q "sparkle:edSignature" "$feed/appcast.xml"

if [ "${1:-}" = "--publish" ]; then
  gh release create "v$version" dist/Softfold.dmg dist/Softfold.dmg.sha256 "$feed/appcast.xml" \
    --title "Softfold $version" --generate-notes --target main --draft
  gh release edit "v$version" --draft=false --latest
fi

echo "dist/Softfold.dmg and $feed/appcast.xml are ready for Softfold $version"
