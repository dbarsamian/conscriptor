//
//  NotificationName+MarkdownEditorView.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//

import Foundation

extension Notification.Name {
    static let formatBold = Notification.Name("formatBold")
    static let formatItalic = Notification.Name("formatItalic")
    static let formatStrikethrough = Notification.Name("formatStrikethrough")
    static let formatInlineCode = Notification.Name("formatInlineCode")
    static let insertImage = Notification.Name("insertImage")
    static let insertLink = Notification.Name("insertLink")
}
