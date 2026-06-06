import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var document: DocumentModel
    @State private var isTargeted = false

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(document)
        } detail: {
            if let doc = document.selectedDocument {
                MarkdownWebView(markdownText: doc.content)
                    .navigationTitle(doc.url.lastPathComponent)
            } else {
                placeholder
                    .navigationTitle("Leaflet")
            }
        }
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
