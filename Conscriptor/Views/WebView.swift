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

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let userScript = generateStyleScript(context: context) {
            nsView.configuration.userContentController.addUserScript(userScript)
        }
        nsView.loadHTMLString(html, baseURL: nil)
    }

    private func generateStyleScript(context: Context) -> WKUserScript? {
        guard let path = Bundle.main.path(forResource: context.environment.colorScheme == .light ? "github-light" : "github-dark", ofType: "css"),
              let cssString = try? String(contentsOfFile: path, encoding: .utf8).components(separatedBy: .newlines).joined() else {
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
