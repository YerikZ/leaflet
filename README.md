# Leaflet

A minimal macOS markdown viewer. Drop a `.md` file in, read it. No Xcode required to build.

![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)

## Features

- Renders GitHub-flavoured markdown via [marked.js](https://marked.js.org)
- Sidebar listing all open files — switch or close with one click
- Opens the same file only once (no duplicates)
- Drag-and-drop files onto the window
- Light / dark mode follows system appearance
- No App Store, no signing account — ad-hoc signed for local use

## Requirements

- macOS 13 Ventura or later
- Xcode Command Line Tools (`xcode-select --install`)

## Build & Install

```bash
# 1. Clone
git clone https://github.com/YerikZ/leaflet.git
cd leaflet

# 2. Build and install to /Applications
make install
```

`marked.js` and `github-markdown-css` are vendored under `Sources/Leaflet/Resources/` (see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)), so no separate download step is needed.

## Usage

| Action | How |
|--------|-----|
| Open file | `⌘O` or drag onto the window |
| Switch file | Click in the sidebar |
| Close file | Hover a sidebar row → click `×` |
| Toggle sidebar | Toolbar toggle button (top-left) |

## Regenerating the icon

```bash
swift make-icon.swift   # writes Sources/Leaflet/Resources/AppIcon.icns
make install            # rebuilds and reinstalls
```

## License

MIT — see [LICENSE](LICENSE). Vendored third-party assets are covered separately; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
