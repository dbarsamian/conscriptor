//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import CodeEditor
import HighlightedTextEditor
import Ink
import Introspect
import MarkdownUI
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("fontsize") private var fontSize = Int(NSFont.systemFontSize)
    @Binding var document: ConscriptorDocument

    var html: String {
        let parser = MarkdownParser()
        return parser.html(from: document.text)
    }

    var body: some View {
        HStack(spacing: 2) {
            // CodeEditor package
//            CodeEditor(source: $document.text,
//                       language: .markdown,
//                       theme: .atelierSavannaLight,
//                       fontSize: .init(get: {
//                           CGFloat(fontSize)
//                       }, set: {
//                           fontSize = Int($0)
//                       }))
            // HighlightedTextEditor package
            HighlightedTextEditor(text: $document.text, highlightRules: .markdown)
            // MarkdownUI package
            ScrollView {
                Markdown(.init(document.text))
                    .padding()
            }
            // WebView
//            WebView(html: html)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ConscriptorDocument()))
    }
}
