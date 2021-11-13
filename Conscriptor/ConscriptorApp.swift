//
//  ConscriptorApp.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import SwiftUI

@main
struct ConscriptorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ConscriptorDocument()) { file in
            MarkdownEditorView(conscriptorDocument: file.$document)
                .frame(minWidth: 650, minHeight: 800)
        }
        .windowToolbarStyle(.unified)
        .commands {
            ToolbarCommands()
            TextEditingCommands()
            CommandGroup(replacing: .textFormatting) {
                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatBold, object: nil)
                } label: {
                    Text("Bold")
                }
                .keyboardShortcut("b", modifiers: .command)

                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatItalic, object: nil)
                } label: {
                    Text("Italic")
                }
                .keyboardShortcut("i", modifiers: .command)

                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatStrikethrough, object: nil)
                } label: {
                    Text("Strikethrough")
                }
                .keyboardShortcut("k", modifiers: .command)

                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatInlineCode, object: nil)
                } label: {
                    Text("Inline Code")
                }
                .keyboardShortcut("/", modifiers: .command)
                
                Divider()
                
                Button {
//                    let nc = NotificationCenter.default
//                    nc.post(name: .insertImage, object: nil)
                } label: {
                    Text("Insert Image")
                }
                .keyboardShortcut("i", modifiers: .option)
                .disabled(true)
                
                Button {
//                    let nc = NotificationCenter.default
//                    nc.post(name: .insertLink, object: nil)
                } label: {
                    Text("Add Link")
                }
                .keyboardShortcut("l", modifiers: .command)
                .disabled(true)
            }
        }
    }
}
