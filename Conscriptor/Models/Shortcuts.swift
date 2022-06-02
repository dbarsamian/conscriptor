//
//  Shortcuts.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/26/22.
//

import SwiftUI
import KeyboardShortcuts

@MainActor
final class Shortcuts: ObservableObject {
    private let notificationCenter = NotificationCenter.default

    init() {
        KeyboardShortcuts.onKeyUp(for: .saveAsTemplate) { [self] in
            notificationCenter.post(name: .saveNewTemplate, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .formatBold) { [self] in
            notificationCenter.post(name: .formatBold, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .formatItalic) { [self] in
            notificationCenter.post(name: .formatItalic, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .formatStrikethrough) { [self] in
            notificationCenter.post(name: .formatStrikethrough, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .formatInlineCode) { [self] in
            notificationCenter.post(name: .formatInlineCode, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .insertLink) { [self] in
            notificationCenter.post(name: .insertLink, object: nil)
        }
        KeyboardShortcuts.onKeyUp(for: .insertImage) { [self] in
            notificationCenter.post(name: .insertImage, object: nil)
        }
    }
}
