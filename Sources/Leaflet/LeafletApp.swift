import SwiftUI

@main
struct LeafletApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var document = DocumentModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(document)
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .importExport) {
                Button("Open…") { document.openFileDialog() }
                    .keyboardShortcut("o", modifiers: .command)
            }
        }
        .handlesExternalEvents(matching: ["*"])
    }
}
