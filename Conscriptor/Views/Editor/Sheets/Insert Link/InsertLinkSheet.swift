//
//  InsertLinkSheet.swift
//  Conscriptor
//
//  Created by David Barsamian on 3/22/22.
//

import SwiftUI

struct InsertLinkSheet: View {
    @Binding var conscriptorDocument: ConscriptorDocument
    @Binding var newLinkTitle: String
    @Binding var newLinkLocation: String
    @Binding var newLinkSelection: NSRange
    @Binding var showingInsertLinkSheet: Bool
    let textView: NSTextView?

    var body: some View {
        HStack {
            if newLinkLocation.isEmpty {
                Color(NSColor.windowBackgroundColor)
            } else {
                WebView(newLinkLocation, type: .url)
                    .background(ProgressView())
                    .disabled(true)
            }

            VStack(alignment: .leading) {
                Text("Insert Link")
                    .font(.title)
                Spacer()
                Text("Name")
                    .font(.headline)
                TextField("Link Title", text: $newLinkTitle, prompt: Text("Wikipedia"))
                Text("URL")
                    .font(.headline)
                TextField("Link URL", text: $newLinkLocation, prompt: Text("https://wikipedia.com"))
                HStack {
                    Button("Cancel", role: .cancel) {
                        clearFields()
                        showingInsertLinkSheet.toggle()
                    }
                    Spacer()
                    Button("Insert") {
                        MarkdownEditorController.insert(link: newLinkLocation,
                                                        withTitle: newLinkTitle,
                                                        range: newLinkSelection,
                                                        in: textView,
                                                        update: &conscriptorDocument)
                        clearFields()
                        showingInsertLinkSheet.toggle()
                    }
                    .disabled(newLinkTitle.isEmpty || newLinkLocation.isEmpty)
                }
            }
            .padding()
            .frame(maxWidth: 200)
        }
        .onAppear {
            let selection = textView!.textStorage!.string[Range(newLinkSelection)!]
            if selection.hasPrefix("http://") || selection.hasPrefix("https://") {
                newLinkLocation = selection
            } else {
                newLinkTitle = selection
            }
        }
        .onExitCommand {
            showingInsertLinkSheet.toggle()
        }
    }

    private func clearFields() {
        newLinkLocation = ""
        newLinkTitle = ""
        newLinkSelection = NSRange()
    }
}
