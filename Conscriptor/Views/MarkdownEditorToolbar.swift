//
//  MarkdownEditorToolbar.swift
//  Conscriptor
//
//  Created by David Barsamian on 10/7/21.
//

import Foundation
import SwiftUI
import AppKit

struct MarkdownEditorToolbar: CustomizableToolbarContent {
    @Binding var document: ConscriptorDocument
    @State var showingPreview: Bool
    let textView: NSTextView?
    
    var body: some CustomizableToolbarContent {
        Group {
            ToolbarItem(id: "bold") {
                Button {
                    MarkdownEditorController.format(&document, with: .bold, in: textView)
                } label: {
                    Label("Bold", systemImage: "bold")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "italic") {
                Button {
                    MarkdownEditorController.format(&document, with: .italic, in: textView)
                } label: {
                    Label("Italic", systemImage: "italic")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "strikethrough") {
                Button {
                    MarkdownEditorController.format(&document, with: .strikethrough, in: textView)
                } label: {
                    Label("Strikethrough", systemImage: "strikethrough")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "inlineCode") {
                Button {
                    MarkdownEditorController.format(&document, with: .code, in: textView)
                } label: {
                    Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
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
}
