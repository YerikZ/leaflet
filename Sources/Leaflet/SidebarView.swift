import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var document: DocumentModel
    @State private var hoveredID: UUID? = nil

    private var selectionBinding: Binding<UUID?> {
        Binding(
            get: { document.selectedID },
            set: { document.selectedID = $0 }
        )
    }

    var body: some View {
        List(selection: selectionBinding) {
            if document.documents.isEmpty {
                Text("No files open")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            } else {
                ForEach(document.documents) { doc in
                    row(for: doc)
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 180)
        .navigationTitle("Leaflet")
    }

    private func row(for doc: OpenDocument) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "doc.text")
                .foregroundStyle(.secondary)
                .imageScale(.small)
                .frame(width: 14)
            Text(doc.url.lastPathComponent)
                .lineLimit(1)
            Spacer(minLength: 4)
            Button {
                document.close(id: doc.id)
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .opacity(hoveredID == doc.id || document.selectedID == doc.id ? 1 : 0)
        }
        .padding(.vertical, 1)
        .tag(doc.id)
        .onHover { hovered in
            hoveredID = hovered ? doc.id : nil
        }
        .help(doc.url.path)
    }
}
