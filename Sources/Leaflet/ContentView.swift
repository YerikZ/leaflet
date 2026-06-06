import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var document: DocumentModel
    @AppStorage("darkMode") private var darkMode = false
    @State private var isTargeted = false

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(document)
        } detail: {
            if let doc = document.selectedDocument {
                MarkdownWebView(markdownText: doc.content, darkMode: darkMode)
                    .navigationTitle(doc.url.lastPathComponent)
            } else {
                placeholder
                    .navigationTitle("Leaflet")
            }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .frame(minWidth: 640, minHeight: 400)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            document.handleDrop(providers: providers)
        }
        .overlay(
            isTargeted
                ? RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 3)
                    .padding(4)
                : nil
        )
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    darkMode.toggle()
                } label: {
                    Image(systemName: darkMode ? "sun.max" : "moon")
                }
                .help(darkMode ? "Switch to light mode" : "Switch to dark mode")
            }
        }
    }

    private var placeholder: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text")
                .font(.system(size: 56))
                .foregroundStyle(.tertiary)
            Text("Drop a file here or press ⌘O")
                .foregroundStyle(.secondary)
        }
    }
}
