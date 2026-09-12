APP = build/Softfold.app
SOURCES = $(wildcard Sources/*.swift)
SIGN_IDENTITY ?= $(shell security find-identity -v -p codesigning 2>/dev/null | awk -F'"' '/Apple Development/ { print $$2; exit }')

.PHONY: build icon release

build:
	mkdir -p "$(APP)/Contents/MacOS" "$(APP)/Contents/Resources/en.lproj"
	xcrun swiftc -swift-version 5 -O -target arm64-apple-macosx14.0 $(SOURCES) -o "$(APP)/Contents/MacOS/Softfold" -framework SwiftUI -framework AppKit -framework IOKit -framework ScreenCaptureKit -framework MetalKit -framework MetalPerformanceShaders
	cp Info.plist "$(APP)/Contents/Info.plist"
	cp Resources/*.metal "$(APP)/Contents/Resources/"
	xcrun actool Resources/Assets.xcassets --compile "$(APP)/Contents/Resources" --platform macosx --minimum-deployment-target 14.0 --app-icon AppIcon --output-partial-info-plist build/assets-info.plist >/dev/null
	xcrun xcstringstool compile Resources/Localizable.xcstrings --output-directory "$(APP)/Contents/Resources"
	codesign --force --sign "$(if $(SIGN_IDENTITY),$(SIGN_IDENTITY),-)" "$(APP)"

icon:
	python3 scripts/make-icon.py

release:
	scripts/release.sh
