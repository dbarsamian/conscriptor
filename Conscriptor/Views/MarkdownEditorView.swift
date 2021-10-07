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

struct MarkdownEditorView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var document: ConscriptorDocument
    @State private var showingPreview = true
    @State private var showingErrorAlert = false
    @State private var textView: NSTextView?
    @State private var splitView: NSSplitView?

    var html: String {
        do {
            return try Markdown(text: document.text).renderHtml()
        } catch {
            print(error.localizedDescription)
            showingErrorAlert.toggle()
            return ""
        }
    }

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            if geo.size.width < 600 {
                VSplitView {
                    editorContent()
                    if showingPreview {
                        previewContent()
                    }
                }
            } else {
                HSplitView {
                    editorContent()
                    if showingPreview {
                        previewContent()
                    }
                }
            }
        }
        .introspectSplitView(customize: { splitView in
            self.splitView = splitView
            splitView.dividerStyle = .thin
        })
        .toolbar(id: "editorControls") {
            MarkdownEditorToolbar(document: $document, showingPreview: showingPreview, textView: textView)
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Couldn't generate a live preview for the text entered. Please try again."), dismissButton: .cancel())
        }
        .onAppear {
            setupNotifications()
        }
        // The following blocks functionally fire only once.
        .onChange(of: textView) { newValue in
            if let newValue = newValue {
                configureTextView(newValue)
            } else {
                NSLog("ContentView textView reference invalid", "")
            }
        }
        .onChange(of: splitView) { newValue in
            if let newValue = newValue {
                configureSplitView(newValue)
            } else {
                NSLog("ContentView splitView reference invalid", "")
            }
        }
    }

    @ViewBuilder
    func editorContent() -> some View {
        HighlightedTextEditor(text: $document.text, highlightRules: .markdown)
            .frame(minWidth: 300)
            .layoutPriority(1)
            .introspectTextView { textView in
                self.textView = textView
            }
    }

    @ViewBuilder
    func previewContent() -> some View {
        WebView(html: html)
            .frame(minWidth: 300)
            .layoutPriority(1)
            .background(Color.white)
            .id(colorScheme)
    }

    // MARK: - View Config

    public func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: .formatBold, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&document, with: .bold, in: textView)
        }
        nc.addObserver(forName: .formatItalic, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&document, with: .italic, in: textView)
        }
        nc.addObserver(forName: .formatStrikethrough, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&document, with: .strikethrough, in: textView)
        }
        nc.addObserver(forName: .formatInlineCode, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&document, with: .code, in: textView)
        }
    }

    private func configureTextView(_ textView: NSTextView) {
        textView.enclosingScrollView?.autohidesScrollers = true
        textView.textContainerInset = .init(width: 30, height: 40)
        textView.usesFontPanel = false
    }

    private func configureSplitView(_ splitView: NSSplitView) {
        // TODO: find a way to get splitviewcontroller so I can collapse panes in a pretty way with animation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownEditorView(document: .constant(ConscriptorDocument()))
    }
}
