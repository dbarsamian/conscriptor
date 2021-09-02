//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import HighlightedTextEditor
import Introspect
import MarkdownSyntax
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("fontsize") private var fontSize = Int(NSFont.systemFontSize)
    
    @Binding var document: ConscriptorDocument
    @State private var showingErrorAlert = false

    var html: String {
        do {
            return try Markdown(text: document.text).renderHtml()
        } catch {
            print(error.localizedDescription)
            showingErrorAlert.toggle()
            return ""
        }
    }

    var body: some View {
        HSplitView {
            HighlightedTextEditor(text: $document.text, highlightRules: .markdown)
                .frame(minWidth: 300)
                .introspectTextView { textView in
                    textView.enclosingScrollView?.autohidesScrollers = true
                    textView.textContainerInset = .init(width: 30, height: 40)
                }
            WebView(html: html)
                .frame(minWidth: 300)
        }
        .introspectSplitView(customize: { splitView in
            splitView.dividerStyle = .thin
        })
        .toolbar {
            toolbarContent
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Couldn't generate a live preview for the text entered. Please try again."), dismissButton: .cancel())
        }
    }

    var toolbarContent: some ToolbarContent {
        Group {
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
                Button {
                    print("Strikethrough")
                } label: {
                    Image(systemName: "strikethrough")
                }
            }
            ToolbarItemGroup {
                Button {
                    print("Link")
                } label: {
                    Image(systemName: "link.badge.plus")
                }
                Button {
                    print("Smart Code")
                } label: {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                }
                Button {
                    print("Insert Table")
                } label: {
                    Image(systemName: "tablecells")
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
