//
//  CMarkdown.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/14/21.
//

import Foundation

struct CMarkdown {
    // These are from the HighlightedTextEditor package, created by Kyle Nazario and licensed under the MIT License.
    static let boldRegex = "((\\*|_){2})((?!\\1).)+\\1"
    static let italicRegex = "(?<!\\*)(\\*)((?!\\1).)+\\1(?!\\*)"
    static let strikethroughRegex = "(~)((?!\\1).)+\\1"
    static let inlineCodeRegex = "`[^`]*`"
}
