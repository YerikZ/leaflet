// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Leaflet",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "Leaflet",
            path: "Sources/Leaflet",
            resources: [
                .copy("Resources/marked.min.js"),
                .copy("Resources/github-markdown.css"),
                .copy("Resources/AppIcon.icns")
            ]
        )
    ]
)
