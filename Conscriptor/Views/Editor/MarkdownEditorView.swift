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

    // Internal Views
    @State private var textView: NSTextView?
    @State private var webScrollView: NSScrollView?
    @State private var splitView: NSSplitView?
    @State private var scrollPosition = NSPoint.zero

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
                    if geo.size.width > 800 {
                        HStack(spacing: 0) {
                            editorContent()
                            Divider()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                    } else {
                        VStack(spacing: 0) {
                            editorContent()
                            Divider()
                            livePreview()
                                .background(Color(NSColor.textBackgroundColor))
                        }
                    }
                }
                .toolbar(id: "editorControls") {
                    MarkdownEditorToolbar(showingPreview: $showingPreview)
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
                        MarkdownEditorToolbar(showingPreview: $showingPreview)
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
            VStack {
                Text("Save as Template")
                    .font(.title2)
                TextField("Template Title", text: $newTemplateName, prompt: Text("Enter a name for this template..."))
                    .padding(.vertical)
                HStack {
                    Button("Cancel", role: .cancel) {
                        showingTemplateSaveAlert.toggle()
                    }
                    Spacer()
                    Button("Save") {
                        let template = UserTemplate(context: managedObjectContext)
                        template.id = UUID()
                        template.name = newTemplateName
                        template.document = conscriptorDocument.text

                        if managedObjectContext.hasChanges {
                            try? managedObjectContext.save()
                        }

                        showingTemplateSaveAlert.toggle()
                    }
                    .disabled(newTemplateName.isEmpty)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingInsertLinkSheet) {
            VStack {
                Text("Insert Link")
                    .font(.title2)
                TextField("Link Title", text: $newLinkTitle, prompt: Text("Enter a title for the link..."))
                TextField("Link URL", text: $newLinkLocation, prompt: Text("Enter the URL for the link..."))
                HStack {
                    Button("Cancel", role: .cancel) {
                        showingInsertLinkSheet.toggle()
                    }
                    Spacer()
                    Button("Insert") {
                        MarkdownEditorController.insert(link: newLinkLocation,
                                                        withTitle: newLinkTitle,
                                                        in: textView,
                                                        update: &conscriptorDocument)
                        newLinkLocation = ""
                        newLinkTitle = ""
                        showingInsertLinkSheet.toggle()
                    }
                    .disabled(newLinkTitle.isEmpty || newLinkLocation.isEmpty)
                }
            }
            .padding()
            .frame(width: 300, height: 150)
        }
        .sheet(isPresented: $showingInsertImageSheet) {
            VStack {
                Text("Insert Image")
                    .font(.title2)
                Spacer()
                if let imageUrl = URL(string: newImageLocation) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)

                }
                Spacer()
                TextField("Image Alt Text", text: $newImageAlt, prompt: Text("Enter a title for the link..."))
                TextField("Image URL", text: $newImageLocation, prompt: Text("Enter the URL for the link..."))
                HStack {
                    Button("Cancel", role: .cancel) {
                        showingInsertImageSheet.toggle()
                    }
                    Spacer()
                    Button("Insert") {
                        MarkdownEditorController.insert(image: newImageLocation,
                                                        withAlt: newImageAlt,
                                                        in: textView,
                                                        update: &conscriptorDocument)
                        newImageLocation = ""
                        newImageAlt = ""
                        showingInsertImageSheet.toggle()
                    }
                    .disabled(newImageLocation.isEmpty || newImageAlt.isEmpty)
                }
            }
            .padding()
            .frame(width: 400, height: 400)
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
                WebView(html: html)
                    .frame(minWidth: 300, idealHeight: geo.size.height)
            }
            .frame(height: geo.size.height)
            .introspectScrollView { scrollView in
                self.webScrollView = scrollView
            }
        }
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
            .previewLayout(.fixed(width: 600, height: 600))
    }
}
