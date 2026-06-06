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

# 2. Download web dependencies (one-time)
curl -sL https://cdn.jsdelivr.net/npm/marked/marked.min.js \
     -o Sources/Leaflet/Resources/marked.min.js
curl -sL https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.css \
     -o Sources/Leaflet/Resources/github-markdown.css

# 3. Build and install to /Applications
make install
```

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
