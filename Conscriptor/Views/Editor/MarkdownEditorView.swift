//
//  ContentView.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import Combine
import HighlightedTextEditor
import Introspect
import Parsley
import SwiftUI

struct MarkdownEditorView: View {
    @Binding var conscriptorDocument: ConscriptorDocument

    // View State
    @State private var showingPreview = true
    @State private var showingTablePopover = false
    @State private var showingTemplateSaveAlert = false
    @State private var showingInsertImageSheet = false
    @State private var showingInsertLinkSheet = false

    // Data
    @State private var newTemplateName = ""
    @State private var newLinkTitle = ""
    @State private var newLinkLocation = ""
    @State private var newLinkSelection = NSRange()
    @State private var newImageAlt = ""
    @State private var newImageLocation = ""
    @State private var newImageSelection = NSRange()
    @State private var newTableSize = (0, 0)

    // Internal Views
    @State private var textView: NSTextView?

    var html: String {
        do {
            return try Parsley.html(conscriptorDocument.text)
        } catch {
            return ""
        }
    }

    let notificationCenter = NotificationCenter.default

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            Group {
                if geo.size.width > 900 {
                    HStack(spacing: 0) {
                        editorContent()
                        if showingPreview {
                            Divider()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                    }
                } else {
                    VStack(spacing: 0) {
                        editorContent()
                        if showingPreview {
                            Divider()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                    }
                }
            }
        }
        .toolbar(id: "editorControls") {
            MarkdownEditorToolbar(showingPreview: $showingPreview,
                                  showingTablePopover: $showingTablePopover,
                                  newTableSize: $newTableSize)
        }
        .onAppear {
            setupNotifications()
        }
        .sheet(isPresented: $showingTemplateSaveAlert) {
            SaveTemplateSheet(conscriptorDocument: $conscriptorDocument,
                              newTemplateName: $newTemplateName,
                              showingTemplateSaveAlert: $showingTemplateSaveAlert)
        }
        .sheet(isPresented: $showingInsertLinkSheet) {
            InsertLinkSheet(conscriptorDocument: $conscriptorDocument,
                            newLinkTitle: $newLinkTitle,
                            newLinkLocation: $newLinkLocation,
                            newLinkSelection: $newLinkSelection,
                            showingInsertLinkSheet: $showingInsertLinkSheet,
                            textView: textView)
                .frame(width: 600, height: 400)
        }
        .sheet(isPresented: $showingInsertImageSheet) {
            InsertImageSheet(newImageLocation: $newImageLocation,
                             newImageAlt: $newImageAlt,
                             newImageSelection: $newImageSelection,
                             showingInsertImageSheet: $showingInsertImageSheet,
                             conscriptorDocument: $conscriptorDocument,
                             textView: textView)
                .frame(width: 600, height: 400)
        }
    }

    @ViewBuilder
    func editorContent() -> some View {
        HighlightedTextEditor(text: $conscriptorDocument.text, highlightRules: .markdown)
            .introspect(callback: { editor in
                editor.scrollView?.autohidesScrollers = true
            })
            .frame(minWidth: 450)
            .id("TextEdtior")
            .introspectTextView { textView in
                self.textView = textView
                textView.textContainerInset = NSSize(width: 30, height: 40)
                textView.usesFontPanel = false
                textView.usesFindPanel = true
            }
    }

    @ViewBuilder
    func livePreview() -> some View {
        WebView(html, type: .html)
            .id("LivePreview")
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
            if let textView = textView,
               let selectedRange = textView.selectedRanges.map({ $0.rangeValue }).first {
                newLinkSelection = selectedRange
            }
            showingInsertLinkSheet.toggle()
        }
        notificationCenter.addObserver(forName: .insertImage, object: nil, queue: .main) { _ in
            if let textView = textView,
               let selectedRange = textView.selectedRanges.map({ $0.rangeValue }).first {
                newImageSelection = selectedRange
            }
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
            .previewLayout(.fixed(width: 1000, height: 600))
    }
}
