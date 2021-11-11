//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import Combine
import HighlightedTextEditor
import Introspect
import MarkdownUI
import SwiftUI

struct MarkdownEditorView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var conscriptorDocument: ConscriptorDocument
    
    @State private var showingPreview = true
    @State private var showingErrorAlert = false
    @State private var textView: NSTextView?
    @State private var splitView: NSSplitView?
    @State private var scrollPosition = NSPoint.zero

//    var html: String {
//        do {
//            return try Markdown(text: document.text).renderHtml()
//        } catch {
//            print(error.localizedDescription)
//            showingErrorAlert.toggle()
//            return ""
//        }
//    }

    var editorContent: some View {
        HighlightedTextEditor(text: $conscriptorDocument.text, highlightRules: .markdown)
            .frame(minWidth: 300)
            .introspectTextView { textView in
                self.textView = textView
            }
    }

    var livePreview: some View {
//        WebView(html: html, scrollPosition: scrollPosition)
//            .frame(minWidth: 300)
//            .background(Color.white)
//            .id(colorScheme)
        Markdown(Document(stringLiteral: conscriptorDocument.text))
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
    }

    // MARK: Body

    var body: some View {
//        GeometryReader { geo in
//            if geo.size.width < 600 {
//                VSplitView {
//                    editorContent
//                    if showingPreview {
//                        livePreview
//                    }
//                }
//            } else {
//                HSplitView {
//                    editorContent
//                    if showingPreview {
//                        livePreview
//                    }
//                }
//            }
//        }
        HSplitView {
            editorContent
            if showingPreview {
                ScrollView {
                    livePreview
                }
            }
        }
        .introspectSplitView(customize: { splitView in
            self.splitView = splitView
            splitView.dividerStyle = .thin
        })
        .toolbar(id: "editorControls") {
            MarkdownEditorToolbar(document: $conscriptorDocument, showingPreview: showingPreview, textView: textView)
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

    private func configureTextView(_ textView: NSTextView) {
        textView.textContainerInset = .init(width: 30, height: 40)
        textView.usesFontPanel = false
        if let scrollView = textView.enclosingScrollView {
            scrollView.autohidesScrollers = true
        }
    }

    private func configureSplitView(_ splitView: NSSplitView) {
        // TODO: find a way to get splitviewcontroller so I can collapse panes in a pretty way with animation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownEditorView(conscriptorDocument: .constant(ConscriptorDocument()))
    }
}
