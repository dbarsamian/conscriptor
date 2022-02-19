//
//  MarkdownEditorToolbar.swift
//  Conscriptor
//
//  Created by David Barsamian on 10/7/21.
//

import AppKit
import Foundation
import SwiftUI

struct MarkdownEditorToolbar: CustomizableToolbarContent {
    @Binding var document: ConscriptorDocument
    @Binding var showingPreview: Bool
    let textView: NSTextView?

    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "spacer") {
            Spacer()
        }
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
                    if #available(macOS 12.0, *) {
                        Label("Code", systemImage: "chevron.left.forwardslash.chevron.right") // Monterey+
                            .foregroundColor(Color(NSColor.secondaryLabelColor))
                    } else {
                        Label("Code", systemImage: "chevron.left.slash.chevron.right") // Legacy name
                            .foregroundColor(Color(NSColor.secondaryLabelColor))
                    }
                }
            }
        }
        ToolbarItem(id: "spacer") {
            Spacer()
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
        ToolbarItem(id: "spacer") {
            Spacer()
        }
        Group {
            ToolbarItem(id: "sidebar") {
                Button {
                    showingPreview.toggle()
                } label: {
                    Label("Toggle Preview", systemImage: "sidebar.right")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
        }
    }
}
