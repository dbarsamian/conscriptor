//
//  MarkdownEditorController.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//

import Foundation
import AppKit

struct MarkdownEditorController {    
    public static func format(_ document: inout ConscriptorDocument, with style: MarkdownFormatter.Formatting, in textView: NSTextView?) {
        guard let textView = textView else {
            return
        }
        // NSValue result is equal to the start position of the selected range, and how long it is in characters.
        let ranges = textView.selectedRanges.map { Range($0.rangeValue) }
        for range in ranges {
            guard let range = range else { return }
            // Use rawValue.length to get expanded range based on syntax operator size
            // Ex. Bold syntax ** is longer than italic syntax *
            let expandedRange = range.startIndex - style.rawValue.length ..< range.endIndex + style.rawValue.length
            let selection = document.text[range]
            let expandedSelection = document.text[expandedRange]
            
            // If the expanded range contains formatting
                // replace expanded subrange with style
            // Else replace the regular range with style
            if (MarkdownFormatter.isFormatted(expandedSelection, as: style)) {
                let startIndex = document.text.index(document.text.startIndex, offsetBy: expandedRange.startIndex)
                let endIndex = document.text.index(document.text.startIndex, offsetBy: expandedRange.endIndex)
                document.text.replaceSubrange(startIndex ..< endIndex, with: MarkdownFormatter.format(expandedSelection, style: style))
            } else {
                let startIndex = document.text.index(document.text.startIndex, offsetBy: range.startIndex)
                let endIndex = document.text.index(document.text.startIndex, offsetBy: range.endIndex)
                document.text.replaceSubrange(startIndex ..< endIndex, with: MarkdownFormatter.format(selection, style: style))
            }
        }
    }
}
