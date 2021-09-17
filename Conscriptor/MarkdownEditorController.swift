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
            let selection = document.text[range]
            let startIndex = document.text.index(document.text.startIndex, offsetBy: range.startIndex)
            let endIndex = document.text.index(document.text.startIndex, offsetBy: range.endIndex)
            document.text.replaceSubrange(startIndex ..< endIndex, with: MarkdownFormatter.format(selection, style: style))
        }
    }
}
