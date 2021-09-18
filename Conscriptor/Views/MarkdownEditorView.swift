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
    @AppStorage("fontsize") private var fontSize = Int(NSFont.systemFontSize)

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
        HSplitView {
            HighlightedTextEditor(text: $document.text, highlightRules: .markdown)
                .frame(minWidth: 300)
                .introspectTextView { textView in
                    self.textView = textView
                }
            if showingPreview {
                WebView(html: html)
                    .frame(minWidth: 300)
                    .background(Color.white)
            }
        }
        .introspectSplitView(customize: { splitView in
            self.splitView = splitView
            splitView.dividerStyle = .thin
        })
        .toolbar(id: "editorControls") {
            toolbarContent()
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

    // MARK: ToolbarContent
    @ToolbarContentBuilder
    func toolbarContent() -> some CustomizableToolbarContent {
        Group {
            ToolbarItem(id: "bold") {
                Button {
                    MarkdownEditorController.format(&document, with: .bold, in: textView)
                } label: {
                    Label("Bold", systemImage: "bold")
                }
            }
            ToolbarItem(id: "italic") {
                Button {
                    MarkdownEditorController.format(&document, with: .italic, in: textView)
                } label: {
                    Label("Italic", systemImage: "italic")
                }
            }
            ToolbarItem(id: "strikethrough") {
                Button {
                    MarkdownEditorController.format(&document, with: .strikethrough, in: textView)
                } label: {
                    Label("Strikethrough", systemImage: "strikethrough")
                }
            }
            ToolbarItem(id: "inlineCode") {
                Button {
                    MarkdownEditorController.format(&document, with: .code, in: textView)
                } label: {
                    Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }
        }
        Group {
            ToolbarItem(id: "link") {
                Button {
                    print("Link")
                } label: {
                    Label("Add Link", systemImage: "link.badge.plus")
                }.disabled(true)
            }
            ToolbarItem(id: "picture") {
                Button {
                    print("Picture")
                } label: {
                    Label("Add Picture", systemImage: "photo")
                }.disabled(true)
            }
            ToolbarItem(id: "table") {
                Button {
                    print("Insert Table")
                } label: {
                    Label("Insert Table", systemImage: "tablecells")
                }.disabled(true)
            }
        }
        Group {
            ToolbarItem(id: "sidebar") {
                Button {
                    withAnimation {
                        showingPreview.toggle()
                    }
                } label: {
                    Label("Toggle Preview", systemImage: "sidebar.right")
                }.disabled(true)
            }
        }
    }
    
    private func setupNotifications() {
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
