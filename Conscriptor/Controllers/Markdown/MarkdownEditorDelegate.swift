//
//  MarkdownEditorDelegate.swift
//  Conscriptor
//
//  Created by David Barsamian on 2/16/22.
//

import Foundation
import AppKit

class MarkdownEditorDelegate: NSObject, NSTextViewDelegate {
    private static let supportedSyntax = ["*", "**", "~~", "`"]

    /// Returns all possible completions for the given word range in the text view.
    /// Since this is meant to handle Markdown syntax completion, this will generally return back
    /// what was passed in.
    ///
    /// The following completions are currently supported:
    /// - For italic syntax "`*`", possible completions include "`*`".
    /// - For bold syntax "`**`", possible completions include "`**`".
    /// - For strikethrough syntax "`~~`", possible completions include "`~~`".
    /// - For inline code syntax "`` ` ``", possible completions include "`` ` ``".
    func textView(_ textView: NSTextView,
                  completions words: [String],
                  forPartialWordRange charRange: NSRange,
                  indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String] {
        // Ensure that words are supported before returning
        guard words.first(where: { Self.supportedSyntax.contains($0) }) != nil else {
            return []
        }
        return words
    }
}
