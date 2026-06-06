import AppKit
import Combine
import UniformTypeIdentifiers

struct OpenDocument: Identifiable {
    let id: UUID
    let url: URL
    let content: String

    init(url: URL, content: String) {
        self.id = UUID()
        self.url = url
        self.content = content
    }
}

@MainActor
final class DocumentModel: ObservableObject {
    @Published var documents: [OpenDocument] = []
    @Published var selectedID: UUID? = nil

    private var cancellables = Set<AnyCancellable>()

    var selectedDocument: OpenDocument? {
        documents.first { $0.id == selectedID }
    }

    init() {
        NotificationCenter.default
            .publisher(for: .openMarkdownFile)
            .compactMap { $0.object as? URL }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in self?.open(url: url) }
            .store(in: &cancellables)
    }

    func open(url: URL) {
        // Prevent duplicates — just focus the existing tab
        let canonical = url.standardized
        if let existing = documents.first(where: { $0.url.standardized == canonical }) {
            selectedID = existing.id
            return
        }
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
        let doc = OpenDocument(url: url, content: content)
        documents.append(doc)
        selectedID = doc.id
    }

    func close(id: UUID) {
        guard let idx = documents.firstIndex(where: { $0.id == id }) else { return }
        documents.remove(at: idx)
        if selectedID == id {
            selectedID = documents.isEmpty ? nil : documents[min(idx, documents.count - 1)].id
        }
    }

    func openFileDialog() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [
            UTType(filenameExtension: "md"),
            UTType(filenameExtension: "markdown"),
            UTType(filenameExtension: "mdown"),
        ].compactMap { $0 }
        panel.title = "Open Markdown File"
        if panel.runModal() == .OK {
            panel.urls.forEach { open(url: $0) }
        }
    }

    func handleDrop(providers: [NSItemProvider]) -> Bool {
        let eligible = providers.filter {
            $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier)
        }
        guard !eligible.isEmpty else { return false }
        for provider in eligible {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier) { [weak self] item, _ in
                guard let data = item as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil)
                else { return }
                DispatchQueue.main.async { self?.open(url: url) }
            }
        }
        return true
    }
}
