//
//  MarkdownEditorController.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//

import AppKit
import Foundation

struct MarkdownEditorController {
    public static func format(_ document: inout ConscriptorDocument,
                              with style: MarkdownFormatter.Formatting,
                              in textView: NSTextView?) {
        guard let textView = textView else {
            return
        }
        // NSValue result is equal to the start position of the selected range, and how long it is in characters.
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            // Use rawValue.length to get expanded range based on syntax operator size
            // Ex. Bold syntax ** is longer than italic syntax *
            let expandedRange = NSRange(location: range.lowerBound - 2, length: range.lowerBound + range.upperBound)
            let selection = document.text[Range(range)!]
            let expandedSelection = document.text[Range(expandedRange)!]

            // If the expanded range contains formatting
            // replace expanded subrange with style
            // Else replace the regular range with style
            if MarkdownFormatter.isFormatted(expandedSelection, as: style) {
                let startIndex = document.text.index(document.text.startIndex, offsetBy: expandedRange.lowerBound)
                let endIndex = document.text.index(document.text.startIndex, offsetBy: expandedRange.upperBound)
                let nsRange = NSRange(startIndex ..< endIndex, in: document.text)
                let replacement = MarkdownFormatter.format(expandedSelection, style: style)
                textView.insertText(replacement, replacementRange: nsRange)
            } else {
                let startIndex = document.text.index(document.text.startIndex, offsetBy: range.lowerBound)
                let endIndex = document.text.index(document.text.startIndex, offsetBy: range.upperBound)
                let nsRange = NSRange(startIndex ..< endIndex, in: document.text)
                let replacement = MarkdownFormatter.format(selection, style: style)
                textView.insertText(replacement, replacementRange: nsRange)
            }
            document.text = textView.string
        }
    }
}
