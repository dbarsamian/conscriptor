//
//  Shortcuts.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/7/22.
//

import KeyboardShortcuts
import SwiftUI

extension KeyboardShortcuts.Name {
    static let saveAsTemplate = Self("saveAsTemplate", default: Shortcut(.s, modifiers: [.control, .shift]))
    static let formatBold = Self("formatBold", default: Shortcut(.b, modifiers: [.command]))
    static let formatItalic = Self("formatItalic", default: Shortcut(.i, modifiers: [.command]))
    static let formatStrikethrough = Self("formatStrikethrough", default: Shortcut(.k, modifiers: [.command]))
    static let formatInlineCode = Self("formatInlineCode", default: Shortcut(.slash, modifiers: [.command]))
    static let insertImage = Self("insertImage", default: Shortcut(.i, modifiers: [.command, .option]))
    static let insertLink = Self("insertLink", default: Shortcut(.l, modifiers: [.command, .option]))
}
