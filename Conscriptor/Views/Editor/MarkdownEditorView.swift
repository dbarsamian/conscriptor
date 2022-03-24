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
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var conscriptorDocument: ConscriptorDocument

    // Alerts
    @State private var showingPreview = true
    @State private var showingTablePopover = false
    @State private var showingErrorAlert = false
    @State private var showingTemplateSaveAlert = false
    @State private var showingInsertImageSheet = false
    @State private var showingInsertLinkSheet = false

    // Data
    @State private var newTemplateName = ""
    @State private var newLinkTitle = ""
    @State private var newLinkLocation = ""
    @State private var newImageAlt = ""
    @State private var newImageLocation = ""
    @State private var newTableSize = (0, 0)

    // Internal Views
    @State private var textView: NSTextView?
    @State private var splitView: NSSplitView?

    var html: String {
        let parser = MarkdownParser()
        return parser.html(from: conscriptorDocument.text)
    }

    let editorDelegate = MarkdownEditorDelegate()
    let notificationCenter = NotificationCenter.default

    // MARK: Body

    var body: some View {
        Group {
            if showingPreview {
                GeometryReader { geo in
                    if geo.size.width > 900 {
                        HSplitView {
                            editorContent()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                        .introspectSplitView { spv in
                            splitView = spv
                            splitView?.autosaveName = "com.davidbarsam.Conscriptor.editorSplitView"
                        }
                    } else {
                        VSplitView {
                            editorContent()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                        .introspectSplitView { spv in
                            splitView = spv
                            splitView?.autosaveName = "com.davidbarsam.Conscriptor.editorSplitView"
                        }
                    }
                }
                .toolbar(id: "editorControls") {
                    MarkdownEditorToolbar(showingPreview: $showingPreview,
                                          showingTablePopover: $showingTablePopover,
                                          newTableSize: $newTableSize)
                }
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text("Error"),
                          message: Text("Couldn't generate a live preview for the text entered. Please try again."),
                          dismissButton: .cancel())
                }
                .onAppear {
                    setupNotifications()
                }
            } else {
                editorContent()
                    .toolbar(id: "editorControls") {
                        MarkdownEditorToolbar(showingPreview: $showingPreview,
                                              showingTablePopover: $showingTablePopover,
                                              newTableSize: $newTableSize)
                    }
                    .alert(isPresented: $showingErrorAlert) {
                        Alert(title: Text("Error"),
                              message: Text("Couldn't generate a live preview for the text entered. Please try again."),
                              dismissButton: .cancel())
                    }
                    .onAppear {
                        setupNotifications()
                    }
            }
        }
        .sheet(isPresented: $showingTemplateSaveAlert) {
            SaveTemplateSheet(conscriptorDocument: $conscriptorDocument,
                              newTemplateName: $newTemplateName,
                              showingTemplateSaveAlert: $showingTemplateSaveAlert)
            // TODO try replacing with environmentObjects
        }
        .sheet(isPresented: $showingInsertLinkSheet) {
            InsertLinkSheet(conscriptorDocument: $conscriptorDocument,
                            newLinkTitle: $newLinkTitle,
                            newLinkLocation: $newLinkLocation,
                            showingInsertLinkSheet: $showingInsertLinkSheet,
                            textView: textView)
            .frame(width: 600, height: 400)
        }
        .sheet(isPresented: $showingInsertImageSheet) {
            InsertImageSheet(newImageLocation: $newImageLocation,
                             newImageAlt: $newImageAlt,
                             showingInsertImageSheet: $showingInsertImageSheet,
                             conscriptorDocument: $conscriptorDocument,
                             textView: textView)
            .frame(width: 600, height: 400)
        }
    }

    @ViewBuilder
    func editorContent() -> some View {
        HighlightedTextEditor(text: $conscriptorDocument.text, highlightRules: .markdown)
            .frame(minWidth: 450)
            .introspectTextView { textView in
                self.textView = textView
                textView.textContainerInset = .init(width: 30, height: 40)
                textView.usesFontPanel = false
                textView.usesFindPanel = true
                if let scrollView = textView.enclosingScrollView {
                    scrollView.autohidesScrollers = true
                }
            }
    }

    @ViewBuilder
    func livePreview() -> some View {
        GeometryReader { geo in
            ScrollView {
                WebView(html, type: .html)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(height: geo.size.height)
        }
        .frame(minWidth: 450)
    }

    // MARK: - View Config

    public func setupNotifications() {
        // Text Formatting
        notificationCenter.addObserver(forName: .formatBold, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .bold, in: textView)
        }
        notificationCenter.addObserver(forName: .formatItalic, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .italic, in: textView)
        }
        notificationCenter.addObserver(forName: .formatStrikethrough, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .strikethrough, in: textView)
        }
        notificationCenter.addObserver(forName: .formatInlineCode, object: nil, queue: .main) { _ in
            MarkdownEditorController.format(&conscriptorDocument, with: .code, in: textView)
        }

        // Insertion
        notificationCenter.addObserver(forName: .insertLink, object: nil, queue: .main) { _ in
            showingInsertLinkSheet.toggle()
        }
        notificationCenter.addObserver(forName: .insertImage, object: nil, queue: .main) { _ in
            showingInsertImageSheet.toggle()
        }
        notificationCenter.addObserver(forName: .insertTable, object: nil, queue: .main) { _ in
            MarkdownEditorController.insert(table: newTableSize, in: textView, update: &conscriptorDocument)
        }

        // Other
        notificationCenter.addObserver(forName: .saveNewTemplate, object: nil, queue: .main) { _ in
            showingTemplateSaveAlert.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        MarkdownEditorView(conscriptorDocument: .constant(ConscriptorDocument(text: "# Preview\n\nThis is a **preview** document. It will *display* in the ~~UIKit~~ SwiftUI preview. It is of type `ConscriptorDocument` and is constant. Here's a picture:\n\n![alt text](https://i.kym-cdn.com/entries/icons/mobile/000/012/982/039.jpg)")))
            .previewLayout(.fixed(width: 801, height: 600))
    }
}
