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
            MarkdownEditorView(document: file.$document)
                .frame(minWidth: 400, minHeight: 500)
        }
        .commands {
            ToolbarCommands()
            TextEditingCommands()
            CommandGroup(replacing: .textFormatting) {
                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatBold, object: nil)
                } label: {
                    Text("Bold")
                }.keyboardShortcut("b", modifiers: .command)
                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatItalic, object: nil)
                } label: {
                    Text("Italic")
                }.keyboardShortcut("i", modifiers: .command)
                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatStrikethrough, object: nil)
                } label: {
                    Text("Strikethrough")
                }.keyboardShortcut("k", modifiers: .command)
                Button {
                    let nc = NotificationCenter.default
                    nc.post(name: .formatInlineCode, object: nil)
                } label: {
                    Text("Inline Code")
                }.keyboardShortcut("/", modifiers: .command)
            }
        }
    }
}
