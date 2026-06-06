APP_NAME        = Leaflet
BUNDLE          = $(APP_NAME).app
BUNDLE_CONTENTS = $(BUNDLE)/Contents
BUNDLE_MACOS    = $(BUNDLE_CONTENTS)/MacOS
BUNDLE_RESOURCES= $(BUNDLE_CONTENTS)/Resources
BINARY          = .build/release/$(APP_NAME)
RESOURCES_SRC   = Sources/Leaflet/Resources

DEVELOPER_DIR   = $(shell xcode-select -p)
export DEVELOPER_DIR

.PHONY: build bundle install clean

build:
	swift build -c release --arch arm64

bundle: build
	mkdir -p "$(BUNDLE_MACOS)"
	mkdir -p "$(BUNDLE_RESOURCES)"
	cp "$(BINARY)"                               "$(BUNDLE_MACOS)/$(APP_NAME)"
	cp Info.plist                                "$(BUNDLE_CONTENTS)/Info.plist"
	printf 'APPL????' >                          "$(BUNDLE_CONTENTS)/PkgInfo"
	cp "$(RESOURCES_SRC)/marked.min.js"          "$(BUNDLE_RESOURCES)/marked.min.js"
	cp "$(RESOURCES_SRC)/github-markdown.css"    "$(BUNDLE_RESOURCES)/github-markdown.css"
	cp "$(RESOURCES_SRC)/AppIcon.icns"           "$(BUNDLE_RESOURCES)/AppIcon.icns"
	codesign --sign - --force --deep "$(BUNDLE)"
	@echo "Bundle created: $(BUNDLE)"

install: bundle
	cp -R "$(BUNDLE)" /Applications/
	/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister \
	    -f "/Applications/$(BUNDLE)"
	@echo "Installed to /Applications/$(BUNDLE)"

clean:
	rm -rf .build "$(BUNDLE)"
