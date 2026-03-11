import SwiftUI
import WebKit

struct WebView: View {
    let url: URL

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WebViewContainer(url: url)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.ypBlack)
                    }
                }
            }
    }
}

struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Intentionally left empty: the page is loaded once in makeUIView in our project.
    }
}
