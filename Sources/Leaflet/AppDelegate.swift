import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else { return }
        NotificationCenter.default.post(name: .openMarkdownFile, object: url)
    }
}

extension Notification.Name {
    static let openMarkdownFile = Notification.Name("openMarkdownFile")
}
