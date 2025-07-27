import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.backgroundColor = .white
        webview.load(URLRequest(url: url))
        return webview
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
} 
