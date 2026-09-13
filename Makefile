APP = build/Softfold.app
SIGN_IDENTITY ?= $(shell security find-identity -v -p codesigning 2>/dev/null | awk -F'"' '/Apple Development/ { print $$2; exit }')

.PHONY: build icon release

build:
	xcodebuild -quiet -project Softfold.xcodeproj -scheme Softfold -configuration Release \
		-derivedDataPath build/DerivedData -clonedSourcePackagesDirPath build/SourcePackages \
		CODE_SIGN_IDENTITY="$(if $(SIGN_IDENTITY),$(SIGN_IDENTITY),-)" DEVELOPMENT_TEAM= build
	rm -rf "$(APP)"
	ditto build/DerivedData/Build/Products/Release/Softfold.app "$(APP)"

icon:
	python3 scripts/make-icon.py

release:
	scripts/release.sh
