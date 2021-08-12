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
        let webView = WKWebView()
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(html, baseURL: nil)
    }
}
