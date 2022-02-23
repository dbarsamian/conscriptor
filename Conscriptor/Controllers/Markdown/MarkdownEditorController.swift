//
//  MarkdownEditorController.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//

import AppKit
import Foundation

struct MarkdownEditorController {
    /// Iterates over all selected ranges in a `textView`, applying or removing a `style` if found or not found.
    /// Within a selection, if text is found to contain any Markdown syntax defined in `MarkdownFormatter.Formatting`,
    /// then the text will be replaced in the `textView` without the syntax. The opposite is true for text not containing any
    /// Markdown syntax.
    ///
    /// Example: With a selection "`**Text**`" and a style of `.bold`, the function will modify the `textView` to replace
    /// the selection with "`Text`".
    public static func format(_ document: inout ConscriptorDocument,
                              with style: MarkdownFormatter.Formatting,
                              in textView: NSTextView?) {
        guard let textView = textView else {
            return
        }
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            let expandedRange = NSRange(location: range.location - style.rawValue.length,
                                        length: range.length + (style.rawValue.length * 2))
            let selection = document.text[Range(range)!]
            let expandedSelection = document.text[Range(expandedRange)!]

            if MarkdownFormatter.isFormatted(expandedSelection, as: style) {
                let replacement = MarkdownFormatter.format(expandedSelection, style: style)
                textView.insertText(replacement, replacementRange: expandedRange)
            } else {
                let replacement = MarkdownFormatter.format(selection, style: style)
                textView.insertText(replacement, replacementRange: range)
            }
        }
        document.text = textView.string
    }
}
