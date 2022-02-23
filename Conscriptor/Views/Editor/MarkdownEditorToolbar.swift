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
    @Binding var showingPreview: Bool
    let notificationCenter = NotificationCenter.default

    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "spacer") {
            Spacer()
        }
        Group {
            ToolbarItem(id: "bold") {
                Button {
                    notificationCenter.post(name: .formatBold, object: nil)
                } label: {
                    Label("Bold", systemImage: "bold")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "italic") {
                Button {
                    notificationCenter.post(name: .formatItalic, object: nil)
                } label: {
                    Label("Italic", systemImage: "italic")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "strikethrough") {
                Button {
                    notificationCenter.post(name: .formatStrikethrough, object: nil)
                } label: {
                    Label("Strikethrough", systemImage: "strikethrough")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "inlineCode") {
                Button {
                    notificationCenter.post(name: .formatInlineCode, object: nil)
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
                    notificationCenter.post(name: .insertLink, object: nil)
                } label: {
                    Label("Add Link", systemImage: "link.badge.plus")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
            }
            ToolbarItem(id: "picture") {
                Button {
                    notificationCenter.post(name: .insertImage, object: nil)
                } label: {
                    Label("Add Picture", systemImage: "photo")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
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
