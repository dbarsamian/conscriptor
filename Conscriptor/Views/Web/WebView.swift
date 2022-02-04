//
//  WebView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var html: String

    init(html: String) {
        self.html = html
    }

    func makeNSView(context: Context) -> WKWebView {
        /// See https://stackoverflow.com/questions/33123093/insert-css-into-loaded-html-in-uiwebview-wkwebview for details

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
        /// Thanks https://stackoverflow.com/questions/27211561/transparent-background-wkwebview-nsview/40267954 for this
        webView.setValue(false, forKey: "drawsBackground")

        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let userScript = generateStyleScript(context: context) {
            nsView.configuration.userContentController.addUserScript(userScript)
        }

        nsView.loadHTMLString(html, baseURL: nil)
    }

    /// Custom Coordinator which handles persistent scroll position in the WebView.
    ///
    /// # How Persistent Scroll Position Works
    /// This is done by evaluating JavaScript at two points during the WKWebView's navigation lifecycle.
    /// When the WKWebView's navigation delegate is asked to decide the policy for a navigation action, first the action is checked
    /// to validate that it's a valid action (i.e. it doesn't navigate outside of the current page). If it's invalid, the URL in the action's request
    /// will be open externally using the system's default application. (For 99% of links, this will be the default web browser.)
    /// If it's a valid request, then we capture the current scroll position using some JavaScript and store the result.
    ///
    /// Once the page has finished loading, it's then safe to call some more JavaScript that sets the page's scroll position to the value
    /// we stored earlier.
    ///
    class Coordinator: NSObject, WKNavigationDelegate {
        private var scrollPosition = CGPoint() {
            didSet {
                print("Navigation: \(scrollPosition)")
            }
        }

        // https://stackoverflow.com/questions/36231061/wkwebview-open-links-from-certain-domain-in-safari
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("Navigation: deciding policy for action...")
            guard let url = navigationAction.request.url else {
                webView.evaluateJavaScript("[scrollLeft = window.pageXOffset || document.documentElement.scrollLeft, scrollTop = window.pageYOffset || document.documentElement.scrollTop]") { [weak self] value, _ in
                    guard let value = value as? [Int] else {
                        print(String(describing: value))
                        return
                    }
                    self?.scrollPosition = CGPoint(x: value[0], y: value[1])
                    print("Navigation: scroll position captured")
                }
                decisionHandler(.allow)
                print("Navigation: navigation action accepted")
                return
            }

            if url.description.lowercased().starts(with: "http://") || url.description.lowercased().starts(with: "https://") {
                decisionHandler(.cancel)
                print("Navigation: navgiation action denied")
                NSWorkspace.shared.open(url)
            } else {
                webView.evaluateJavaScript("[scrollLeft = window.pageXOffset || document.documentElement.scrollLeft, scrollTop = window.pageYOffset || document.documentElement.scrollTop]") { [weak self] value, _ in
                    guard let value = value as? [Int] else {
                        print(String(describing: value))
                        return
                    }
                    self?.scrollPosition = CGPoint(x: value[0], y: value[1])
                    print("Navigation: scroll position captured")
                }
                decisionHandler(.allow)
                print("Navigation: navigation action accepted")
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Navigation: did finish navigation")
            webView.evaluateJavaScript("document.documentElement.scrollLeft = document.body.scrollLeft = \(scrollPosition.x)") { _, _ in
                print("Navigation: applied X scroll")
            }
            webView.evaluateJavaScript("document.documentElement.scrollTop = document.body.scrollTop = \(scrollPosition.y)") { _, _ in
                print("Navigation: applied Y scroll")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    private func generateStyleScript(context: Context) -> WKUserScript? {
        guard let path = Bundle.main.path(forResource: context.environment.colorScheme == .light ? "github-light" : "github-dark", ofType: "css"),
              let cssString = try? String(contentsOfFile: path, encoding: .utf8).components(separatedBy: .newlines).joined()
        else {
            print("ERROR: COULD NOT FIND CSS FILES")
            return nil
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
