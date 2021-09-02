//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

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
        HSplitView {
            HighlightedTextEditor(text: $document.text, highlightRules: .markdown)
                .frame(minWidth: 300)
                .introspectTextView { textView in
                    textView.enclosingScrollView?.autohidesScrollers = true
                }
            ZStack {
                WebView(html: html)
                ProgressView()
            }
            .frame(minWidth: 300)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    print("Bold")
                } label: {
                    Image(systemName: "bold")
                }
                Button {
                    print("Italic")
                } label: {
                    Image(systemName: "italic")
                }
                Button {
                    print("Underline")
                } label: {
                    Image(systemName: "underline")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ConscriptorDocument()))
    }
}
