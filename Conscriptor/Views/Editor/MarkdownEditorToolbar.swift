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
    @Binding var showingTablePopover: Bool
    @Binding var newTableSize: (Int, Int)
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
                    newTableSize = (0, 0)
                    showingTablePopover.toggle()
                } label: {
                    Label("Insert Table", systemImage: "tablecells")
                        .foregroundColor(Color(NSColor.secondaryLabelColor))
                }
                .popover(isPresented: $showingTablePopover, arrowEdge: .bottom) {
                    VStack {
                        Text("\(newTableSize.0) x \(newTableSize.1)")
                        VStack {
                            ForEach(0 ..< 5) { row in
                                HStack {
                                    ForEach(0 ..< 5) { col in
                                        if newTableSize.0 >= col + 1 && newTableSize.1 >= row + 1 {
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(Color.blue)
                                                .frame(width: 15, height: 15)
                                                .onHover { _ in
                                                    newTableSize = (col + 1, row + 1)
                                                }
                                                .onTapGesture {
                                                    NotificationCenter.default.post(name: .insertTable, object: nil)
                                                    showingTablePopover.toggle()
                                                }
                                        } else {
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.secondary)
                                                .frame(width: 15, height: 15)
                                                .onHover { _ in
                                                    newTableSize = (col + 1, row + 1)
                                                }
                                                .onTapGesture {
                                                    NotificationCenter.default.post(name: .insertTable, object: nil)
                                                    showingTablePopover.toggle()
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
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
