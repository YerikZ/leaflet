import SwiftUI
import WebKit

struct MarkdownWebView: NSViewRepresentable {
    let markdownText: String
    let darkMode: Bool

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        webView.underPageBackgroundColor = .windowBackgroundColor
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        // Appearance change only — no reload needed; CSS prefers-color-scheme responds automatically
        webView.appearance = darkMode ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua)

        guard markdownText != context.coordinator.lastText else { return }
        context.coordinator.lastText = markdownText
        webView.loadHTMLString(buildHTML(), baseURL: Bundle.main.resourceURL)
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, WKNavigationDelegate {
        var lastText = ""
        func webView(
            _ webView: WKWebView,
            decidePolicyFor action: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if action.navigationType == .linkActivated,
               let url = action.request.url,
               url.scheme != "about"
            {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }

    private func buildHTML() -> String {
        let css = resource("github-markdown.css")
        let js = resource("marked.min.js")

        let escaped = markdownText
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "${", with: "\\${")

        return """
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            :root { color-scheme: light dark; }
            body {
              box-sizing: border-box;
              max-width: 860px;
              margin: 0 auto;
              padding: 32px 40px;
            }
            \(css)
          </style>
        </head>
        <body class="markdown-body">
          <div id="content"></div>
          <script>\(js)</script>
          <script>
            document.getElementById('content').innerHTML =
              marked.parse(`\(escaped)`);
          </script>
        </body>
        </html>
        """
    }

    private func resource(_ name: String) -> String {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let text = try? String(contentsOf: url, encoding: .utf8)
        else { return "" }
        return text
    }
}
