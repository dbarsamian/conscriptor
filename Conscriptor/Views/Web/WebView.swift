//
//  WebView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    enum WebContentType {
        case html
        case url
    }

    var contentType: WebContentType
    var content: String

    init(_ content: String, type: WebContentType) {
        self.contentType = type
        self.content = content
    }

    func makeNSView(context: Context) -> WKWebView {
        switch contentType {
        case .html:
            return htmlWebView(context: context)
        case .url:
            return urlWebView(context: context)
        }
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        switch contentType {
        case .html:
            if let userScript = generateStyleScript(context: context) {
                nsView.configuration.userContentController.addUserScript(userScript)
            }
            nsView.loadHTMLString(content, baseURL: nil)
        case .url:
            var urlString = content
            if !urlString.hasPrefix("http://"), !urlString.hasPrefix("https://") {
                urlString = "https://\(content)"
            }
            guard let url = URL(string: urlString) else {
                return
            }
            let urlRequest = URLRequest(url: url)
            nsView.load(urlRequest)
        }
    }

    private func htmlWebView(context: Context) -> WKWebView {
        // swiftlint:disable:next line_length
        // See https://stackoverflow.com/questions/33123093/insert-css-into-loaded-html-in-uiwebview-wkwebview for details

        lazy var webView: WKWebView = {
            let userContentController = WKUserContentController()
            if let userScript = generateStyleScript(context: context) {
                userContentController.addUserScript(userScript)
            }

            let configuration = WKWebViewConfiguration()
            configuration.userContentController = userContentController
            configuration.suppressesIncrementalRendering = true

            let webView = WKWebView(frame: .zero,
                                    configuration: configuration)

            return webView
        }()
        webView.configuration.limitsNavigationsToAppBoundDomains = true
        // Thanks https://stackoverflow.com/questions/27211561/transparent-background-wkwebview-nsview/40267954 for this
        webView.setValue(false, forKey: "drawsBackground")
        webView.navigationDelegate = context.coordinator

        return webView
    }

    private func urlWebView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.configuration.limitsNavigationsToAppBoundDomains = false
        webView.configuration.preferences.isTextInteractionEnabled = false
        webView.configuration.suppressesIncrementalRendering = true
        webView.setValue(false, forKey: "drawsBackground")

        return webView
    }

    /// Custom Coordinator which handles persistent scroll position in the WebView.
    ///
    /// # How Persistent Scroll Position Works
    /// This is done by evaluating JavaScript at two points during the WKWebView's navigation lifecycle.
    /// When the WKWebView's navigation delegate is asked to decide the policy for a navigation action,
    /// first the action is checked to validate that it's a valid action (i.e. it doesn't navigate outside
    /// of the current page). If it's invalid, the URL in the action's request
    /// will be open externally using the system's default application. (For 99% of links,
    /// this will be the default web browser.) If it's a valid request,
    /// then we capture the current scroll position using some JavaScript and store the result.
    ///
    /// Once the page has finished loading, it's then safe to call some more
    /// JavaScript that sets the page's scroll position to the value we stored earlier.
    ///
    class Coordinator: NSObject, WKNavigationDelegate {
        private var scrollPosition = CGPoint()

        // https://stackoverflow.com/questions/36231061/wkwebview-open-links-from-certain-domain-in-safari
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                // swiftlint:disable:next line_length
                webView.evaluateJavaScript("[scrollLeft = window.pageXOffset || document.documentElement.scrollLeft, scrollTop = window.pageYOffset || document.documentElement.scrollTop]") { [weak self] value, _ in
                    guard let value = value as? [Int] else {
                        return
                    }
                    self?.scrollPosition = CGPoint(x: value[0], y: value[1])
                }
                decisionHandler(.allow)
                return
            }

            if url.description.lowercased().starts(with: "http://")
                || url.description.lowercased().starts(with: "https://") {
                decisionHandler(.cancel)
                NSWorkspace.shared.open(url)
            } else {
                // swiftlint:disable:next line_length
                webView.evaluateJavaScript("[scrollLeft = window.pageXOffset || document.documentElement.scrollLeft, scrollTop = window.pageYOffset || document.documentElement.scrollTop]") { [weak self] value, _ in
                    guard let value = value as? [Int] else {
                        return
                    }
                    self?.scrollPosition = CGPoint(x: value[0], y: value[1])
                }
                decisionHandler(.allow)
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("""
            document.documentElement.scrollLeft = document.body.scrollLeft = \(scrollPosition.x)
            """)
            webView.evaluateJavaScript("""
            document.documentElement.scrollTop = document.body.scrollTop = \(scrollPosition.y)
            """)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    private func generateStyleScript(context: Context) -> WKUserScript? {
        guard let path = Bundle.main.path(forResource: "github",
                                          ofType: "css"),
            let cssString = try? String(contentsOfFile: path, encoding: .utf8)
            .components(separatedBy: .newlines)
            .joined()
        else {
            fatalError(".css style files for live preview could not be found.")
        }

        let source = """
          var style = document.createElement('style');
          style.innerHTML = '\(cssString)';
          document.head.appendChild(style);
        """

        return WKUserScript(source: source,
                            injectionTime: .atDocumentEnd,
                            forMainFrameOnly: true)
    }
}
