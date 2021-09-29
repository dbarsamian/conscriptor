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
        // See https://stackoverflow.com/questions/33123093/insert-css-into-loaded-html-in-uiwebview-wkwebview for details
        lazy var webView: WKWebView = {
            guard let path = Bundle.main.path(forResource: context.environment.colorScheme == .light ? "github-light" : "github-dark", ofType: "css"),
                  let cssString = try? String(contentsOfFile: path, encoding: .utf8).components(separatedBy: .newlines).joined() else {
                return WKWebView()
            }

            let source = """
              var style = document.createElement('style');
              style.innerHTML = '\(cssString)';
              document.head.appendChild(style);
            """

            let userScript = WKUserScript(source: source,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)

            let userContentController = WKUserContentController()
            userContentController.addUserScript(userScript)

            let configuration = WKWebViewConfiguration()
            configuration.userContentController = userContentController

            let webView = WKWebView(frame: .zero,
                                    configuration: configuration)
            return webView
        }()
        webView.configuration.limitsNavigationsToAppBoundDomains = true
        
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(html, baseURL: nil)
    }
}
