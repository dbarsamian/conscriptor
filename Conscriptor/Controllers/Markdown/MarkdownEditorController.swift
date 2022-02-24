//
//  MarkdownEditorController.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//
//  swiftlint:disable line_length

import AppKit
import Foundation

struct MarkdownEditorController {
    /// Iterates over all selected ranges in a `textView`, applying or removing a `style` if found or not found.
    /// Within a selection, if text is found to contain any Markdown syntax defined in `MarkdownFormatter.Formatting`,
    /// then the text will be replaced in the `textView` without the syntax.
    /// The opposite is true for text not containing any Markdown syntax.
    ///
    /// Example: With a selection "`**Text**`" and a style of `.bold`,
    /// the function will modify the `textView` to replace the selection with "`Text`".
    ///
    /// - Parameters:
    ///     - document: The `ConscriptorDocument` to update
    ///     - style: The `MarkdownFormatter.Formatting` style to apply or remove
    ///     - textView: The `NSTextView` to update
    public static func format(_ document: inout ConscriptorDocument,
                              with style: MarkdownFormatter.Formatting,
                              in textView: NSTextView?) {
        guard let textView = textView else {
            return
        }
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            guard range.length > 0 else {
                return
            }
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

    /// Inserts a Markdown-syntax hyperlink with a given `link` URL and `title` in a `textView`.
    ///
    /// Example: With a `link` URL of "https://www.markdownguide.org" and
    /// a `title` of "Markdown Guide", the function will insert
    /// "`[Markdown Guide](https://www.markdownguide.org)`" at all insertion points.
    ///
    /// - Parameters:
    ///     - link: The URL text to hyperlink to
    ///     - title: The title to give the link
    ///     - textView: The `NSTextView` to update
    ///     - document: The `ConscriptorDocument` to update
    public static func insert(link: String,
                              withTitle title: String,
                              in textView: NSTextView?,
                              update document: inout ConscriptorDocument) {
        guard let textView = textView else {
            return
        }
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            let insertion = "[\(title)](\(link))"
            textView.insertText(insertion, replacementRange: NSRange(location: range.location, length: 0))
        }
        document.text = textView.string
    }

    /// Inserts a Markdown-syntax image with a given `image` URL and `alt` text in a `textView`.
    ///
    /// Example: With a `image` URL of "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/350px-Markdown-mark.svg.png" and
    /// a `alt` of "Markdown Guide Logo", the function will insert
    /// "`![Markdown Guide Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/350px-Markdown-mark.svg.png)`" at all insertion points.
    ///
    /// - Parameters:
    ///     - image: The URL of the image to display
    ///     - alt: The alt text to give the image
    ///     - textView: The `NSTextView` to update
    ///     - document: The `ConscriptorDocument` to update
    public static func insert(image: String,
                              withAlt alt: String,
                              in textView: NSTextView?,
                              update document: inout ConscriptorDocument) {
        guard let textView = textView else {
            return
        }
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            let insertion = "![\(alt)](\(image))"
            textView.insertText(insertion, replacementRange: NSRange(location: range.location, length: 0))
        }
        document.text = textView.string
    }

    /// Inserts a Markdown-syntax `table` of a given size in a `textView`.
    /// The header is taken into consideration when calculating how many rows to insert.
    ///
    /// Example: A `table` of size `(3, 3)` insert the following text:
    /// ```
    /// | Header | Header | Header |
    /// | ------ | ------ | ------ |
    /// | Body   | Body   | Body   |
    /// | Body   | Body   | Body   |
    /// ```
    ///
    /// - Parameters:
    ///     - table: A tuple containing the rows and columns of the table.
    ///     - textView: The `NSTextView` to update
    ///     - document: The `ConscriptorDocument` to update
    public static func insert(table: (Int, Int),
                              in textView: NSTextView?,
                              update document: inout ConscriptorDocument) {
        guard let textView = textView else {
            return
        }

        var insertion = ""
        for row in 0 ..< table.1 + 1 { // Add one to account for header border row
            for _ in 0 ..< table.0 {
                if row == 0 {
                    insertion += "| Header "
                } else if row == 1 {
                    insertion += "| --- "
                } else {
                    insertion += "| Cell "
                }
            }
            insertion += "|\n"
        }

        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            textView.insertText(insertion, replacementRange: NSRange(location: range.location, length: 0))
        }
        document.text = textView.string
    }
}
