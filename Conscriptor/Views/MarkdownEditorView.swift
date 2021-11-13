//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import Combine
import HighlightedTextEditor
import Ink
import Introspect
import SwiftUI

struct MarkdownEditorView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var conscriptorDocument: ConscriptorDocument

    @State private var showingPreview = true
    @State private var showingErrorAlert = false
    @State private var textView: NSTextView?
    @State private var splitView: NSSplitView?
    @State private var scrollPosition = NSPoint.zero
    
    var html: String {
        let parser = MarkdownParser()
        return parser.html(from: conscriptorDocument.text)
    }

    // MARK: Body

    var body: some View {
        if showingPreview {
            GeometryReader { geo in
                if geo.size.width > 800 {
                    HStack(spacing: 0) {
                        editorContent()
                        Color(NSColor.windowBackgroundColor)
                            .frame(width: 2)
                        livePreview()
                            .background(Color(NSColor.textBackgroundColor))
                    }
                } else {
                    VStack(spacing: 0) {
                        editorContent()
                        Color(NSColor.windowBackgroundColor)
                            .frame(height: 2)
                        livePreview()
                            .background(Color(NSColor.textBackgroundColor))
                    }
                }
            }
            .toolbar(id: "editorControls") {
                MarkdownEditorToolbar(document: $conscriptorDocument, showingPreview: $showingPreview, textView: textView)
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text("Couldn't generate a live preview for the text entered. Please try again."), dismissButton: .cancel())
            }
            .onAppear {
                setupNotifications()
            }
        } else {
            editorContent()
                .toolbar(id: "editorControls") {
                    MarkdownEditorToolbar(document: $conscriptorDocument, showingPreview: $showingPreview, textView: textView)
                }
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text("Error"), message: Text("Couldn't generate a live preview for the text entered. Please try again."), dismissButton: .cancel())
                }
                .onAppear {
                    setupNotifications()
                }
        }
    }
    
    @ViewBuilder
    func editorContent() -> some View {
        HighlightedTextEditor(text: $conscriptorDocument.text, highlightRules: .markdown)
            .frame(minWidth: 300)
            .introspectTextView { textView in
                self.textView = textView
                textView.textContainerInset = .init(width: 30, height: 40)
                textView.usesFontPanel = false
                if let scrollView = textView.enclosingScrollView {
                    scrollView.autohidesScrollers = true
                }
            }
    }
    
    @ViewBuilder
    func livePreview() -> some View {
        WebView(html: html)
            .frame(minWidth: 300)
    }

    // MARK: - View Config

    public func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: .formatBold, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .bold, in: textView)
        }
        nc.addObserver(forName: .formatItalic, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .italic, in: textView)
        }
        nc.addObserver(forName: .formatStrikethrough, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .strikethrough, in: textView)
        }
        nc.addObserver(forName: .formatInlineCode, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .code, in: textView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownEditorView(conscriptorDocument: .constant(ConscriptorDocument()))
    }
}
